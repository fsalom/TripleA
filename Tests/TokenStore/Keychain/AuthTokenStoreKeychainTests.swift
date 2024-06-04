import XCTest
@testable import TripleA

class AuthTokenStoreKeychainTests: XCTestCase {

    var tokenStore: AuthTokenStoreKeychain!

    override func setUp() {
        super.setUp()
        tokenStore = AuthTokenStoreKeychain()
    }

    override func tearDown() {
        tokenStore.removeAll()
        tokenStore = nil
        super.tearDown()
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
