import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding(10)
            TextField("Password", text: $viewModel.password)
                .padding(10)
            Button(action: {
                viewModel.login()
            }, label: {
                Text("Login")
            })
            .frame(maxWidth: .infinity)
            .padding(10)
            .foregroundColor(.white)
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
