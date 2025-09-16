import UIKit
import PhotosUI

final class AddCategoryVC: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let stackContent = UIStackView()
    
    private let lblCategoryName = UILabel()
    private let txtCategoryName = UITextField()
    
    private let lblSlug = UILabel()
    private let txtSlug = UITextField()
    
    private let lblDescription = UILabel()
    private let txtDescription = UITextField()
    
    private let lblIsActive = UILabel()
    private let segIsActive = UISegmentedControl(items: ["Yes", "No"])
    
    private let imgPickupPreview: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.AppTheme.primary.cgColor
        iv.layer.borderWidth = 1.5
        iv.layer.cornerRadius = 12
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "DefaultCategoryImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 150),
            iv.heightAnchor.constraint(equalToConstant: 150)
        ])
        return iv
    }()
    
    private let btnImgPickup: UIButton = {
        ButtonHelper.makeButton(
            title: "Select Image",
            style: .primary,
            systemImageName: "photo.on.rectangle.angled"
        )
    }()
    
    private let btnSubmit: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Category", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .AppTheme.success
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return btn
    }()
    
    private var selectedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Category(Admin)"
        view.backgroundColor = .AppTheme.background
        
        setupLayout()
        setupActions()        
    }
 
    // MARK: - Setup Layout
    private func setupLayout() {
        // ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
      
        // StackContent
        scrollView.addSubview(stackContent)
        stackContent.axis = .vertical
        stackContent.spacing = 20
        stackContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackContent.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Add Fields
        addField(label: lblCategoryName, textField: txtCategoryName, title: "Category Name")
        addField(label: lblSlug, textField: txtSlug, title: "Slug")
        addField(label: lblDescription, textField: txtDescription, title: "Description")
        
        // Is Active - Segment
        lblIsActive.text = "Is Active (Make appearance to list)"
        lblIsActive.font = .systemFont(ofSize: 16, weight: .medium)
        lblIsActive.textColor = .AppTheme.textPrimary
        stackContent.addArrangedSubview(lblIsActive)
        
        segIsActive.selectedSegmentIndex = 0
        segIsActive.selectedSegmentTintColor = .AppTheme.primary
        segIsActive.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        stackContent.addArrangedSubview(segIsActive)
        
        // Image
        let imgStack = UIStackView(arrangedSubviews: [imgPickupPreview, btnImgPickup])
        imgStack.axis = .vertical
        imgStack.alignment = .center
        imgStack.spacing = 12
        stackContent.addArrangedSubview(imgStack)
     
        //Custom Font
        lblCategoryName.font = FontHelper.roboto(.medium(16))
        txtCategoryName.font = FontHelper.roboto(.regular(16))
        
        // Submit
        stackContent.addArrangedSubview(btnSubmit)
        btnSubmit.titleLabel?.font = FontHelper.roboto(.bold(16))
    }
    
    private func addField(label: UILabel, textField: UITextField, title: String) {
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .AppTheme.textPrimary
        
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.2
        textField.layer.borderColor = UIColor.AppTheme.separator.cgColor
        textField.textColor = .AppTheme.textPrimary
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let fieldStack = UIStackView(arrangedSubviews: [label, textField])
        fieldStack.axis = .vertical
        fieldStack.spacing = 8
        stackContent.addArrangedSubview(fieldStack)
    }
    
    // MARK: - Actions
    private func setupActions() {
        btnImgPickup.addTarget(self, action: #selector(didTapPickImage), for: .touchUpInside)
        btnSubmit.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        txtSlug.addTarget(self, action: #selector(slugDidChange), for: .editingChanged)
        
    }
    
    @objc private func slugDidChange(_ textField: UITextField) {
        textField.text = textField.text?.lowercased().replacingOccurrences(of: " ", with: "-")
    }
    
    
    /*
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 1
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    present(picker, animated: true)
     */
    @objc private func didTapPickImage() {
        ImagePickerHelper.present(from: self) { [weak self] image in
            guard let self = self else { return }
            if let pickedImage = image {
                self.selectedImage = pickedImage
                self.imgPickupPreview.image = pickedImage
            } else {
                print("❌ No image selected")
            }
        }
    }
    
    @objc private func didTapSave() {
        guard let name = txtCategoryName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            showError("Category Name is required"); return
        }
        guard let slug = txtSlug.text?.trimmingCharacters(in: .whitespacesAndNewlines), !slug.isEmpty else {
            showError("Slug is required"); return
        }
        guard let desc = txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines), !desc.isEmpty else {
            showError("Description is required"); return
        }
        guard let image = selectedImage ?? imgPickupPreview.image else {
            showError("Image is required"); return
        }
        
        Loader.shared.show(in: view)
        FirebaseHelper.shared.addCategory(
            name: name,
            slug: slug,
            description: desc,
            isActive: segIsActive.selectedSegmentIndex == 0,
            image: image
        ) { [weak self] result in
            DispatchQueue.main.async {
                Loader.shared.hide()
                switch result {
                case .success:
                     
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        //showAlert(message: "Validation Error \(message)")
    }
    
    /*
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func endEditing() { view.endEditing(true) }
     */
}
/*
// MARK: - Image Picker
extension AddCategoryVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            
        }
    }
}
 */
