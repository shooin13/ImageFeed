// MARK: - ProfileResult

struct ProfileResult: Codable {
  let firstName: String
  let lastName: String
  let userName: String
  let userBio: String?
  
  // MARK: - CodingKeys
  
  enum CodingKeys: String, CodingKey {
    case firstName = "firstName"
    case lastName = "lastName"
    case userName = "username"
    case userBio = "bio"
  }
}
