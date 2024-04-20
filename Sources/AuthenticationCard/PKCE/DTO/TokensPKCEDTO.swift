import Foundation

public struct TokensPKCEDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let refreshExpiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
    }

    func toBOAccessToken() -> Token {
        print("🔒 ✅ access token: \(self.accessToken)")
        return Token(value: self.accessToken, expireInt: self.expiresIn - 10)
    }

    func toBORefreshToken() -> Token {
        print("🔒 ✅ refresh token: \(self.refreshToken)")
        return Token(value: self.refreshToken, expireInt: self.refreshExpiresIn)
    }
}
