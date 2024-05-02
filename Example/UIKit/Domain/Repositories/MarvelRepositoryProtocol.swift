import Foundation

protocol MarvelRepositoryProtocol {
    func getCharacters(parameters: [String: String]) async throws -> [Character]
}
