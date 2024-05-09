import SwiftUI
import TripleA

@main
struct ExampleApp: App {
    @StateObject var authenticator: AuthenticatorSUI = Configuration.shared.authenticator

    var body: some Scene {
        WindowGroup {
            SwitcherView()
                .environmentObject(authenticator)
        }
    }
}
