//
//  DeveloperToolsView.swift
//  Example
//
//  Created by Fernando Salom Carratala on 8/5/24.
//

import SwiftUI

struct DeveloperToolsView: View {
    @ObservedObject var viewModel: DeveloperToolsViewModel

    var body: some View {
        List {
            Section("DeveloperToolsTitle") {
                Button("DeveloperToolsLogout") {
                    viewModel.logout()
                }
            }
            Section(header: Text("DeveloperToolsTokens")) {
                Button {
                    viewModel.expireAccessToken()
                } label: {
                    Text("DeveloperToolsTokensExpireAccessToken")
                }
                Button {
                    viewModel.expireAccessAndRefreshToken()
                } label: {
                    Text("DeveloperToolsTokensExpireAccessAndRefreshToken")
                }
            }
            Section(header: Text("DeveloperToolsCalls")) {
                Button {
                    viewModel.loadAuthorized()
                } label: {
                    Text("DeveloperToolsCallsAuthenticated")
                }
            }
        }
    }
}

#Preview {
    DeveloperToolsView(viewModel: DeveloperToolsViewModel())
}
