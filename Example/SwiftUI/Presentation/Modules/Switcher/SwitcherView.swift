import SwiftUI
import TripleA

struct SwitcherView: View {
    @EnvironmentObject var authenticator: AuthenticatorSUI

    var body: some View {
        switch authenticator.screen {
        case .login:
            LoginBuilder().build()
        case .home:
            HomeBuilder().build()
        }
    }
}

#Preview {
    SwitcherView()
}
