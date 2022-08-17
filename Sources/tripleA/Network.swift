import Foundation

public final class Network {
    let authManager: AuthManager
    
    public init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - loadAuthorized - Call secured API
    func loadAuthorized<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        let request = try await authorizedRequest(from: endpoint.request)
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
    
    // MARK: - authorizedRequest - get accessToken or refresh token through AuthManager
    private func authorizedRequest(from request: URLRequest) async throws -> URLRequest {
        var requestWithHeader = request
        do{
            let token = try await authManager.validToken()
            requestWithHeader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }catch let error{
            Log.thisError(error)
            DispatchQueue.main.async {
                // TODO: ask for login Controller when authentication fail
            }
        }
        return requestWithHeader
    }
    
}
