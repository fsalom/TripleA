import Foundation

class CryptoRepository: CryptoRepositoryProtocol {

    var remote: CryptoRemoteDataSource

    init(remote: CryptoRemoteDataSource) {
        self.remote = remote
    }

    func getCryptos() async throws -> [Crypto] {
        let cryptosDTO = try await remote.getCryptos()
        return cryptosDTO.map({$0.toDomain()})
    }
}

fileprivate extension CryptoDTO {
    func toDomain() -> Crypto {
        Crypto(name: self.name,
               priceUsd: self.priceUsd,
               symbol: self.symbol,
               changePercent24Hr: Float(self.changePercent24Hr) ?? 0.0)
    }
}
