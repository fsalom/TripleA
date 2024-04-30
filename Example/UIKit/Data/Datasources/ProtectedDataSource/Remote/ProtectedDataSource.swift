import Foundation
import TripleA

class ProtectedDataSource: ProtectedDataSourceProtocol {
    var network: Network

    init(network: Network) {
        self.network = network
    }

    func getMe() async throws -> UserDTO {
        try await network.loadAuthorized(endpoint: OAuthAPI.me.endpoint, of: UserDTO.self)
    }

}
