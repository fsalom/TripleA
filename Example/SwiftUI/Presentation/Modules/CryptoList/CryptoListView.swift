//
//  ContentView.swift
//  Example
//
//  Created by Fernando Salom Carratala on 26/4/24.
//

import SwiftUI

struct CryptoListView: View {
    @ObservedObject var VM: CryptoListViewModel

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(content: {
                ForEach(VM.cryptos) { crypto in
                    NavigationLink {

                    } label: {
                        CryptoRow(with: crypto)
                    }
                }
            }).task {
                try? await VM.load()
            }
            .padding(.horizontal, 20)
        }
        .searchable(text: $VM.searchText, prompt: "Búsqueda")
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {                
                VStack(alignment: .leading, content: {
                    Text(crypto.name)
                        .fontWeight(.bold)
                    Text(crypto.symbol)
                        .font(.footnote)
                })
                Spacer()
                VStack(alignment: .trailing, spacing: 0, content: {
                    Text("\(crypto.priceUsd)")
                        .fontWeight(.bold)
                    Text("\(crypto.changePercent24Hr)%")
                        .foregroundStyle(crypto.changePercent24Hr > 0
                                         ? .green : .red)
                        .fontWeight(.bold)
                        .font(.footnote)
                        .padding(4)
                        .background(crypto.changePercent24Hr > 0 ?
                                    Color.green :
                                    Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                })
            }
            .padding(10)
            Divider()
        }
    }
}

#Preview {
    CryptoListBuilder().build()
}
