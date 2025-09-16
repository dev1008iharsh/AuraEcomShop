//
//  SearchHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

final class SearchHelper: NSObject {
    
    typealias SearchHandler = (String?) -> Void
    
    private weak var presenter: UIViewController?
    private var searchController: UISearchController!
    private var onSearch: SearchHandler?
    
    // MARK: - Setup
    static func attach(to presenter: UIViewController,
                       placeholder: String = "Search",
                       onSearch: @escaping SearchHandler) -> UISearchController {
        
        let helper = SearchHelper()
        helper.presenter = presenter
        helper.onSearch = onSearch
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
        searchController.searchResultsUpdater = helper
        searchController.searchBar.delegate = helper
        
        helper.searchController = searchController
        
        // Retain helper for lifecycle
        objc_setAssociatedObject(presenter,
                                 "[SearchHelper]",
                                 helper,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        presenter.navigationItem.searchController = searchController
        presenter.navigationItem.hidesSearchBarWhenScrolling = false
        
        return searchController
    }
    
    // MARK: - Highlight helper
    static func highlight(text: String,
                          searchQuery: String?,
                          highlightColor: UIColor = .AppTheme.primary,
                          font: UIFont = FontHelper.roboto(.medium(13)),
                          highlightFont: UIFont = FontHelper.roboto(.bold(13))) -> NSAttributedString {
        
        guard let query = searchQuery?.lowercased(),
              !query.isEmpty else {
            return NSAttributedString(string: text,
                                      attributes: [
                                        .foregroundColor: UIColor.AppTheme.textPrimary,
                                        .font: font
                                      ])
        }
        
        let attributed = NSMutableAttributedString(string: text,
                                                   attributes: [
                                                    .foregroundColor: UIColor.AppTheme.textPrimary,
                                                    .font: font
                                                   ])
        
        let range = (text.lowercased() as NSString).range(of: query)
        if range.location != NSNotFound {
            attributed.addAttributes([
                .foregroundColor: highlightColor,
                .font: highlightFont
            ], range: range)
        }
        
        return attributed
    }
}

// MARK: - Delegates
extension SearchHelper: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        onSearch?(query?.isEmpty == true ? nil : query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearch?(nil)
    }
}
