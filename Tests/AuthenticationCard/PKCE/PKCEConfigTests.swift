import XCTest
@testable import TripleA

class PKCEConfigTests: XCTestCase {

    func testPKCEConfigInitialization() {
        let clientID = "testClientID"
        let clientSecret = "testClientSecret"
        let authorizeURL = "https://example.com/authorize"
        let logoutURL = "https://example.com/logout"
        let tokenURL = "https://example.com/token"
        let scope = "openid profile email"
        let codeChallengeMethod = "S256"
        let responseType = "code"
        let callbackURLScheme = "com.example.app"
        let callbackURLLogoutScheme = "com.example.app.logout"

        let config = PKCEConfig(clientID: clientID,
                                clientSecret: clientSecret,
                                authorizeURL: authorizeURL,
                                logoutURL: logoutURL,
                                tokenURL: tokenURL,
                                scope: scope,
                                codeChallengeMethod: codeChallengeMethod,
                                responseType: responseType,
                                callbackURLScheme: callbackURLScheme,
                                callbackURLLogoutScheme: callbackURLLogoutScheme)

        XCTAssertEqual(config.clientID, clientID)
        XCTAssertEqual(config.clientSecret, clientSecret)
        XCTAssertEqual(config.authorizeURL, authorizeURL)
        XCTAssertEqual(config.logoutURL, logoutURL)
        XCTAssertEqual(config.tokenURL, tokenURL)
        XCTAssertEqual(config.scope, scope)
        XCTAssertEqual(config.codeChallengeMethod, codeChallengeMethod)
        XCTAssertEqual(config.responseType, responseType)
        XCTAssertEqual(config.callbackURLScheme, callbackURLScheme)
        XCTAssertEqual(config.callbackURLLogoutScheme, callbackURLLogoutScheme)
    }
}

