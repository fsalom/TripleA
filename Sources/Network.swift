import Foundation

@available(macOS 10.15, *)
open class Network {
    public let authenticator: AuthenticatorProtocol?
    private var baseURL: String = ""
    private var additionalHeaders: [String: String] = [:]
    private var session: URLSession!
    private var format: LogFormat!

    public init(baseURL: String = "",
                session: URLSession? = URLSession(configuration: .default),
                authenticator: AuthenticatorProtocol? = nil,
                headers: [String: String] = [:],
                format: LogFormat = .full) {
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
                                           of type: T.Type? = AuthNoReply.self,
                                           allowRetry: Bool = true) async throws -> T {
        guard let authenticator = authenticator else {
            fatalError("Please provide an Authenticator in order to make authorized calls")
        }
        var modifiedEndpoint: Endpoint = endpoint
        modifiedEndpoint.addExtra(headers: additionalHeaders)
        modifiedEndpoint.addBaseURLIfNeeded(url: baseURL)
        let request = try await authorizedRequest(from: modifiedEndpoint.request)
        Log.thisCall(request, format: format)
        let (data, urlResponse) = try await session.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        if response.statusCode == 401{
            if allowRetry {
                _ = try await authenticator.renewToken()
                return try await loadAuthorized(this: endpoint, of: type, allowRetry: false)
            }
        }
        do {
            return try parse(with: data, and: response, for: type)
        } catch {
            Log.thisError(error)
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
    open func load<T: Decodable>(this endpoint: Endpoint,
                                 of type: T.Type? = AuthNoReply.self,
                                 allowRetry: Bool = true) async throws -> T {
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
        Log.thisResponse(response, data: data, format: format)
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

    // MARK: - loadRaw
    /**
     Makes a call and return status code and raw data
     - Parameters:
        - endpoint: Endpoint that contains the information related with the request
     - Returns: Tuple `Int` containing status code and `Data` containing raw vale to be parsed
     - Throws: An error of type `NetworkError`  with extra info
    */
    open func loadRaw(this endpoint: Endpoint) async throws -> (Int, Data) {
        do {
            return try await loadAndResponse(this: endpoint)
        } catch {
            Log.thisError(error)
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
    open func loadAuthorizedRaw(this endpoint: Endpoint) async throws -> (Int, Data?) {
        guard let authenticator = authenticator else {
            fatalError("Please provide an authenticator in order to make authorized calls")
        }
        var modifiedEndpoint: Endpoint = endpoint
        modifiedEndpoint.addExtra(headers: additionalHeaders)
        modifiedEndpoint.addBaseURLIfNeeded(url: baseURL)
        let request = try await authorizedRequest(from: modifiedEndpoint.request)
        Log.thisCall(request, format: format)
        let (data, urlResponse) = try await session.data(for: request)
        guard let response = urlResponse as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        if response.statusCode == 401{
            _ = try await authenticator.renewToken()
            return try await loadAuthorizedRaw(this: endpoint)

        }
        if (200..<300).contains(response.statusCode) {
            return (response.statusCode, data)
        } else {
            throw NetworkError.failure(statusCode: response.statusCode, data: data, response: response)
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
    private func authorizedRequest(from request: URLRequest) async throws -> URLRequest {
        guard let authenticator = authenticator else {
            fatalError("Please provide an authenticator in order to make authorized calls")
        }
        var requestWithHeader = request
        do{
            let token = try await authenticator.getCurrentToken()
            requestWithHeader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }catch let error{
            Log.thisError(error)
            await authenticator.logout()
        }
        return requestWithHeader
    }

    // MARK: - getNewToken
    /**
     Make a call through authenticator to get new accessToken
     - Parameters:
        - parameters: optional parameters that call needed [String: Any]
     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String: Any] = [:]) async throws {
        guard let authenticator = authenticator else {
            fatalError("Please provide an authenticator in order to make authorized calls")
        }
        do {
            try await authenticator.getNewToken(with: parameters)
        } catch let error {
            throw error
        }

    }

    // MARK: - renewToken
    /**
     Renew refreshToken if needed through authenticator
     - Throws: An error of type `CustomError`  with extra info
    */
    public func renewToken() async throws {
        guard let authenticator = authenticator else {
            fatalError("Please provide an authenticator in order to make authorized calls")
        }
        do {
            _ = try await authenticator.renewToken()
        } catch {
            throw error
        }
    }

    // MARK: - logout
    /**
     Logout throug authenticator
     - Throws: An error of type `CustomError`  with extra info
    */
    public func logout() async throws {
        guard let authenticator = authenticator else {
            fatalError("Please provide an authenticator in order to make authorized calls")
        }
        await authenticator.logout()
    }
}

@available(macOS 10.15, *)
extension Network {
    public struct AuthNoReply: Codable {
    }
}
