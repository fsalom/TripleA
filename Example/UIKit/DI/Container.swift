import TripleA
import UIKit

class Container {
    weak var window: UIWindow?
    static let shared = Container()

    //NETWORK
    static let network = Network(baseURL: "",
                                 authenticator: Configuration.shared.authenticator,
                                 format: .full)

    init() { }
}

extension Container {
    public static func getLoginController() -> LoginController {
        let storyboard = UIStoryboard(name: "LoginController", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        return LoginVC
    }

    public static func getTabbar() -> MainController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = storyboard.instantiateViewController(withIdentifier: "MainController") as! MainController
        return MainVC
    }
}
