import XCTest
@testable import TripleA

class AuthTokenStoreDefaultTests: XCTestCase {

    var tokenStore: AuthTokenStoreDefault!

    override func setUp() {
        super.setUp()
        tokenStore = AuthTokenStoreDefault()
    }

    override func tearDown() {
        tokenStore.removeAll()
        tokenStore = nil
        super.tearDown()
    }

    func testSaveAndLoadAccessToken() {
        let token = Token(value: "accessTokenValue", expireInt: 3600)
        tokenStore.accessToken = token
        let loadedToken = tokenStore.accessToken
        XCTAssertEqual(token.value, "loadedToken?.value", "Access token should be correctly saved and loaded")
    }

    func testSaveAndLoadRefreshToken() {
        let token = Token(value: "refreshTokenValue", expireInt: 3600)
        tokenStore.refreshToken = token
        let loadedToken = tokenStore.refreshToken
        XCTAssertEqual(token.value, loadedToken?.value, "Refresh token should be correctly saved and loaded")
    }

    func testSaveAndLoadIdToken() {
        let token = Token(value: "idTokenValue", expireInt: 3600)
        tokenStore.idToken = token
        let loadedToken = tokenStore.idToken
        XCTAssertEqual(token.value, loadedToken?.value, "ID token should be correctly saved and loaded")
    }

    func testSaveAndLoadUniqueName() {
        let uniqueName = "uniqueUserName"
        tokenStore.uniqueName = uniqueName
        let loadedUniqueName = tokenStore.uniqueName
        XCTAssertEqual(uniqueName, loadedUniqueName, "Unique name should be correctly saved and loaded")
    }

    func testRemoveAccessToken() {
        tokenStore.accessToken = Token(value: "accessTokenValue", expireInt: 3600)
        tokenStore.accessToken = nil
        let loadedToken = tokenStore.accessToken
        XCTAssertNil(loadedToken, "Access token should be removed")
    }

    func testRemoveRefreshToken() {
        tokenStore.refreshToken = Token(value: "refreshTokenValue", expireInt: 3600)
        tokenStore.refreshToken = nil
        let loadedToken = tokenStore.refreshToken
        XCTAssertNil(loadedToken, "Refresh token should be removed")
    }

    func testRemoveIdToken() {
        tokenStore.idToken = Token(value: "idTokenValue", expireInt: 3600)
        tokenStore.idToken = nil
        let loadedToken = tokenStore.idToken
        XCTAssertNil(loadedToken, "ID token should be removed")
    }

    func testRemoveUniqueName() {
        tokenStore.uniqueName = "uniqueUserName"
        tokenStore.uniqueName = nil
        let loadedUniqueName = tokenStore.uniqueName
        XCTAssertNil(loadedUniqueName, "Unique name should be removed")
    }

    func testRemoveAllTokens() {
        tokenStore.accessToken = Token(value: "accessTokenValue", expireInt: 3600)
        tokenStore.refreshToken = Token(value: "refreshTokenValue", expireInt: 3600)
        tokenStore.idToken = Token(value: "idTokenValue", expireInt: 3600)
        tokenStore.uniqueName = "uniqueUserName"

        tokenStore.removeAll()

        XCTAssertNil(tokenStore.accessToken, "Access token should be removed")
        XCTAssertNil(tokenStore.refreshToken, "Refresh token should be removed")
        XCTAssertNil(tokenStore.idToken, "ID token should be removed")
        XCTAssertNil(tokenStore.uniqueName, "Unique name should be removed")
    }
}
