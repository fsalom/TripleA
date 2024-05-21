import Foundation

public struct TokensDTO: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int?
    let refreshExpiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
    }

    func toBOAccessToken() -> Token {
        print("🔒 ✅ access token: \(self.accessToken)")
        var expiresIn = self.expiresIn ?? nil
        return Token(value: self.accessToken, expireInt: expiresIn)
    }

    func toBORefreshToken() -> Token {
        print("🔒 ✅ refresh token: \(self.refreshToken ?? "")")
        return Token(value: self.refreshToken ?? self.accessToken, expireInt: self.refreshExpiresIn)
    }
}
