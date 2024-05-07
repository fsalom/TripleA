import Foundation

public struct Tokens {
    var accessToken: Token
    var refreshToken: Token

    public init(accessToken: Token, refreshToken: Token) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
