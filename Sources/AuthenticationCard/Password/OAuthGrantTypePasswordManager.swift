import Foundation
#if canImport(UIKit)
import UIKit

public final class OAuthGrantTypePasswordManager {
    public var refreshTokenEndpoint: Endpoint
    public var tokensEndpoint: Endpoint
    public var logoutEndpoint: Endpoint?

    public init(refreshTokenEndpoint: Endpoint,
                tokensEndpoint: Endpoint,
                logoutEndpoint: Endpoint? = nil) {
        self.refreshTokenEndpoint = refreshTokenEndpoint
        self.tokensEndpoint = tokensEndpoint
        self.logoutEndpoint = logoutEndpoint
    }
}

extension OAuthGrantTypePasswordManager: AuthenticationCardProtocol {
    public func getTokensWithLogin(with parameters: [String : Any]) async throws -> Tokens {
        do {
            parameters.forEach { (key: String, value: Any) in
                tokensEndpoint.parameters[key] = value
            }
            let tokens = try await load(endpoint: tokensEndpoint, of: TokensDTO.self)
            let accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            let refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return Tokens(accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            let errors: [URLError.Code] = [.timedOut,
                                           .notConnectedToInternet,
                                           .dataNotAllowed]
            guard let value = (error as? URLError)?.code else {
                throw error
            }
            if errors.contains(value) {
                throw AuthError.noInternet
            } else {
                throw AuthError.badRequest
            }
        }
    }
    
    public func getNewTokens(with refreshToken: String) async throws -> Tokens {
        do {
            refreshTokenEndpoint.parameters["refresh_token"] = refreshToken
            let tokens = try await load(endpoint: refreshTokenEndpoint, of: TokensDTO.self)
            let accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            let refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return Tokens(accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            let errors: [URLError.Code] = [.timedOut,
                                           .notConnectedToInternet,
                                           .dataNotAllowed]
            guard let value = (error as? URLError)?.code else {
                throw AuthError.badRequest
            }
            if errors.contains(value) {
                throw AuthError.noInternet
            } else {
                throw AuthError.badRequest
                throw AuthError.badRequest
            }
        }
    }

    public func logout() async throws {
        if let logoutEndpoint {
            _ = try await load(endpoint: logoutEndpoint)
        }
    }

    func load<T: Decodable>(endpoint: Endpoint, of type: T.Type = NoContentDTO.self, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: endpoint.request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data, format: .short)
        if (200..<300).contains(response.statusCode) {
            let decoder = JSONDecoder()
            let parseData = try decoder.decode(T.self, from: data)
            return parseData
        } else {
            throw NetworkError.failure(statusCode: response.statusCode,
                                       data: data,
                                       response: response)
        }
    }
}

extension OAuthGrantTypePasswordManager {
    struct NoContentDTO: Codable { }
}
#endif
