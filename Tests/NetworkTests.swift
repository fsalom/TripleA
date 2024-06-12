import XCTest
@testable import TripleA

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

class NetworkTests: XCTestCase {
    var sutOK: Network!
    var sutKOWith400: Network!
    var sutKOWithoutResponse: Network!

    override func setUp() {
        super.setUp()
        sutOK = Network(session: URLSession(mockResponder: TestableDTO.MockDataURLResponder.self))
        sutKOWith400 = Network(session: URLSession(mockResponder: MockError400URLResponder.self))
        sutKOWithoutResponse = Network(session: URLSession(mockResponder: MockErrorNoResponseResponder.self))
    }

    override func tearDown() {
        sutOK = nil
        sutKOWith400 = nil
        sutKOWithoutResponse = nil
        super.tearDown()
    }

    func testLoadWithObjectOK() async {
        do {
            let publicEndpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let testableDTO = try await sutOK.load(endpoint: publicEndpoint, of: TestableDTO.self)
            XCTAssertTrue(testableDTO.name == TestableDTO.MockDataURLResponder.item.name)
        } catch {
            XCTFail("call unexpected fail")
        }
    }

    func testLoadWithObjectFailsWith400() async {
        do {
            let publicEndpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWith400.load(endpoint: publicEndpoint, of: TestableDTO.self)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadWithObjectFailsWithoutResponse() async {
        do {
            let publicEndpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWithoutResponse.load(endpoint: publicEndpoint, of: TestableDTO.self)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadWithStatusAndDataOK() async {
        do {
            let publicEndpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let (status, data) = try await sutOK.load(this: publicEndpoint)
            XCTAssertTrue(status == 200)
        } catch {
            XCTFail("call unexpected fail")
        }
    }

    func testLoadWithStatusAndDataFailsWith400() async {
        do {
            let publicEndpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWith400.load(this: publicEndpoint)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
