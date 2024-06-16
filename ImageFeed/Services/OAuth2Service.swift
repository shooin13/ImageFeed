import Foundation

final class OAuth2Service {
  
  static let shared = OAuth2Service()
  
  private init() {}
  
  private func makeOauthTokenRequest(code: String) -> URLRequest {
    
    guard var baseUrlComponent = URLComponents(string: "https://unsplash.com/oauth/token") else { fatalError("Failed to create baseUrlComponent") }
    
    baseUrlComponent.queryItems = [URLQueryItem(name: "client_id", value: Constants.accessKey),
                                   URLQueryItem(name: "client_secret", value: Constants.secretKey),
                                   URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                                   URLQueryItem(name: "code", value: code),
                                   URLQueryItem(name: "grant_type", value: "authorization_code")]
    
    guard let url = baseUrlComponent.url else { fatalError("Failed to create URL from baseUrlComponent") }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
  }
  
  func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
    let request = makeOauthTokenRequest(code: code)
    
    let task = URLSession.shared.data(for: request) { result in
      switch result {
      case .success(let data):
        do {
          let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
          OAuth2TokenStorage().token = tokenResponse.accessToken
          handler(.success(tokenResponse.accessToken))
        } catch {
          handler(.failure(error))
          print("Failed to decode OAuthTokenResponseBody: \(error)")
        }
      case .failure(let error):
        handler(.failure(error))
        print("Failed to fetch OAuth token: \(error)")
      }
    }
    // `task.resume()` уже вызывается внутри метода `data(for:completion:)`
  }
}
