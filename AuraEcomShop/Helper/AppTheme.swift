import UIKit

extension UIColor {
    struct AppTheme {
        static let primary = UIColor.systemIndigo
        static let secondary = UIColor.systemBlue
        //static let background = UIColor.systemBackground
        static let background = UIColor.systemGroupedBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let groupedBackground = UIColor.systemGroupedBackground
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let success = UIColor.systemGreen
        static let warning = UIColor.systemOrange
        static let error = UIColor.systemRed
        static let disabled = UIColor.tertiaryLabel
        static let separator = UIColor.separator
        static let surface = UIColor.systemFill
    }
}

struct ThemeManager {
    static func applyGlobalTheme() {
        // UILabel
        UILabel.appearance().textColor = UIColor.AppTheme.textPrimary
        UILabel.appearance().font = FontHelper.roboto(.regular(16))
        
        // UIButton
        UIButton.appearance().titleLabel?.font = FontHelper.roboto(.bold(16))
        UIButton.appearance().tintColor = UIColor.AppTheme.primary
        
        // UITextField
        UITextField.appearance().font = FontHelper.roboto(.medium(16))
        UITextField.appearance().textColor = UIColor.AppTheme.textPrimary
        
        // UINavigationBar
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.prefersLargeTitles = true  // ✅ always large titles globally
        navBarAppearance.tintColor = UIColor.AppTheme.primary
        
        navBarAppearance.titleTextAttributes = [
            .font: FontHelper.roboto(.medium(18)),
            .foregroundColor: UIColor.AppTheme.textPrimary
        ]
        
        navBarAppearance.largeTitleTextAttributes = [
            .font: FontHelper.roboto(.bold(28)),    // ✅ Roboto bold large title
            .foregroundColor: UIColor.AppTheme.textPrimary
        ]
        
        // UITabBar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.AppTheme.secondaryBackground
        
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: FontHelper.roboto(.regular(12)),
            .foregroundColor: UIColor.AppTheme.textSecondary
        ]
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .font: FontHelper.roboto(.medium(12)),
            .foregroundColor: UIColor.AppTheme.primary
        ]
        
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UIColor.AppTheme.primary
        
        // UIBarButtonItem
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [.font: FontHelper.roboto(.regular(16)), .foregroundColor: UIColor.AppTheme.primary],
            for: .normal
        )
    }
}
