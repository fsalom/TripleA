import Foundation

enum MockError400URLResponder: MockURLResponder {
    static func error() -> (any Error)? {
        nil
    }

    static func response(for request: URLRequest) -> URLResponse? {
        HTTPURLResponse(
            url: request.url!,
            statusCode: 400,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )
    }

    static func respond(to request: URLRequest) -> Data? {
        return nil
    }
}
