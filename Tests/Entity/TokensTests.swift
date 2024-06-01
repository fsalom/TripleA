import XCTest
@testable import TripleA

class TokensTests: XCTestCase {

    func testTokensInitialization() {
        let accessToken = Token(value: "accessToken", expireInt: 3600) // 1 hour
        let refreshToken = Token(value: "refreshToken", expireInt: 7200) // 2 hours
        let tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertEqual(tokens.accessToken.value, "accessToken")
        XCTAssertEqual(tokens.refreshToken.value, "refreshToken")
        XCTAssertNotNil(tokens.accessToken.expireDate)
        XCTAssertNotNil(tokens.refreshToken.expireDate)
        XCTAssertEqual(tokens.accessToken.expireInt, 3600)
        XCTAssertEqual(tokens.refreshToken.expireInt, 7200)
    }

    func testAccessTokenValidity() {
        let accessToken = Token(value: "accessToken", expireInt: 3600) // 1 hour
        let refreshToken = Token(value: "refreshToken", expireInt: 7200) // 2 hours
        let tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertTrue(tokens.accessToken.isValid)
    }

    func testRefreshTokenValidity() {
        let accessToken = Token(value: "accessToken", expireInt: 3600) // 1 hour
        let refreshToken = Token(value: "refreshToken", expireInt: 7200) // 2 hours
        let tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertTrue(tokens.refreshToken.isValid)
    }

    func testExpiredAccessToken() {
        let accessToken = Token(value: "accessToken", expireInt: -3600) // expired 1 hour ago
        let refreshToken = Token(value: "refreshToken", expireInt: 7200) // 2 hours
        let tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertFalse(tokens.accessToken.isValid)
    }

    func testExpiredRefreshToken() {
        let accessToken = Token(value: "accessToken", expireInt: 3600) // 1 hour
        let refreshToken = Token(value: "refreshToken", expireInt: -7200) // expired 2 hours ago
        let tokens = Tokens(accessToken: accessToken, refreshToken: refreshToken)

        XCTAssertFalse(tokens.refreshToken.isValid)
    }
}
