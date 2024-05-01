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
    static let oauthCard = OAuthGrantTypePasswordManager(storage: Container.storage,
                                                         startController: getLoginController(),
                                                         refreshTokenEndpoint: OAuthAPI.refresh(parametersRefresh).endpoint,
                                                         tokensEndpoint: OAuthAPI.login(parametersLogin).endpoint)

    static let config = PKCEConfig(clientID: "vW6QyPMdId5NlGRNqbULm0YFWk0hq6VMWBDWSovp",
                                   clientSecret: "9ElafIEJbecCbk83t0SNYobrSMdD6mKUvgIwOE1vkWOqHvqhcWtCBZV1tGB9wJNi81EYLUwV8kSfIbQb12AhZAgGCl8gfpYh5Tr8o45iuNC97Ucizac32qySLe9lhdJ3",
                                   authorizeURL: "https://dashboard-staging.rudo.es/accounts/login/",
                                   logoutURL: "https://dashboard-staging.rudo.es/accounts/logout/",
                                   tokenURL: "https://dashboard-staging.rudo.es/auth/token/",
                                   scope: "write read",
                                   codeChallengeMethod: "S256",
                                   responseType: "code",
                                   callbackURLScheme: "app://auth",
                                   callbackURLLogoutScheme: "app://auth")
    static let PKCECard = PKCEManager(storage: Container.storage, presentationAnchor: nil, config: config )
    //AUTHMANAGER
    let authManager = AuthManager(storage: Container.storage,
                                  card: Container.oauthCard,
                                  entryViewController: getLoginController())
    //NETWORK
    static let network = Network(baseURL: "https://dashboard-staging.rudo.es/",
                                 authManager: Container.shared.authManager,
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
