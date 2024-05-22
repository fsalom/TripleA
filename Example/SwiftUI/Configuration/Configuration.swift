import Foundation
import TripleA

class Configuration: TripleAForSwiftUIProtocol {
    var authenticatedTestingEndpoint: Endpoint?

    static var shared = Configuration()

    private static var clientSecret = "ynM8CpvlDHivO1jma1Q3Jv1RIJraBbJ9EtK5XI3dw4RpkxDgi9cZnmJlQs0XzuVCGWCNwQd8qJKAHFrLdHlRRDIzx8B08HJ0Htu6XFzP4kTRTWYIPHuCpldjouJhKvoA"
    private static var clientId = "1gzyJeSOyjUOmbSHREbsothngkBMato1VypQz35D"
    private static var parametersForRefresh = ["grant_type": "refresh_token",
                                               "client_id": clientId,
                                               "client_secret": clientSecret]

    private static var parametersForLogin = ["grant_type": "password",
                                             "client_id": clientId,
                                             "client_secret": clientSecret]

    internal var storage: TokenStorageProtocol = AuthTokenStoreDefault()
    internal var card: AuthenticationCardProtocol = OAuthGrantTypePasswordManager(
        refreshTokenEndpoint: OAuthAPI.refresh(parametersForRefresh).endpoint,
        tokensEndpoint: OAuthAPI.login(parametersForLogin).endpoint)

    lazy var appAuthenticator = AppAuthenticator(
        storage: storage,
        card: card)

    lazy var authenticator: AuthenticatorSUI = AuthenticatorSUI(
        authenticator: appAuthenticator)

    private enum OAuthAPI {
        case login([String: String])
        case refresh([String: String])
        var endpoint: Endpoint {
            get {
                switch self {
                case .login(let parameters):
                    return Endpoint(
                        path: "https://dashboard-staging.rudo.es/auth/token/",
                        httpMethod: .post,
                        parameters: parameters)
                case .refresh(let parameters):
                    return Endpoint(
                        path: "https://dashboard-staging.rudo.es/auth/token/",
                        httpMethod: .post,
                        parameters: parameters)
                }
            }
        }
    }
}
