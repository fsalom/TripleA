import XCTest
@testable import TripleA

class CustomErrorTests: XCTestCase {

    func testCustomErrorInitializationWithoutDataAndError() {
        let customError = CustomError(type: .missingToken)

        XCTAssertEqual(customError.type, .missingToken)
        XCTAssertNil(customError.data)
        XCTAssertEqual(customError.description, "")
        XCTAssertNil(customError.raw)
        XCTAssertNil(customError.rawDescription)
        XCTAssertEqual(customError.code, 0)
    }

    func testCustomErrorInitializationWithData() {
        let jsonData = """
        {
            "key": "value"
        }
        """.data(using: .utf8)
        let customError = CustomError(type: .invalidResponse, data: jsonData)

        XCTAssertEqual(customError.type, .invalidResponse)
        XCTAssertEqual(customError.data, jsonData)
        XCTAssertEqual(customError.description, jsonData?.prettyPrintedJSONString as String?)
        XCTAssertNil(customError.raw)
        XCTAssertNil(customError.rawDescription)
        XCTAssertEqual(customError.code, 0)
    }

    func testCustomErrorInitializationWithError() {
        let underlyingError = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Test error description"])
        let customError = CustomError(type: .errorDecodableWith(underlyingError), error: underlyingError)

        XCTAssertEqual(customError.type, .errorDecodableWith(underlyingError))
        XCTAssertNil(customError.data)
        XCTAssertEqual(customError.description, "")
        XCTAssertEqual(customError.raw as NSError?, underlyingError)
        XCTAssertEqual(customError.rawDescription, underlyingError.localizedDescription)
        XCTAssertEqual(customError.code, 0)
    }

    func testCustomErrorInitializationWithDataAndError() {
        let jsonData = """
        {
            "key": "value"
        }
        """.data(using: .utf8)
        let underlyingError = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Test error description"])
        let customError = CustomError(type: .failure(statusCode: 403, data: jsonData), data: jsonData, error: underlyingError, code: 403)

        XCTAssertEqual(customError.type, .failure(statusCode: 403, data: jsonData))
        XCTAssertEqual(customError.data, jsonData)
        XCTAssertEqual(customError.description, jsonData?.prettyPrintedJSONString as String?)
        XCTAssertEqual(customError.raw as NSError?, underlyingError)
        XCTAssertEqual(customError.rawDescription, underlyingError.localizedDescription)
        XCTAssertEqual(customError.code, 403)
    }

    func testCustomErrorWithEmptyDataAndError() {
        let customError = CustomError(type: .invalidToken, data: Data(), error: nil, code: 401)

        XCTAssertEqual(customError.type, .invalidToken)
        XCTAssertEqual(customError.data, Data())
        XCTAssertEqual(customError.description, "")
        XCTAssertNil(customError.raw)
        XCTAssertNil(customError.rawDescription)
        XCTAssertEqual(customError.code, 401)
    }
}
