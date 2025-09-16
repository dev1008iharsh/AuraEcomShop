import UIKit
import NVActivityIndicatorView

final class Loader {
    
    static let shared = Loader()
    private var loaderView: NVActivityIndicatorView?
    private var containerView: UIView?
    
    private init() {}
    
    func show(in view: UIView) {
        hide()
        
        let container = UIView(frame: view.bounds)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60),
                                             type: .ballClipRotate,
                                             color: .AppTheme.primary,
                                             padding: 0)
        loader.center = container.center
        
        container.addSubview(loader)
        view.addSubview(container)
        
        loader.startAnimating()
        
        self.loaderView = loader
        self.containerView = container
    }
    
    func hide() {
        loaderView?.stopAnimating()
        containerView?.removeFromSuperview()
        loaderView = nil
        containerView = nil
    }
}
