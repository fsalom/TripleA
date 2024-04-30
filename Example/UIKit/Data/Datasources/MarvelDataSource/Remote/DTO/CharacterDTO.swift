// MARK: - Characters
struct ResultDTO: Codable {
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: ResultDataDTO
}

// MARK: - DataClass
struct ResultDataDTO: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterDTO]
}

// MARK: - Result
struct CharacterDTO: Codable {
    let id: Int
    let name: String
}
