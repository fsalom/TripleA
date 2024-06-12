import Foundation

protocol MockURLResponder {
    static func respond(to request: URLRequest) -> Data?
    static func response(for request: URLRequest) -> URLResponse?
    static func error() -> Error?
}
