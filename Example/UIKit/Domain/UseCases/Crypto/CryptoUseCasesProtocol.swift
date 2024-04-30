import Foundation

protocol CryptoUseCasesProtocol {
    func getCryptos() async throws -> [Crypto]
}
