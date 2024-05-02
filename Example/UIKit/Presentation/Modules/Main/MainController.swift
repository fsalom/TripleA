import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let cryptoListVC = CryptoListBuilder().build()
        let icon = UITabBarItem(title: "Public API", image: nil, selectedImage: nil)
        cryptoListVC.tabBarItem = icon
        
        let MarvelVC = MarvelBuilder().build()
        let icon1 = UITabBarItem(title: "Marvel API", image: nil, selectedImage: nil)
        MarvelVC.tabBarItem = icon1

        let oauthVC = OAuthBuilder().build()
        let icon2 = UITabBarItem(title: "Oauth", image: nil, selectedImage: nil)
        oauthVC.tabBarItem = icon2

        let viewControllers = [cryptoListVC, MarvelVC, oauthVC]
        self.viewControllers = viewControllers
    }

}
