import Foundation

protocol MarvelRepositoryProtocol {
    func getCharacters() async throws -> [Character]
}
