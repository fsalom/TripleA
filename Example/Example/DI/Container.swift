import TripleA
import UIKit

class Container {
    weak var window: UIWindow?
    static let shared = Container()

    //MARK: - CONFIGURATION NETWORK
    //STORAGE
    static let storage = AuthTokenStoreDefault()
    //PARAMETERS LOGIN REFRESH
    static let parametersLogin = ["": ""]
    static let parametersRefresh = ["grant_type": "refresh_token",
                                    "client_id": "1gzyJeSOyjUOmbSHREbsothngkBMato1VypQz35D",
                                    "client_secret": "ynM8CpvlDHivO1jma1Q3Jv1RIJraBbJ9EtK5XI3dw4RpkxDgi9cZnmJlQs0XzuVCGWCNwQd8qJKAHFrLdHlRRDIzx8B08HJ0Htu6XFzP4kTRTWYIPHuCpldjouJhKvoA"]
    //REMOTE DATA SOURCE
    static let remoteDataSource = OAuthGrantTypePasswordManager(storage: Container.storage,
                                                                startController: getLoginController(),
                                                                refreshTokenEndpoint: OAuthAPI.refresh(parametersRefresh).endpoint,
                                                                tokensEndPoint: OAuthAPI.login(parametersLogin).endpoint)

    static let config = PKCEConfig(clientID: "sPdxLJGjaKg969wRD5gc1IXBP7TbdVm06lJjR3qs",
                                   clientSecret: "3XfwaCKMOs5pwvy84qc87mKc5tNTkABKAvCfjsnqd1T2ezBNDAmUnsKeWuQ9xMAGZn8WzRMhPJ08spD47zz4GFm5Z0zy0rIlw4W6W0ynA5rc0fY8OdMAaz9lYVqGxhZi",
                                   authorizeURL: "https://dashboard-staging.rudo.es/accounts/login/",
                                   tokenURL: "https://dashboard-staging.rudo.es/auth/token/",
                                   scope: "write read",
                                   codeChallengeMethod: "S256",
                                   responseType: "code",
                                   callbackURLScheme: "app")
    static let PKCEDataSource = PKCEManager(storage: Container.storage, presentationAnchor: nil, config: config )
    //AUTHMANAGER
    let authManager = AuthManager(storage: Container.storage,
                                  remoteDataSource: Container.PKCEDataSource,
                                  parameters: [:])
    //NETWORK
    static let network = Network(baseURL: "https://dashboard.rudo.es/",
                                 authManager: Container.shared.authManager,
                                 format: .short)
    
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
