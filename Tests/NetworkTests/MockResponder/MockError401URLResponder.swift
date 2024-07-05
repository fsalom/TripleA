import Foundation

enum MockError401URLResponder: MockURLResponder {
    static func error() -> (any Error)? {
        nil
    }

    static func response(for request: URLRequest) -> URLResponse? {
        HTTPURLResponse(
            url: request.url!,
            statusCode: 401,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )
    }

    static func respond(to request: URLRequest) -> Data? {
        return nil
    }
}
