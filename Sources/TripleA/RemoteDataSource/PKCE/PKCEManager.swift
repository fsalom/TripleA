import UIKit
import AuthenticationServices

public final class PKCEManager: NSObject {
    private var storage: StorageProtocol!
    private let prefersEphemeralWebBrowserSession: Bool
    weak var presentationAnchor: ASPresentationAnchor?

    public init(storage: StorageProtocol,
                presentationAnchor: ASPresentationAnchor?,
                prefersEphemeralWebBrowserSession: Bool = true) {
        self.storage = storage
        self.presentationAnchor = presentationAnchor
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }
}

extension PKCEManager: RemoteDataSourceProtocol {
    public func showLogin() {
        let queryItems = [URLQueryItem(name: "next", value: "/auth/authorize?client_id=sPdxLJGjaKg969wRD5gc1IXBP7TbdVm06lJjR3qs&code_challenge_method=S256&response_type=code&scope=read write")]
        guard var authURL = URLComponents(string: "https://dashboard-staging.rudo.es/accounts/login/") else { return }
        authURL.queryItems = queryItems

        let scheme = "app"

        // Initialize the session.
        guard let url = authURL.url else { return }
        print(url.absoluteString)
        DispatchQueue.main.async {
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme)
            { callbackURL, error in
                print(callbackURL)
                print(error)
                // Handle the callback.
            }
            session.prefersEphemeralWebBrowserSession = false
            session.presentationContextProvider = self
            session.start()
        }
    }

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
                            throw AuthError.badRequest
                        }
                    }
                }
            }
        }
        do {
            showLogin()
            return ""
        } catch {
            throw AuthError.badRequest
        }
    }

    public func getRefreshToken(with refreshToken: String) async throws -> String {
        return ""
    }

    public func logout() async {
        storage.removeAll()
        showLogin()
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

extension PKCEManager: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        presentationAnchor ?? ASPresentationAnchor()
    }
}

