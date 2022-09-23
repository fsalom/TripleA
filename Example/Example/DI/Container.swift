import TripleA
import UIKit

class Container {
    weak var window: UIWindow?
    static let shared = Container()

    static let storage = AuthTokenStoreDefault()
    static let parametersLogin = ["": ""]
    static let parametersRefresh = ["": ""]
    static let remoteDataSource = OAuthGrantTypePasswordManager(storage: Container.storage,
                                                                startController: getLoginController(),
                                                                refreshTokenEndpoint: OAuthAPI.refresh(parametersRefresh).endpoint,
                                                                tokensEndPoint: OAuthAPI.login(parametersLogin).endpoint)
    let authManager = AuthManager(storage: Container.storage,
                                  remoteDataSource: Container.remoteDataSource,
                                  parameters: [:])
    static let network = Network(baseURL: "https://dashboard.rudo.es/", authManager: Container.shared.authManager)
    
    init() { }
}

extension Container {
    public static func getLoginController() -> LoginController {
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        return LoginVC
    }

    public static func getTabbar() -> MainController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = storyboard.instantiateViewController(withIdentifier: "MainController") as! MainController
        return MainVC
    }
}
