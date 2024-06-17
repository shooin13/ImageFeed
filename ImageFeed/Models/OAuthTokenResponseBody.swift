import Foundation

// MARK: - OAuthTokenResponseBody

struct OAuthTokenResponseBody: Codable {
  let accessToken: String
  let tokenType: String
  let scope: String
  let createdAt: Date
  
  // MARK: - CodingKeys
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "accessToken"
    case tokenType = "tokenType"
    case scope
    case createdAt = "createdAt"
  }
}
