import SwiftUI

#if !os(watchOS)
public struct DeveloperToolsView<ViewModel>: View where ViewModel: DeveloperToolsViewModelProtocol {
    @StateObject private var viewModel: ViewModel

      init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
      }

    public var body: some View {
        List {
            Section("Developer tools") {
                Button("Logout") {
                    viewModel.logout()
                }
            }
            Section(header: Text("Actions with tokens")) {
                Button {
                    viewModel.expireAccessToken()
                } label: {
                    Text("Expire access token")
                }
                Button {
                    viewModel.expireAccessAndRefreshToken()
                } label: {
                    Text("Expire access and refresh token")
                }
            }
            Section(header: Text("Calls")) {
                Button {
                    viewModel.loadAuthorized()
                } label: {
                    Text("Authenticated call")
                }
                Button {
                    viewModel.launchParallelCalls()
                } label: {
                    Text("Parallel authenticated calls")
                }
            }
        }
    }
}
#endif
