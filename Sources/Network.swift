import Foundation

@available(macOS 10.15, *)
open class Network {
    var baseURL: String = ""
    public let authenticator: AuthenticatorProtocol?
    var additionalHeaders: [String: String] = [:]
    var format: LogFormat!
    var session: URLSession

    public init(baseURL: String = "",
                authenticator: AuthenticatorProtocol? = nil,
                headers: [String: String] = [:],
                format: LogFormat = .full,
                session: URLSession = URLSession.shared) {
        self.authenticator = authenticator
        self.additionalHeaders = headers
        self.baseURL = baseURL
        self.format = format
        self.session = session
    }

    // MARK: -  loadAuthorized
    /**
    Call to protected API adding authorization header and checking for refreshToken if needed

     - Parameters:
        - endpoint: Endpoint with request information
        - type: T of a decodable object
        - allowRetry: Bool in case retry calls is not an option
     - Returns: object of type  `T` already parsed.x
     - Throws: An error of type `CustomError`  with extra info
    */
    open func loadAuthorized<T: Decodable>(this endpoint: Endpoint,
                                           of type: T.Type? = AuthNoReply.self) async throws -> T {
        var modifiedEndpoint: Endpoint = endpoint
        modifiedEndpoint.addExtra(headers: additionalHeaders)
        modifiedEndpoint.addBaseURLIfNeeded(url: baseURL)
        do {
            let request = try await authorize(this: modifiedEndpoint.request)
            Log.thisCall(request, format: format)
            let (data, urlResponse) = try await session.data(for: request)
            guard let response = urlResponse as? HTTPURLResponse else{
                throw NetworkError.invalidResponse
            }
            Log.thisResponse(response, data: data, format: format)
            if response.statusCode == 401{
                try await revokeAccessToken()
                return try await loadAuthorized(this: endpoint, of: type)
            }
            do {
                return try parse(with: data, and: response, for: type)
            } catch {
                Log.thisError(error)
                throw error
            }
        } catch {
            throw error
        }
    }

    // MARK: - loadAuthorizedRaw
    /**
     Makes a call and return status code and raw data
     - Parameters:
        - endpoint: Endpoint that contains the information related with the request
     - Returns: Tuple `Int` containing status code and `Data` containing raw vale to be parsed
     - Throws: An error of type `NetworkError`  with extra info
    */
    open func loadAuthorized(this endpoint: Endpoint) async throws -> (Int, Data?) {
        guard let _ = authenticator else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }
        var modifiedEndpoint: Endpoint = endpoint
        modifiedEndpoint.addExtra(headers: additionalHeaders)
        modifiedEndpoint.addBaseURLIfNeeded(url: baseURL)
        do {
            let request = try await authorize(this: modifiedEndpoint.request)
            Log.thisCall(request, format: format)
            let (data, urlResponse) = try await session.data(for: request)
            guard let response = urlResponse as? HTTPURLResponse else{
                throw NetworkError.invalidResponse
            }
            Log.thisResponse(response, data: data, format: format)
            if response.statusCode == 401{
                try await revokeAccessToken()
                return try await loadAuthorized(this: endpoint)
            }
            if (200..<300).contains(response.statusCode) {
                return (response.statusCode, data)
            } else {
                throw NetworkError.failure(statusCode: response.statusCode, data: data, response: response)
            }
        } catch {
            throw error
        }
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
    open func load<T: Decodable>(endpoint: Endpoint,
                                 of type: T.Type? = AuthNoReply.self) async throws -> T {
        var modifiedEndpoint: Endpoint = endpoint
        modifiedEndpoint.addExtra(headers: additionalHeaders)
        modifiedEndpoint.addBaseURLIfNeeded(url: baseURL)
        Log.thisCall(modifiedEndpoint.request, format: format)
        let request = modifiedEndpoint.request
        let (data, urlResponse) = try await session.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        do {
            return try parse(with: data, and: response, for: type)
        } catch {
            Log.thisError(error)
            throw error
        }
    }

