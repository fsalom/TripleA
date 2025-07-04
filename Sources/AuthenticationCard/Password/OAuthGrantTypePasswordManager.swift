import Foundation

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
    public func getTokensWithLogin(with parameters: [String : Any], endpoint: Endpoint? = nil) async throws -> Tokens {
        do {
            var selectedEndpoint: Endpoint = tokensEndpoint
            if let endpoint {
                selectedEndpoint = endpoint
            }
            parameters.forEach { (key: String, value: Any) in
                selectedEndpoint.parameters[key] = value
            }
            let tokens = try await load(endpoint: selectedEndpoint, of: TokensDTO.self)
            let accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            let refreshToken = Token(value: tokens.refreshToken ?? "", expireInt: tokens.refreshExpiresIn)
            return Tokens(accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            throw handle(error)
        }
    }
    
    public func getNewTokens(with refreshToken: String) async throws -> Tokens {
        do {
            refreshTokenEndpoint.parameters["refresh_token"] = refreshToken
            let tokens = try await load(endpoint: refreshTokenEndpoint, of: TokensDTO.self)
            let accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            let refreshToken = Token(value: tokens.refreshToken ?? "", expireInt: tokens.refreshExpiresIn)
            return Tokens(accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            throw handle(error)
        }
    }

    public func logout() async throws {
        if let logoutEndpoint {
            _ = try await load(endpoint: logoutEndpoint)
        }
    }

    private func load<T: Decodable>(endpoint: Endpoint, of type: T.Type = NoContentDTO.self, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: endpoint.request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data, format: .full)
        if (200..<300).contains(response.statusCode) {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } else {
            if response.statusCode == 401 {
                throw AuthError.notAuthorized
            }
            throw NetworkError.failure(statusCode: response.statusCode,
                                       data: data,
                                       response: response)
        }
    }

    private func handle(_ error: Error) -> Error {
        let errors: [URLError.Code] = [.timedOut,
                                       .notConnectedToInternet,
                                       .dataNotAllowed]
        guard let value = (error as? URLError)?.code else {
            return error
        }
        if errors.contains(value) {
            return AuthError.noInternet
        } else {
            return error
        }
    }
}

extension OAuthGrantTypePasswordManager {
    struct NoContentDTO: Codable { }
}
