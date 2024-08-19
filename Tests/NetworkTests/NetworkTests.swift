import XCTest
@testable import TripleA

class NetworkTests: XCTestCase {
    var sutOK: Network!
    var sutKOWith400: Network!
    var sutKOWith401: Network!
    var sutKOWithoutResponse: Network!
    var mockAuthenticator: AuthenticatorProtocol!

    override func setUp() {
        super.setUp()
        mockAuthenticator = MockAuthenticator()
        sutOK = Network(
            authenticator: mockAuthenticator,
            session: URLSession(mockResponder: TestableDTO.MockDataURLResponder.self))
        sutKOWith400 = Network(
            authenticator: mockAuthenticator,
            session: URLSession(mockResponder: MockError400URLResponder.self))
        sutKOWithoutResponse = Network(
            authenticator: mockAuthenticator,
            session: URLSession(mockResponder: MockErrorNoResponseResponder.self))
        sutKOWith401 = Network(
            authenticator: mockAuthenticator,
            session: URLSession(mockResponder: MockError401URLResponder.self))
    }

    override func tearDown() {
        sutOK = nil
        sutKOWith400 = nil
        sutKOWithoutResponse = nil
        mockAuthenticator = nil
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
            let (status, _) = try await sutOK.load(this: publicEndpoint)
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

    func testLoadAuthorizedWithObjectOK() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let testableDTO = try await sutOK.loadAuthorized(this: endpoint, of: TestableDTO.self)
            XCTAssertTrue(testableDTO.name == TestableDTO.MockDataURLResponder.item.name)
        } catch {
            XCTFail("call unexpected fail")
        }
    }

    func testLoadAuthorizedWithObjectFailsWith400() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWith400.loadAuthorized(this: endpoint, of: TestableDTO.self)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadAuthorizedWithObjectFailsWithoutResponse() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWithoutResponse.loadAuthorized(this: endpoint, of: TestableDTO.self)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadAuthorizedWithObjectFailsWith401() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            _ = try await sutKOWith401.loadAuthorized(this: endpoint, of: TestableDTO.self)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadAuthorizedWithIntAndDataOK() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let (code, data) = try await sutOK.loadAuthorized(this: endpoint)
            XCTAssertTrue(code == 200)
            XCTAssertTrue(data != nil)
        } catch {
            XCTFail("call unexpected fail")
        }
    }

    func testLoadAuthorizedWithIntAndDataFailsWith400() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let (_, _) = try await sutKOWith400.loadAuthorized(this: endpoint)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testLoadAuthorizedWithIntAndDataFailsWithoutResponse() async {
        do {
            let endpoint = Endpoint(path: "https://tests.com", httpMethod: .get)
            let (_, _) = try await sutKOWithoutResponse.loadAuthorized(this: endpoint)
            XCTFail("call should fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
