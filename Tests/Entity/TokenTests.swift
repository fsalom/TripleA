import XCTest
@testable import TripleA

class TokenTests: XCTestCase {

    func testTokenInitialization() {
        let tokenValue = "sampleToken"
        let expireInt: Int = 3600 // 1 hour
        let token = Token(value: tokenValue, expireInt: expireInt)

        XCTAssertEqual(token.value, tokenValue)
        XCTAssertEqual(token.expireInt, expireInt)
        XCTAssertNotNil(token.expireDate)
    }

    func testTokenInitializationWithoutExpireInt() {
        let tokenValue = "sampleToken"
        let token = Token(value: tokenValue, expireInt: nil)

        XCTAssertEqual(token.value, tokenValue)
        XCTAssertNil(token.expireInt)
        XCTAssertNotNil(token.expireDate)
    }

    func testTokenIsValid() {
        let token = Token(value: "sampleToken", expireInt: 3600) // 1 hour
        XCTAssertTrue(token.isValid)
    }

    func testTokenIsNotValidWhenExpired() {
        let token = Token(value: "sampleToken", expireInt: -3600) // expired 1 hour ago
        XCTAssertFalse(token.isValid)
    }

    func testParseDateFromExpireInt() {
        let token = Token(value: "sampleToken", expireInt: 3600)
        let expectedDate = Date().addingTimeInterval(Double(3600))
        guard let date = token.parseDate(from: 3600) else {
            XCTFail()
            return
        }
        XCTAssertEqual(date, expectedDate)
    }

    func testParseDateFromNilExpireInt() {
        let token = Token(value: "sampleToken", expireInt: nil)
        let expectedDate = Date().addingTimeInterval(Double(1000000))
        guard let date = token.parseDate(from: nil) else {
            XCTFail()
            return
        }
        XCTAssertEqual(date, expectedDate)
    }
}
