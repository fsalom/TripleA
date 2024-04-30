import Foundation

protocol MarvelDataSourceProtocol {
    func getCharacters() async throws -> ResultDTO
}
