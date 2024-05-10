//
//  HomeView.swift
//  Example
//
//  Created by Fernando Salom Carratala on 8/5/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        TabView {
            NavigationView {
                CryptoListBuilder().build()
                    .navigationTitle("HomeTitle1")
            }
            .tabItem {
                Image(systemName: "person.3.sequence")
                Text("HomeTab1")
            }
            NavigationView {
                DeveloperToolsBuilder().build()
                    .navigationTitle("HomeTitle2")
            }
            .tabItem {
                Image(systemName: "person")
                Text("HomeTab2")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
