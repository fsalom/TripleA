import Foundation

// MARK: - PKCEConfig - configuration needed for PKCEManager
public struct PKCEConfig {
    var clientID: String
    var clientSecret: String
    var authorizeURL: String
    var logoutURL: String
    var tokenURL: String
    var scope: String
    var codeChallengeMethod: String = "S256"
    var responseType: String = "code"
    var callbackURLScheme: String
    var callbackURLLogoutScheme: String

    public init(clientID: String,
                clientSecret: String,
                authorizeURL: String,
                logoutURL: String,
                tokenURL: String,
                scope: String,
                codeChallengeMethod: String = "S256",
                responseType: String = "code",
                callbackURLScheme: String,
                callbackURLLogoutScheme: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authorizeURL = authorizeURL
        self.logoutURL = logoutURL
        self.tokenURL = tokenURL
        self.scope = scope
        self.codeChallengeMethod = codeChallengeMethod
        self.responseType = responseType
        self.callbackURLScheme = callbackURLScheme
        self.callbackURLLogoutScheme = callbackURLLogoutScheme
    }
}
