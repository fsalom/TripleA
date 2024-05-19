import Foundation
import TripleA

class Configuration: TripleAForUIKitProtocol {
    static var shared = Configuration()

    internal var storage: TokenStorageProtocol = AuthTokenStoreDefault()

    internal let config = PKCEConfig(clientID: "vW6QyPMdId5NlGRNqbULm0YFWk0hq6VMWBDWSovp",
                                   clientSecret: "9ElafIEJbecCbk83t0SNYobrSMdD6mKUvgIwOE1vkWOqHvqhcWtCBZV1tGB9wJNi81EYLUwV8kSfIbQb12AhZAgGCl8gfpYh5Tr8o45iuNC97Ucizac32qySLe9lhdJ3",
                                   authorizeURL: "https://dashboard-staging.rudo.es/accounts/login/",
                                   logoutURL: "https://dashboard-staging.rudo.es/accounts/logout/",
                                   tokenURL: "https://dashboard-staging.rudo.es/auth/token/",
                                   scope: "write read",
                                   codeChallengeMethod: "S256",
                                   responseType: "code",
                                   callbackURLScheme: "app://auth",
                                   callbackURLLogoutScheme: "app://auth")

    lazy var PKCECard = PKCEManager(presentationAnchor: nil, config: config )


    internal var card: AuthenticationCardProtocol = OAuthGrantTypePasswordManager(
        refreshTokenEndpoint: OAuthAPI.refresh.endpoint,
        tokensEndpoint: OAuthAPI.login.endpoint)

    lazy var appAuthenticator = AppAuthenticator(
        storage: storage,
        card: card)

    lazy var authenticator = AuthenticatorUIKit(
        authenticator: appAuthenticator,
        entryViewController: Container.getLoginController())

    private enum OAuthAPI {
        case login
        case refresh
        var endpoint: Endpoint {
            get {
                switch self {
                case .login:
                    let parameters = ["grant_type": "password",
                                      "client_id": Constants.clientId,
                                      "client_secret": Constants.clientSecret]
                    return Endpoint(
                        path: "https://dashboard-staging.rudo.es/auth/token/",
                        httpMethod: .post,
                        parameters: parameters)
                case .refresh:
                    let parameters = ["grant_type": "refresh_token",
                                      "client_id": Constants.clientId,
                                      "client_secret": Constants.clientSecret]
                    return Endpoint(
                        path: "https://dashboard-staging.rudo.es/auth/token/",
                        httpMethod: .post,
                        parameters: parameters)
                }
            }
        }
    }
}
