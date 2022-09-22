import Foundation
import UIKit

public final class Network {
    let baseURL: String
    public let authManager: AuthManager?
    var headers: [String: String] = [:]

    public init(baseURL: String, authManager: AuthManager? = nil, headers: [String: String] = [:]) {
        self.authManager = authManager
        self.headers = headers
        self.baseURL = baseURL
        Persistence.set(.baseURL, baseURL)
    }

    // MARK: -  loadAuthorized
    /**
    Call to protected API adding authorization header and checking for refreshToken if needed

     - Parameters:
        - endpoint: Endpoint with request information
        - type: T of a decodable object
        - allowRetry: Bool in case retry calls is not an option
     - Returns: object of type  `T` already parsed.
     - Throws: An error of type `CustomError`  with extra info
    */
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
                _ = try await authManager.getRefreshToken()
                return try await loadAuthorized(endpoint: endpoint, of: type, allowRetry: false)
            }
        }
        Log.thisResponse(response, data: data)
        let decoder = JSONDecoder()
        var parseData: T!
        do{
            parseData = try decoder.decode(T.self, from: data)
        }catch{
            Log.thisError(NetworkError.errorDecodable)
            throw CustomError(type: .errorDecodable, data: data, code: response.statusCode)
        }
        return parseData
    }

    // MARK: - load
    /**
    Call to unprotected API

     - Parameters:
        - endpoint: Endpoint with request information
        - type: T of a decodable object
        - allowRetry: Bool in case retry calls is not an option
     - Returns: object of type  `T` already parsed.
     - Throws: An error of type `CustomError`  with extra info
    */
    public func load<T: Decodable>(endpoint: Endpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        Log.thisCall(endpoint.request)
        let request = setHeaders(for: endpoint.request)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw CustomError(type: NetworkError.invalidResponse, data: data)
        }
        Log.thisResponse(response, data: data)
        let decoder = JSONDecoder()
        do {
            let parseData = try decoder.decode(T.self, from: data)
            return parseData
        } catch let error {            
            Log.thisError(error)
            throw CustomError(type: NetworkError.errorDecodable, data: data, error: error, code: response.statusCode)
        }
    }

    // MARK: - authorizedRequest
    /**
    Check if authentication is valid and return request with header authorization. In case tokens have expired it will show starting flow controller

     - Parameters:
        - request: URLRequest with information
     - Returns: object of type  `URLRequest` with new headers
     - Throws: An error of type `CustomError`  with extra info
    */
    private func authorizedRequest(from request: URLRequest) async throws -> URLRequest {
        guard let authManager = authManager else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }
        var requestWithHeader = request
        do{
            let token = try await authManager.getCurrentToken()
            requestWithHeader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }catch let error{
            Log.thisError(error)
            await authManager.logout()
        }
        return requestWithHeader
    }

    // MARK: - setHeaders
    /**
    Add all additional headers needed

     - Parameters:
        - request: URLRequest with information
     - Returns: object of type  `URLRequest` with additional headers
    */
    private func setHeaders(for request: URLRequest) -> URLRequest {
        var newRequest = request
        self.headers.forEach { key, value in
            newRequest.addValue(value, forHTTPHeaderField: key)
        }
        return newRequest
    }

    // MARK: - isLogged
    /**
    Indicates if user is logged or not

     - Returns: user logged of type  `Bool`
    */
    public func isLogged() -> Bool{
        return Persistence.get(stringFor: .access_token) != nil ? true : false
    }
}
