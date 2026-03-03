import Foundation

public struct Tokens {
    public var accessToken: Token
    public var refreshToken: Token

    public init(accessToken: Token, refreshToken: Token) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
