import Foundation

protocol MarvelDataSourceProtocol {
    func getCharacters(parameters: [String:String]) async throws -> ResultDTO
}
