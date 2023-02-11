import UIKit
import AuthenticationServices
import CommonCrypto

public final class PKCEManager: NSObject {
    private var storage: StorageProtocol!
    private let SSO: Bool
    private let config: PKCEConfig!
    weak var presentationAnchor: ASPresentationAnchor?

    private var codeVerifier: String = ""

    public init(storage: StorageProtocol,
                presentationAnchor: ASPresentationAnchor?,
                SSO: Bool = true,
                config: PKCEConfig) {
        self.storage = storage
        self.presentationAnchor = presentationAnchor
        self.SSO = !SSO
        self.config = config
    }

    private func getCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64URLEscapedEncodedString()
    }

    private func getCodeChallenge(for codeVerifier: String) -> String? {
        guard let data = codeVerifier.data(using: .utf8) else { return nil }
        var buffer2 = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &buffer2)
        }
        let hash = Data(buffer2)
        return hash.base64URLEscapedEncodedString()
    }
}

extension PKCEManager: RemoteDataSourceProtocol {
    public func showLogin(completion: @escaping (String?) -> Void) {
        codeVerifier = getCodeVerifier()
        let queryItems = [URLQueryItem(name: "next", value: "/auth/authorize?client_id=\(config.clientID)&code_challenge_method=\(config.codeChallengeMethod)&response_type=\(config.responseType)&scope=\(config.scope)&code_challenge=\(getCodeChallenge(for: codeVerifier))")]
        guard var authURL = URLComponents(string: config.authorizeURL) else { return }
        authURL.queryItems = queryItems

        let scheme = config.callbackURLScheme

        // Initialize the session.
        guard let url = authURL.url else { return }
        print(url.absoluteString)
        DispatchQueue.main.async {
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
                guard error == nil, let callbackURL = callbackURL else {
                    let msg = error?.localizedDescription.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    return
                }
                guard let urlComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                      let queryItems = urlComponents.queryItems else { return }
                for queryItem in queryItems {
                    if(queryItem.name == "code"){
                        completion(queryItem.value)
                        return
                    }
                }
                completion(nil)
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
            let code = await withCheckedContinuation { continuation in
                self.showLogin(completion: { code in
                    continuation.resume(returning: code)
                })
            }
            return try await getToken(with: code)
        } catch {
            throw AuthError.badRequest
        }
    }

    public func getToken(with code: String?) async throws -> String {
        guard let code else { throw NetworkError.invalidResponse }
        let parameters = [
            "grant_type": "authorization_code",
            "client_id": self.config.clientID,
            "client_secret": self.config.clientSecret,
            "code": code,
            "redirect_uri": self.config.callbackURLScheme,
            "code_verifier": self.codeVerifier,
        ]

        let endpoint = Endpoint(path: self.config.tokenURL,
                                httpMethod: .post,
                                parameters: parameters)


        let tokens = try await self.load(endpoint: endpoint, of: TokensDTO.self)
        storage.accessToken = Token(value: tokens.accessToken, expireInt: tokens.expiresIn)
        storage.refreshToken = Token(value: tokens.refreshToken, expireInt: nil)
        return tokens.accessToken
    }

    public func getRefreshToken(with refreshToken: String) async throws -> String {
        return ""
    }

    public func logout() async {
        storage.removeAll()
        try? await self.getAccessToken(with: [:])
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

fileprivate extension Data {
    func base64URLEscapedEncodedString() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}

