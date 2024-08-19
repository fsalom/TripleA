import XCTest
@testable import TripleA

class ScreenTests: XCTestCase {

    func testLoginIcon() {
        let screen: Screen = .login
        let icon = screen.icon
        XCTAssertEqual(icon, "🛂", "El icono para el caso .login debería ser '🛂'")
    }

    func testHomeIcon() {
        let screen: Screen = .home
        let icon = screen.icon
        XCTAssertEqual(icon, "🔒", "El icono para el caso .home debería ser '🔒'")
    }
}
