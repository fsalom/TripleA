import XCTest
@testable import TripleA

class NetworkErrorTests: XCTestCase {

    func testLocalizedDescriptionForMissingToken() {
        let error = NetworkError.missingToken
        XCTAssertEqual(error.localizedDescription, "Access Token not found")
    }

    func testLocalizedDescriptionForInvalidToken() {
        let error = NetworkError.invalidToken
        XCTAssertEqual(error.localizedDescription, "Access Token not valid")
    }

    func testLocalizedDescriptionForInvalidResponse() {
        let error = NetworkError.invalidResponse
        XCTAssertEqual(error.localizedDescription, "Response not expected")
    }

    func testLocalizedDescriptionForErrorDecodable() {
        let error = NetworkError.errorDecodable
        XCTAssertEqual(error.localizedDescription, "Error while decoding object. Check your DTO.")
    }

    func testLocalizedDescriptionForErrorDecodableWith() {
        let underlyingError = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Test error description"])
        let error = NetworkError.errorDecodableWith(underlyingError)
        XCTAssertEqual(error.localizedDescription, "Error while decoding object. Check your DTO. Error message: Test error description.")
    }

    func testLocalizedDescriptionForErrorData() {
        let jsonData = """
        {
            "key": "value"
        }
        """.data(using: .utf8)!
        let error = NetworkError.errorData(jsonData)
        XCTAssertEqual(error.localizedDescription, "Error reponse with data: \(jsonData.prettyPrintedJSONString ?? "")")
    }

    func testLocalizedDescriptionForFailure() {
        let jsonData = """
        {
            "key": "value"
        }
        """.data(using: .utf8)!
        let error = NetworkError.failure(statusCode: 404, data: jsonData, response: nil)
        XCTAssertEqual(error.localizedDescription, "Error code [404] reponse with data: \(jsonData.prettyPrintedJSONString ?? "")")
    }

    func testDataForErrorData() {
        let jsonData = """
        {
            "key": "value"
        }
        """.data(using: .utf8)!
        let error = NetworkError.errorData(jsonData)
        XCTAssertEqual(error.data, jsonData)
    }

    func testDataForOtherErrors() {
        XCTAssertEqual(NetworkError.missingToken.data, Data())
        XCTAssertEqual(NetworkError.invalidToken.data, Data())
        XCTAssertEqual(NetworkError.invalidResponse.data, Data())
        XCTAssertEqual(NetworkError.errorDecodable.data, Data())
        XCTAssertEqual(NetworkError.errorDecodableWith(NSError()).data, Data())
        XCTAssertEqual(NetworkError.failure(statusCode: 500).data, Data())
    }
}
