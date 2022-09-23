import Foundation
import UIKit

public struct Endpoint{
    public enum HTTPMethod{
        case get
        case post
        case patch
        case delete
        
        var rawValue: String{
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    public enum Encoding{
        case json
        case multipart
        
        var rawValue: String{
            switch self {
            case .json: return "application/json; charset=utf-8"
            case .multipart: return "multipart/form-data; boundary=\(UUID().uuidString)"
            }
        }
    }
    var baseURL: String
    var path: String
    var httpMethod: HTTPMethod
    var encoding: Encoding
    var parameters: [String: Any]
    var headers: [String: String]
    var images: [String: UIImage]
    var videos: [String: String]
    var request: URLRequest {
        get {
            let urlAndPath = !baseURL.isEmpty ? baseURL + path : path
            guard let url = URL(string: urlAndPath) else { fatalError("Not a valid URL") }
            var request = URLRequest(url:  url)
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
            request.httpMethod = self.httpMethod.rawValue
            
            switch self.httpMethod{
            case .get:
                if !parameters.isEmpty { request = setURLEncoding(for: url) }
            case .post, .patch:
                request.setValue(encoding.rawValue, forHTTPHeaderField: "Content-Type")
                switch getEncoding(){
                case .json:
                    request = setJSONEncoding(for: request)
                case .multipart:
                    request = setMultiPartEncoding(for: request)
                    break
                }
            default:
                break
            }
            return request
        }
    }
    
    public init(baseURL: String = "",
                path: String,
                httpMethod: HTTPMethod,
                parameters: [String: Any] = [:],
                headers: [String: String] = [:],
                encoding: Encoding = .json,
                images: [String: UIImage] = [:],
                videos: [String: String] = [:]){
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.videos = videos
        self.images = images
        self.encoding = encoding
        self.headers = headers
        self.baseURL = baseURL
    }
    
    // MARK: - set Encoding depending on all variables
    func getEncoding() -> Encoding{
        switch httpMethod {
        case .post, .patch:
            var newEncoding = encoding == .none ? .json : encoding
            if !videos.isEmpty || !images.isEmpty{
                newEncoding = .multipart
            }
            return newEncoding
        default:
            return .json
        }
    }
    
    // MARK: - set JSON encoding parameters
    func setJSONEncoding(for request: URLRequest) -> URLRequest{
        var request = request
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            fatalError("Error coding json to data")
        }
        request.httpBody = httpBody
        return request
    }
    
    // MARK: - set URL encoding parameters
    func setURLEncoding(for url: URL) -> URLRequest{
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = self.parameters.map { (key, value) in
            if value is Int{
                return URLQueryItem(name: key, value: "\(value)")
            }else{
                return URLQueryItem(name: key, value: value as? String)
            }
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return URLRequest(url: components.url!)
    }
    
    // MARK: - set JSON encoding parameters
    func setMultiPartEncoding(for request: URLRequest) -> URLRequest{
        var request = request
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            fatalError()
        }
        request.httpBody = httpBody
        return request
    }
}

