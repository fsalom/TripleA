import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let cryptoListStoryboard = UIStoryboard(name: "CryptoListView", bundle: nil)
        let cryptoListVC = cryptoListStoryboard.instantiateViewController(withIdentifier: "CryptoListView")
        let icon = UITabBarItem(title: "Public API", image: nil, selectedImage: nil)
        cryptoListVC.tabBarItem = icon

        let apiKeyStoryboard = UIStoryboard(name: "ApiKeyView", bundle: nil)
        let apikeyVC = apiKeyStoryboard.instantiateViewController(withIdentifier: "ApiKeyView")
        let icon1 = UITabBarItem(title: "Marvel API", image: nil, selectedImage: nil)
        apikeyVC.tabBarItem = icon1

        let oauthStoryboard = UIStoryboard(name: "OAuthView", bundle: nil)
        let oauthVC = oauthStoryboard.instantiateViewController(withIdentifier: "OAuthView")
        let icon2 = UITabBarItem(title: "Oauth", image: nil, selectedImage: nil)
        oauthVC.tabBarItem = icon2

        let viewControllers = [cryptoListVC, apikeyVC, oauthVC]
        self.viewControllers = viewControllers
    }

}
