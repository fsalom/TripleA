import XCTest
@testable import TripleA

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
}

struct ExampleTest: Codable {
    var title: String
    var description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

enum MockErrorURLResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data {
        throw URLError(.badServerResponse)
    }
}

extension ExampleTest {
    enum MockDataURLResponder: MockURLResponder {
        static let item = ExampleTest(title: "Title", description: "Description")

        static func respond(to request: URLRequest) throws -> Data {
            return try JSONEncoder().encode(item)
        }
    }
}

class MockURLProtocol<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
            let data = try Responder.respond(to: request)
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))

            client.urlProtocol(self,
                               didReceive: response,
                               cacheStoragePolicy: .notAllowed
            )
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}

extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
}

class authenticatorTest: AuthenticatorProtocol {
    func getCurrentToken() async throws -> String { "" }
    func getNewToken(with parameters: [String : Any]) async throws { }
    func renewToken() async throws -> String { "" }
    func logout() async { }
}


class NetworkTest: XCTestCase {
    func testLoadOK() async {
        let mockSession = URLSession(mockResponder: ExampleTest.MockDataURLResponder.self)
        let network = Network(session: mockSession)

        let endpoint = Endpoint(path: "https://example.com", httpMethod: .get)

        do {
            let _ = try await network.load(this: endpoint)
            XCTAssertTrue(true)
        } catch {
            XCTFail("test failed")
        }
    }
}
