import Foundation
import TripleA
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

final class MarvelViewModel {
    let router: MarvelRouter
    let usecase: MarvelUseCasesProtocol
    var characters: [Character] = []

    init(router: MarvelRouter, usecase: MarvelUseCasesProtocol) {
        self.router = router
        self.usecase = usecase
    }

    func getCharacters() async throws {
        do {
            let (ts, hash) = hash()
            let parameters = ["limit": "100",
                              "offset": "0",
                              "Marvel": publicKey,
                              "ts": ts,
                              "hash": hash ] as [String : String]
            self.characters = try await usecase.getCharacters(parameters: parameters)
        } catch let error {
            throw error
        }
    }

    // MARK: - Specific for marvel API
    var publicKey: String {
        get {
            switch self {
            default:
                return "69b9839045fcbb4a98d1daa15b1733f0"
            }
        }
    }

    var privateKey: String {
        get {
            switch self {
            default:
                return "6f56e50e1548978fb1ae4fd60ae19a07256980b2"
            }
        }
    }

    private func hash() -> (String, String) {
        let ts = Int(Date().timeIntervalSince1970)
        let MD5 = MD5(string: "\(ts)\(privateKey)\(publicKey)")
        let md5Hex = MD5.map { String(format: "%02hhx", $0) }.joined()
        return (String(ts), md5Hex)
    }

    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using: .utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}
