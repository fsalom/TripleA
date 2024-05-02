import Foundation

protocol CryptoRepositoryProtocol {
    func getCryptos() async throws -> [Crypto]
}
