import XCTest
@testable import TripleA

class AuthErrorTests: XCTestCase {

    func testAuthErrorMissingToken() {
        let error = AuthError.missingToken
        XCTAssertEqual(error.data, Data(), "El error missingToken debería devolver un Data vacío.")
    }

    func testAuthErrorMissingExpiresIn() {
        let error = AuthError.missingExpiresIn
        XCTAssertEqual(error.data, Data(), "El error missingExpiresIn debería devolver un Data vacío.")
    }

    func testAuthErrorBadRequest() {
        let error = AuthError.badRequest
        XCTAssertEqual(error.data, Data(), "El error badRequest debería devolver un Data vacío.")
    }

    func testAuthErrorTokenNotFound() {
        let error = AuthError.tokenNotFound
        XCTAssertEqual(error.data, Data(), "El error tokenNotFound debería devolver un Data vacío.")
    }

    func testAuthErrorRefreshFailed() {
        let error = AuthError.refreshFailed
        XCTAssertEqual(error.data, Data(), "El error refreshFailed debería devolver un Data vacío.")
    }

    func testAuthErrorTimeout() {
        let error = AuthError.timeout
        XCTAssertEqual(error.data, Data(), "El error timeout debería devolver un Data vacío.")
    }

    func testAuthErrorNoInternet() {
        let error = AuthError.noInternet
        XCTAssertEqual(error.data, Data(), "El error noInternet debería devolver un Data vacío.")
    }

    func testAuthErrorLogoutFailed() {
        let error = AuthError.logoutFailed
        XCTAssertEqual(error.data, Data(), "El error logoutFailed debería devolver un Data vacío.")
    }

    func testAuthErrorNotAuthorized() {
        let error = AuthError.notAuthorized
        XCTAssertEqual(error.data, Data(), "El error notAuthorized debería devolver un Data vacío.")
    }

    func testAuthErrorWithErrorData() {
        let sampleData = "Sample Error Data".data(using: .utf8)!
        let error = AuthError.errorData(sampleData)
        XCTAssertEqual(error.data, sampleData, "El error errorData debería devolver los datos adjuntos.")
    }
}
