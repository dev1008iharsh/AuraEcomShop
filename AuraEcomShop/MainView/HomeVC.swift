//
//  HomeVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

final class HomeVC: UIViewController {
    
    private var categories: [Category] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        // ✅ Add left/right padding
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        
        setupNavBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setupNavBar() {
        // Create a bar button item on the right
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(didTapAddCategory))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAddCategory() {
        let addCategoryVC = AddCategoryViewController()
        navigationController?.pushViewController(addCategoryVC, animated: true)
    }
    
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        Loader.shared.show(in: view)
        FirebaseHelper.shared.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                Loader.shared.hide()
                switch result {
                case .success(let categories):
                    // ✅ Only keep active categories
                    self?.categories = categories.filter { $0.isActive }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("❌ Failed to fetch categories: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - CollectionView

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3      // 👈 We want 3 cells in each row
        let spacing: CGFloat = 12         // 👈 Spacing between cells
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            // 1️⃣ Calculate total horizontal spacing:
            // - (itemsPerRow - 1) * spacing → spaces between cells
            // - sectionInset.left + sectionInset.right → padding at left/right edges
            let totalSpacing = (itemsPerRow - 1) * spacing +
            layout.sectionInset.left +
            layout.sectionInset.right
            
            // 2️⃣ Subtract total spacing from full collectionView width
            // → gives us the remaining space that can be shared by all cells
            let availableWidth = collectionView.bounds.width - totalSpacing
            
            // 3️⃣ Divide the available width equally across the number of cells
            let itemWidth = floor(availableWidth / itemsPerRow)
            
            // 4️⃣ Make cells square (width = height)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
        // Fallback if layout cast fails
        return CGSize(width: 100, height: 100)
    }
}
