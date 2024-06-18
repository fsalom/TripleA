import Foundation

enum MockErrorNoResponseResponder: MockURLResponder {
    static func error() -> (any Error)? {
        nil
    }

    static func response(for request: URLRequest) -> URLResponse? {
        URLResponse()
    }

    static func respond(to request: URLRequest) -> Data? {
        return nil
    }
}
