//
//  Untitled.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

final class RefreshControlHelper {
    
    /// Attach a themed UIRefreshControl to any UIScrollView
    /// - Parameters:
    ///   - scrollView: UITableView or UICollectionView
    ///   - target: usually self (ViewController)
    ///   - action: selector to call on refresh
    static func attachThemed(to scrollView: UIScrollView,
                             target: Any,
                             action: Selector) -> UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .AppTheme.primary
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        scrollView.refreshControl = refreshControl
        return refreshControl
    }
    
    /// End refresh safely
    static func endRefreshing(_ refreshControl: UIRefreshControl?) {
        DispatchQueue.main.async {
            refreshControl?.endRefreshing()
        }
    }
}
