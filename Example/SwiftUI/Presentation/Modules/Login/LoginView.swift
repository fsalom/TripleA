import SwiftUI

struct LoginView: View {
    @ObservedObject var VM: LoginViewModel

    var body: some View {
        Button(action: {
            
        }, label: {
            Text("Login")
        })
    }
}

#Preview {
    LoginView(VM: LoginViewModel())
}
