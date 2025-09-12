//
//  AddCategoryViewController.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit
import PhotosUI

final class AddCategoryViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let nameField = UITextField()
    
    private let slugLabel = UILabel()
    private let slugField = UITextField()
    
    private let descriptionLabel = UILabel()
    private let descriptionField = UITextField()
    
    private let isActiveLabel = UILabel()
    private let isActiveControl = UISegmentedControl(items: ["Yes","No"])
    
    private let saveButton: UIButton = {
        return ButtonHelper.makeRoundedButton(
            title: "Save Category",
            backgroundColor: .systemBlue,
            textColor: .white,
        )
    }()
    private let imageView = UIImageView()
    
    private let pickImageButton: UIButton = {
        let cameraIcon = UIImage(systemName: "photo.on.rectangle.angled")
        return ButtonHelper.makeRoundedButton(
            title: "Select Image",
            backgroundColor: .lightGray,
            textColor: .white,
            image: cameraIcon
        )
    }()
    private var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Category"
        view.backgroundColor = .systemBackground
        setupViews()
        setupActions()
        hideKeyboardOnTap()
        slugField.addTarget(self, action: #selector(slugFieldDidChange), for: .editingChanged)
    }
    @objc private func slugFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.lowercased()
        }
    }
    private func setupViews() {
        [nameLabel, nameField,
         slugLabel, slugField,
         descriptionLabel, descriptionField,
         isActiveLabel, isActiveControl,
         pickImageButton, imageView,
         saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Labels
        nameLabel.text = "Category Name"
        slugLabel.text = "Slug"
        descriptionLabel.text = "Description"
        isActiveLabel.text = "Is Active"
        
        // Fields
        [nameField, slugField, descriptionField].forEach { tf in
            tf.borderStyle = .roundedRect
            tf.layer.cornerRadius = 8
            tf.layer.borderWidth = 1
            tf.layer.borderColor = UIColor.systemGray.cgColor
            tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        isActiveControl.selectedSegmentIndex = 0
       
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "DefaultCategoryImage")
        imageView.clipsToBounds = true
      
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Layout constraints (using vertical stacking)
        let margin: CGFloat = 20
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            slugLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            slugLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            slugLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            slugField.topAnchor.constraint(equalTo: slugLabel.bottomAnchor, constant: 8),
            slugField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            slugField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: slugField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            isActiveLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 16),
            isActiveLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            isActiveLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            isActiveControl.topAnchor.constraint(equalTo: isActiveLabel.bottomAnchor, constant: 8),
            isActiveControl.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            isActiveControl.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            pickImageButton.topAnchor.constraint(equalTo: isActiveControl.bottomAnchor, constant: 16),
            pickImageButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            pickImageButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: pickImageButton.bottomAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: pickImageButton.centerXAnchor), // ✅ center horizontally
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 150),
             
            
            saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func setupActions() {
        pickImageButton.addTarget(self, action: #selector(didTapPickImage), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    @objc private func didTapPickImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapSave() {
        guard let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            showError("Category Name is required"); return
        }
        guard let slug = slugField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-"),
            !slug.isEmpty else {
                showError("Slug is required"); return
        }
        guard let description = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty else {
            showError("Description is required"); return
        }
        guard let image = selectedImage else {
            showError("Image is required"); return
        }
        
        Loader.shared.show(in: view)
        
        FirebaseHelper.shared.addCategoryWithInlineImage(
            name: name,
            slug: slug,
            description: description,
            isActive: isActiveControl.selectedSegmentIndex == 0,
            image: image
        ) { [weak self] result in
            guard let self = self else { return }
            Loader.shared.hide()
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func endEditing() { view.endEditing(true) }
}

extension AddCategoryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            DispatchQueue.main.async {
                if let image = object as? UIImage {
                    self?.selectedImage = image
                    self?.imageView.image = image
                   
                }
            }
        }
    }
}
