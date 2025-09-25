import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        // Home
        let homeVC = HomeVC()
        homeVC.navigationItem.title = "Featured Categories"
        let navHome = wrapInNav(
            homeVC,
            tabTitle: "Home",
            image: "house",
            selectedImage: "house.fill"
        )
        
        // Search
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC")
        
        searchVC.navigationItem.title = "Search"
        let navSearch = wrapInNav(
            searchVC,
            tabTitle: "Search",
            image: "magnifyingglass",
            selectedImage: "magnifyingglass"
        )
        
        // Profile
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        
        profileVC.navigationItem.title = "Profile"
        let navProfile = wrapInNav(
            profileVC,
            tabTitle: "Profile",
            image: "person",
            selectedImage: "person.fill"
        )
        
        // Settings
        //let settingsVC = UIViewController()
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingVC")
        settingsVC.navigationItem.title = "Settings"
        let navSettings = wrapInNav(
            settingsVC,
            tabTitle: "Settings",
            image: "gearshape",
            selectedImage: "gearshape.fill"
        )
        
        viewControllers = [navHome, navSearch, navProfile, navSettings]
    }
    
    private func wrapInNav(_ vc: UIViewController,
                               tabTitle: String,
                               image: String,
                               selectedImage: String) -> UINavigationController {
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.prefersLargeTitles = false // ✅ small titles always
            nav.tabBarItem = UITabBarItem(
                title: tabTitle,
                image: UIImage(systemName: image),
                selectedImage: UIImage(systemName: selectedImage)
            )
            return nav
        }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .AppTheme.secondaryBackground
        
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: FontHelper.roboto(.regular(12)),
            .foregroundColor: UIColor.AppTheme.textSecondary
        ]
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .font: FontHelper.roboto(.medium(12)),
            .foregroundColor: UIColor.AppTheme.primary
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .AppTheme.primary
    }
}
