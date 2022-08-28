import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let cryptoListStoryboard = UIStoryboard(name: "CryptoListView", bundle: nil)
        let cryptoListVC = cryptoListStoryboard.instantiateViewController(withIdentifier: "CryptoListView")
        let icon = UITabBarItem(title: "public API", image: nil, selectedImage: nil)
        cryptoListVC.tabBarItem = icon

        let cryptoListVC2 = cryptoListStoryboard.instantiateViewController(withIdentifier: "CryptoListView")
        let icon1 = UITabBarItem(title: "oauth API", image: nil, selectedImage: nil)
        cryptoListVC2.tabBarItem = icon1

        let viewControllers = [cryptoListVC, cryptoListVC2]
        self.viewControllers = viewControllers
    }

}
