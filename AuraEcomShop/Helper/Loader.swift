//
//  Loader.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit
import NVActivityIndicatorView

final class Loader {
    static let shared = Loader()
    private var indicatorView: NVActivityIndicatorView?
    private var backgroundView: UIView?
    
    private init() {}
    
    func show(in view: UIView, type: NVActivityIndicatorType = .ballScaleMultiple, color: UIColor = .systemBlue, size: CGSize = CGSize(width: 60, height: 60)) {
        DispatchQueue.main.async {
            // Prevent duplicate
            if self.backgroundView != nil { return }
            
            // Semi-transparent overlay
            let bg = UIView(frame: view.bounds)
            bg.backgroundColor = UIColor(white: 0, alpha: 0.3)
            bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let frame = CGRect(x: (view.bounds.width - size.width)/2,
                               y: (view.bounds.height - size.height)/2,
                               width: size.width,
                               height: size.height)
            
            let indicator = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: 0)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            bg.addSubview(indicator)
            view.addSubview(bg)
            
            // Center constraints
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: bg.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: bg.centerYAnchor),
                indicator.widthAnchor.constraint(equalToConstant: size.width),
                indicator.heightAnchor.constraint(equalToConstant: size.height)
            ])
            
            indicator.startAnimating()
            
            self.indicatorView = indicator
            self.backgroundView = bg
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.indicatorView?.stopAnimating()
            self.backgroundView?.removeFromSuperview()
            self.indicatorView = nil
            self.backgroundView = nil
        }
    }
}
