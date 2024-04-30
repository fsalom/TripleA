import Foundation

protocol MarvelUseCasesProtocol {
    func getCharacters() async throws -> [Character]
}
