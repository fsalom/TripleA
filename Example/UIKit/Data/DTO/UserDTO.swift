struct UserDTO: Codable {
    let firstName,
        email: String

    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case email = "email"
    }
}
