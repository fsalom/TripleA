import Foundation

struct Crypto: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let priceUsd: String
    let symbol: String
    let changePercent24Hr : Float
}
