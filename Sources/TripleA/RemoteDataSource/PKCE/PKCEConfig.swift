import Foundation

// MARK: - PKCEConfig - configuration needed for PKCEManager
public struct PKCEConfig {
    var clientID: String
    var clientSecret: String
    var authorizeURL: String
    var tokenURL: String
    var scope: String
    var codeChallengeMethod: String = "S256"
    var responseType: String = "code"
    var callbackURLScheme: String

    public init(clientID: String, clientSecret: String, authorizeURL: String, tokenURL: String, scope: String, codeChallengeMethod: String = "S256", responseType: String = "code", callbackURLScheme: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authorizeURL = authorizeURL
        self.tokenURL = tokenURL
        self.scope = scope
        self.codeChallengeMethod = codeChallengeMethod
        self.responseType = responseType
        self.callbackURLScheme = callbackURLScheme
    }
}
