import UIKit
import PhotosUI
import AVFoundation
import Photos
import ObjectiveC

final class ImagePickerHelper: NSObject {
    
    typealias ImagePickedHandler = (UIImage?) -> Void
    private static var associatedKey: UInt8 = 0
    
    private weak var presenter: UIViewController?
    private var completion: ImagePickedHandler?
    private var allowCamera: Bool = false
    
    // MARK: - Public API
    static func present(from presenter: UIViewController,
                        allowCamera: Bool = false,
                        completion: @escaping ImagePickedHandler) {
        let helper = ImagePickerHelper()
        helper.presenter = presenter
        helper.completion = completion
        helper.allowCamera = allowCamera
        
        // retain helper until finished
        objc_setAssociatedObject(presenter, &ImagePickerHelper.associatedKey, helper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        helper.presentOptions()
    }
    
    // MARK: - Permissions + Options
    private func presentOptions() {
        guard let presenter = presenter else {
            callCompletionAndCleanup(nil)
            return
        }
        
        if !allowCamera {
            checkPhotoLibraryPermission { granted in
                if granted { self.presentPhotoLibrary() }
                else { self.showSettingsAlert(message: "Photo Library access is required to select images.") }
            }
            return
        }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.checkCameraPermission { granted in
                    if granted { self.presentCamera() }
                    else { self.showSettingsAlert(message: "Camera access is required to take photos.") }
                }
            }))
        }
        
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.checkPhotoLibraryPermission { granted in
                if granted { self.presentPhotoLibrary() }
                else { self.showSettingsAlert(message: "Photo Library access is required to select images.") }
            }
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.callCompletionAndCleanup(nil)
        }))
        
        if let pop = sheet.popoverPresentationController {
            pop.sourceView = presenter.view
            pop.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
            pop.permittedArrowDirections = []
        }
        
        presenter.present(sheet, animated: true)
    }
    
    // MARK: - Camera
    private func presentCamera() {
        guard let presenter = presenter else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        presenter.present(picker, animated: true)
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in completion(granted) }
        default:
            completion(false)
        }
    }
    
    // MARK: - Photo Library
    private func presentPhotoLibrary() {
        guard let presenter = presenter else { return }
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        presenter.present(picker, animated: true)
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                completion(newStatus == .authorized || newStatus == .limited)
            }
        default:
            completion(false)
        }
    }
    
    // MARK: - Alert
    private func showSettingsAlert(message: String) {
        guard let presenter = presenter else { return }
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Permission Needed",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }))
            presenter.present(alert, animated: true)
        }
    }
    
    // MARK: - Cleanup
    private func callCompletionAndCleanup(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.completion?(image)
            self.completion = nil
            self.cleanup()
        }
    }
    
    private func cleanup() {
        if let presenter = presenter {
            objc_setAssociatedObject(presenter, &ImagePickerHelper.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Delegates
extension ImagePickerHelper: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            callCompletionAndCleanup(nil)
            return
        }
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            self?.callCompletionAndCleanup(object as? UIImage)
        }
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { self.callCompletionAndCleanup(nil) }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            let img = (info[.originalImage] as? UIImage) ?? (info[.editedImage] as? UIImage)
            self.callCompletionAndCleanup(img)
        }
    }
}
