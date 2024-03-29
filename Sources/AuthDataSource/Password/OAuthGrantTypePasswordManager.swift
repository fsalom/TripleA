import Foundation
#if canImport(UIKit)
import UIKit

public final class OAuthGrantTypePasswordManager {
    private var storage: TokenStorageProtocol!
    private var startController: UIViewController?
    public var refreshTokenEndpoint: Endpoint
    public var tokensEndpoint: Endpoint

    public init(storage: TokenStorageProtocol, startController: UIViewController, refreshTokenEndpoint: Endpoint, tokensEndPoint: Endpoint ) {
        self.storage = storage
        self.startController = startController
        self.refreshTokenEndpoint = refreshTokenEndpoint
        self.tokensEndpoint = tokensEndPoint
    }
}

extension OAuthGrantTypePasswordManager: RemoteDataSourceProtocol {
    public func getAccessToken(with parameters: [String : Any]) async throws -> String {
        if let accessToken = storage.accessToken {
            if accessToken.isValid {
                return accessToken.value
            } else {
                if let refreshToken = storage.refreshToken {
                    if refreshToken.isValid {
                        do {
                            return try await self.getRefreshToken(with: refreshToken.value)
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
                            }
                        }
                    }
                }
            }
        }
        do {
            if parameters.isEmpty {
                showLogin()
                return ""
            }
            parameters.forEach { (key: String, value: Any) in
                tokensEndpoint.parameters[key] = value
            }
            Log.thisCall(tokensEndpoint.request)
            let tokens = try await load(endpoint: tokensEndpoint, of: TokensDTO.self)
            storage.accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            storage.refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return tokens.accessToken
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

    public func getRefreshToken(with refreshToken: String) async throws -> String {
        do {
            refreshTokenEndpoint.parameters["refresh_token"] = refreshToken
            Log.thisCall(refreshTokenEndpoint.request)
            let tokens = try await load(endpoint: refreshTokenEndpoint, of: TokensDTO.self)
            storage.accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            storage.refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return tokens.accessToken
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
            }
        }
    }

    public func logout() async {
        storage.removeAll()
        showLogin()
    }

    public func showLogin() {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = scene.windows.first else { return }
            window.rootViewController = self.startController
            window.makeKeyAndVisible()
        }
    }

    func load<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: endpoint.request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data)
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
#endif
