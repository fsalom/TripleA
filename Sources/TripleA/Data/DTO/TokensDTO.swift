import Foundation

public struct TokensDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let refreshExpiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
    }

    func toBOAccessToken() -> Token {
        return Token(value: self.accessToken, expireInt: self.expiresIn)
    }

    func toBORefreshToken() -> Token {
        return Token(value: self.refreshToken, expireInt: self.refreshExpiresIn)
    }
}
