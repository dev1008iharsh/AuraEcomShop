import UIKit

final class HomeVC: UIViewController {
    
    private var allCategories: [Category] = []
    private var filteredCategories: [Category] = []
    private var isSearching: Bool = false
    private var currentSearchQuery: String? = nil
    
    private var refreshControl: UIRefreshControl?
    
    private let categoryCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Featured Categories"
        view.backgroundColor = .AppTheme.background
        
        setupCollectionView()
        setupNavBar()
        setupSearch()
        setupRefreshControl()
        /*
        guard UIApplication.shared.supportsAlternateIcons else {
                    showAlert(title: "Error", message: "This device does not support changing app icons.")
                    return
                }*/
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(showLoader: true)
    }
    
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddCategory))

        let changeIconBtn = UIBarButtonItem(image: UIImage(systemName: "app.badge"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapChangeAppIcon))

        navigationItem.rightBarButtonItems = [addButton, changeIconBtn]
    }
    
    @objc private func didTapChangeAppIcon() {
        let vc = ChangeAppIconVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSearch() {
        SearchHelper.attach(to: self, placeholder: "Search Categories") { [weak self] query in
            guard let self = self else { return }
            
            if let q = query?.lowercased(), !q.isEmpty {
                self.filteredCategories = self.allCategories.filter {
                    $0.name.lowercased().contains(q) || $0.slug.lowercased().contains(q)
                }
                self.isSearching = true
                self.currentSearchQuery = q
            } else {
                self.filteredCategories = self.allCategories
                self.isSearching = false
                self.currentSearchQuery = nil
            }
            
            self.categoryCV.reloadData()
        }
    }
    
    private func setupCollectionView() {
        categoryCV.translatesAutoresizingMaskIntoConstraints = false
        categoryCV.backgroundColor = .AppTheme.background
        categoryCV.delegate = self
        categoryCV.dataSource = self
        categoryCV.register(CategoryCVC.self, forCellWithReuseIdentifier: "CategoryCVC")
        
        view.addSubview(categoryCV)
        NSLayoutConstraint.activate([
            categoryCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl = RefreshControlHelper.attachThemed(to: categoryCV,
                                                           target: self,
                                                           action: #selector(refreshData))
    }
    
    @objc private func refreshData() {
        fetchData(showLoader: false)
    }
    
    private func fetchData(showLoader: Bool) {
        if showLoader { Loader.shared.show(in: view) }
        
        FirebaseHelper.shared.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                Loader.shared.hide()
                RefreshControlHelper.endRefreshing(self?.refreshControl)
                
                switch result {
                case .success(let categories):
                    let active = categories.filter { $0.isActive }
                    self?.allCategories = active
                    self?.filteredCategories = active
                    self?.categoryCV.reloadData()
                case .failure(let error):
                    print("❌ Failed to fetch categories: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func didTapAddCategory() {
        let addVC = AddCategoryVC()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

// MARK: - UICollectionView
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredCategories.count : allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategoryCVC", for: indexPath
        ) as? CategoryCVC else {
            return UICollectionViewCell()
        }
        let category = isSearching ? filteredCategories[indexPath.item] : allCategories[indexPath.item]
        cell.configure(with: category, searchQuery: currentSearchQuery)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 12
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpacing = (itemsPerRow - 1) * spacing + layout.sectionInset.left + layout.sectionInset.right
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = floor(availableWidth / itemsPerRow)
            return CGSize(width: itemWidth, height: itemWidth) // 1:1 ratio
        }
        return CGSize(width: 100, height: 100)
    }
}
