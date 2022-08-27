import Foundation
import UIKit

public final class Network {
    let baseURL: String
    let authManager: AuthManager?
    var headers: [String: String] = [:]

    public init(baseURL: String, authManager: AuthManager? = nil, headers: [String: String] = [:]) {
        self.authManager = authManager
        self.headers = headers
        self.baseURL = baseURL
        Persistence.set(.baseURL, baseURL)
    }

    // MARK: - loadAuthorized - Call secured API
    public func loadAuthorized<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        guard let authManager = authManager else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }

        var request = try await authorizedRequest(from: endpoint.request)
        request = setHeaders(for: request)
        Log.thisCall(request)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        if response.statusCode == 401{
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await loadAuthorized(endpoint: endpoint, of: type, allowRetry: false)
            }
        }
        Log.thisResponse(response, data: data)
        let decoder = JSONDecoder()
        var parseData: T!
        do{
            parseData = try decoder.decode(T.self, from: data)
        }catch{
            if (200..<300).contains(response.statusCode) {
                Log.thisError(NetworkError.errorDecodable)
                throw NetworkError.errorDecodable
            }else{
                Log.thisError(NetworkError.errorData(data))
                throw NetworkError.errorData(data)
            }
        }
        return parseData
    }

    // MARK: - load - Call unprotected API
    public func load<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let request = setHeaders(for: endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data)
        let decoder = JSONDecoder()
        let parseData = try decoder.decode(T.self, from: data)
        return parseData
    }

    // MARK: - authorizedRequest - get accessToken or refresh token through AuthManager
    private func authorizedRequest(from request: URLRequest) async throws -> URLRequest {
        guard let authManager = authManager else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }
        var requestWithHeader = request
        do{
            let token = try await authManager.validToken()
            requestWithHeader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }catch let error{

            Log.thisError(error)
            Persistence.clear()
            DispatchQueue.main.async {
                Task{
                    UIApplication.shared.windows.first?.rootViewController = await authManager.getLoginViewController()
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
        return requestWithHeader
    }

    // MARK: - setHeaders - add all additional headers needed
    private func setHeaders(for request: URLRequest) -> URLRequest {
        var newRequest = request
        self.headers.forEach { key, value in
            newRequest.addValue(value, forHTTPHeaderField: key)
        }
        return newRequest
    }

    // MARK: - authenticate - social
    public func getToken(for endpoint: Endpoint) async throws -> String {
        guard let authManager = authManager else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }
        do {
            let token = try await load(endpoint: endpoint, of: TokenDTO.self)
            await authManager.save(this: token)
            return token.accessToken
        } catch let error {
            Log.thisError(error)
            guard let errorWithData = error as? NetworkError else { throw AuthError.badRequest }
            switch errorWithData {
            case .errorData(let data):
                throw AuthError.errorData(data)
            default:
                throw AuthError.badRequest
            }
        }
    }

    public func isLogged() -> Bool{
        return Persistence.get(stringFor: .access_token) != nil ? true : false
    }
}
