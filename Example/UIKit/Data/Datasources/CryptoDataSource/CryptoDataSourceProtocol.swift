import Foundation

protocol CryptoDataSourceProtocol {
    func getCryptos() async throws -> [CryptoDTO]
}
