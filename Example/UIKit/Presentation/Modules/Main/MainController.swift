import UIKit
import TripleA

class MainController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let cryptoListVC = CryptoListBuilder().build()
        let icon = UITabBarItem(title: "Public API", image: nil, selectedImage: nil)
        cryptoListVC.tabBarItem = icon

        let oauthVC = DeveloperToolsBuilder().buildForUIKit(with: Configuration.shared.authenticator)
        let icon2 = UITabBarItem(title: "Oauth", image: nil, selectedImage: nil)
        oauthVC.tabBarItem = icon2

        let viewControllers = [cryptoListVC, oauthVC]
        self.viewControllers = viewControllers
    }

}
