import XCTest
@testable import TripleA

class PKCEManagerTests: XCTestCase {
    var sut: PKCEManager!

    override func setUp() {
        super.setUp()
        let config = PKCEConfig(
            clientID: "clientID",
            clientSecret: "clientSecret",
            authorizeURL: "https://ww.google.com",
            logoutURL: "https://ww.google.com",
            tokenURL: "https://ww.google.com",
            scope: "scope",
            callbackURLScheme: "callback",
            callbackURLLogoutScheme: "callbackLogout")
        sut = PKCEManager(presentationAnchor: nil,
                          config: config)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetNewTokens() async {
        do {
            _ = try await sut.getNewTokens(with: "")
            XCTFail()
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testGetToken() async {
        do {
            try await sut.logout()
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }

    func testLogin() async {
        sut.showLogin { _ in

        }
        XCTAssertTrue(true)
    }
}

