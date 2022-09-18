import UIKit

public final class OAuthGrantTypePasswordManager {
    private let storage: StorageProtocol!
    private var startController: UIViewController?
    private var refreshTokenEndpoint: Endpoint
    private var tokensEndpoint: Endpoint

    public init(storage: StorageProtocol, startController: UIViewController, refreshTokenEndpoint: Endpoint, tokensEndPoint: Endpoint ) {
        self.storage = storage
        self.startController = startController
        self.refreshTokenEndpoint = refreshTokenEndpoint
        self.tokensEndpoint = tokensEndPoint
    }
}

extension OAuthGrantTypePasswordManager: RemoteDataSourceProtocol {
    public func getAccessToken() async throws -> String {
        if let accessToken = storage.read(this: .accessToken) {
            return accessToken.value
        }
        do {
            let token = try await load(endpoint: tokensEndpoint, of: TokenDTO.self)
            storage.save(this: token, for: .accessToken)
            return token.accessToken
        } catch {
            throw AuthError.badRequest
        }
    }

    public func getRefreshToken(with refreshToken: String) async throws -> String {
        do {
            refreshTokenEndpoint.parameters["refresh_token"] = refreshToken
            let token = try await load(endpoint: refreshTokenEndpoint, of: TokenDTO.self)
            let accessToken = Token(value: token.accessToken, expireDate: parseDate(from: token.expiresIn))
            storage.save(this: accessToken, for: .accessToken)
            let refreshToken = Token(value: token.refreshToken, expireDate: parseDate(from: token.refreshExpiresIn))
            storage.save(this: refreshToken, for: .refreshToken)
            return token.accessToken
        } catch {
            throw AuthError.badRequest
        }
    }

    public func logout() async {
        storage.removeAll()
        startLogin()
    }

    // MARK: - startLogin
    /**
    go to  login
    */
    public func startLogin() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = scene.windows.first else { return }
        window.rootViewController = self.startController
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

    func parseDate(from value: Int?) -> Date? {
        guard let value = value else {
            return nil
        }
        return Date().addingTimeInterval(Double(value))
    }
}
