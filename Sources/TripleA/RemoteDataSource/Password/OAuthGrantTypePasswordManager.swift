import UIKit

public final class OAuthGrantTypePasswordManager {
    private var storage: StorageProtocol!
    private var startController: UIViewController?
    public var refreshTokenEndpoint: Endpoint
    public var tokensEndpoint: Endpoint

    public init(storage: StorageProtocol, startController: UIViewController, refreshTokenEndpoint: Endpoint, tokensEndPoint: Endpoint ) {
        self.storage = storage
        self.startController = startController
        self.refreshTokenEndpoint = refreshTokenEndpoint
        self.tokensEndpoint = tokensEndPoint
    }
}

extension OAuthGrantTypePasswordManager: RemoteDataSourceProtocol {
    public func getAccessToken(with parameters: [String : Any]) async throws -> String {
        if let accessToken = storage.accessToken {
            return accessToken.value
        }
        do {
            parameters.forEach { (key: String, value: Any) in
                tokensEndpoint.parameters[key] = value
            }

            let tokens = try await load(endpoint: tokensEndpoint, of: TokensDTO.self)
            storage.accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            storage.refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return tokens.accessToken
        } catch {
            throw AuthError.badRequest
        }
    }

    public func getRefreshToken(with refreshToken: String) async throws -> String {
        do {
            refreshTokenEndpoint.parameters["refresh_token"] = refreshToken
            let tokens = try await load(endpoint: refreshTokenEndpoint, of: TokensDTO.self)
            storage.accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
            storage.refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
            return tokens.accessToken
        } catch {
            throw AuthError.badRequest
        }
    }

    public func logout() async {
        storage.removeAll()        
    }

    public func showLogin() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = scene.windows.first else { return }
        window.rootViewController = startController
        window.makeKeyAndVisible()        
    }

    func load<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: endpoint.request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data)
        let decoder = JSONDecoder()
        let parseData = try decoder.decode(T.self, from: data)
        return parseData
    }
}
