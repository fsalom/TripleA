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
}
