import Foundation

protocol MarvelUseCasesProtocol {
    func getCharacters(parameters: [String:String]) async throws -> [Character]
}