    // MARK: - loadRaw
    /**
     Makes a call and return status code and raw data
     - Parameters:
        - endpoint: Endpoint that contains the information related with the request
     - Returns: Tuple `Int` containing status code and `Data` containing raw vale to be parsed
     - Throws: An error of type `NetworkError`  with extra info
    */
    open func load(this endpoint: Endpoint) async throws -> (Int, Data) {
        do {
            return try await loadAndResponse(this: endpoint)
        } catch {
            Log.thisError(error)
            throw error
        }
    }

    // MARK: - Parse
    /**
     Load and parse information with raw data and status code
     - Parameters:
        - data: `Data` provided from endpoint.
        - response: `HTTPURLResponse`containing information related with the request
        - type: Type of object that is going to be used to parse the information
     - Returns: object parsed using type provided
     - Throws: An error of type `NetworkError`  with extra info
    */
    private func parse<T: Decodable>(with data: Data,
                                     and response: HTTPURLResponse,
                                     for type: T.Type? = AuthNoReply.self) throws -> T {
        let decoder = JSONDecoder()
        if (200..<300).contains(response.statusCode) {
            do {
                if !data.isEmpty &&
                    !JSONSerialization.isValidJSONObject(data)
                    && type == AuthNoReply.self {
                    let emptyJSON = "{}".data(using: .utf8)!
                    return try decoder.decode(AuthNoReply.self, from: emptyJSON) as! T
                }

                if data.isEmpty && type == AuthNoReply.self {
                    let emptyJSON = "{}".data(using: .utf8)!
                    return try decoder.decode(AuthNoReply.self, from: emptyJSON) as! T
                }

                if type == AuthNoReply.self {
                    return try decoder.decode(AuthNoReply.self, from: data) as! T
                }

                let parseData = try decoder.decode(T.self, from: data)
                return parseData
            } catch {
                throw NetworkError.errorDecodableWith(error)
            }
        } else {
            throw NetworkError.failure(statusCode: response.statusCode,
                                       data: data,
                                       response: response)
        }
    }

    // MARK: - loadAndResponse
    /**
     Load and response information with raw data and status code
     - Parameters:
        - endpoint: Endpoint that contains the information related with the request
     - Returns: Tuple `Int` containing status code and `Data` containing raw vale to be parsed
     - Throws: An error of type `NetworkError`  with extra info
    */
    private func loadAndResponse(this endpoint: Endpoint) async throws -> (Int, Data) {
        var endpoint = endpoint
        endpoint.addExtra(headers: additionalHeaders)
        endpoint.addBaseURLIfNeeded(url: baseURL)
        Log.thisCall(endpoint.request, format: format)
        let (data, response) = try await session.data(for: endpoint.request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        Log.thisResponse(response, data: data, format: format)
        if (200..<300).contains(response.statusCode) {
            return (response.statusCode, data)
        } else {
            throw NetworkError.failure(statusCode: response.statusCode, data: data, response: response)
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
    private func authorize(this request: URLRequest) async throws -> URLRequest {
        guard let authenticator = authenticator else {
            fatalError("Please provide an AuthManager in order to make authorized calls")
        }
        var requestWithHeader = request
        do {
            let token = try await authenticator.getCurrentToken()
            requestWithHeader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } catch {
            Log.thisError(error)
            try await authenticator.logout()
            throw NetworkError.invalidToken
        }
        return requestWithHeader
    }


    func revokeAccessToken() async throws {
        guard var accessToken = try await authenticator?.get(token: .access) else {
            try await authenticator?.logout()
            return
        }
        accessToken.expireDate = .distantPast
        try await authenticator?.set(token: accessToken, for: .access)
    }
}

@available(macOS 10.15, *)
extension Network {
    public struct AuthNoReply: Codable {
    }
}
