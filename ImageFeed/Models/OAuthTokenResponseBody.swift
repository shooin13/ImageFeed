import Foundation

// MARK: - OAuthTokenResponseBody

struct OAuthTokenResponseBody: Codable {
  let accessToken: String
  let tokenType: String
  let scope: String
  let createdAt: Date
  
  // MARK: - CodingKeys
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case scope
    case createdAt = "created_at"
  }
}
