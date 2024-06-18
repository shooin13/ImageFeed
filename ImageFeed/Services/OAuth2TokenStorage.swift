import Foundation

// MARK: - OAuth2TokenStorage

final class OAuth2TokenStorage {
  
  // MARK: - Public Properties
  
  var token: String? {
    get {
      return UserDefaults.standard.string(forKey: tokenKey)
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: tokenKey)
    }
  }
  
  // MARK: - Private Properties
  
  private let tokenKey = "OAuth2Token"
  
}
