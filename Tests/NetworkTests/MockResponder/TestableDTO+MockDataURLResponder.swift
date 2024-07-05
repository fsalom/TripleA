import Foundation

struct TestableDTO: Codable {
    var name: String

    init(name: String) {
        self.name = name
    }

    enum MockDataURLResponder: MockURLResponder {
        static func error() -> (any Error)? {
            nil
        }

        static func response(for request: URLRequest) -> URLResponse? {
            HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )
        }
        static let item = TestableDTO(name: "Testable DTO")

        static func respond(to request: URLRequest) -> Data? {
            return try? JSONEncoder().encode(item)
        }
    }
}
