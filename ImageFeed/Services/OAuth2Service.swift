import Foundation

// MARK: - AuthServiceError
enum AuthServiceError: Error {
  case invalidRequest
  case duplicateRequest
}

// MARK: - OAuth2Service

final class OAuth2Service {
  static let shared = OAuth2Service()
  
  // MARK: - Private properties
  private let urlSession = URLSession.shared
  
  private var task: URLSessionTask?
  private var lastCode: String?
  
  // MARK: - Initializer
  
  private init() {}
  
  // MARK: - Public Methods
  
  func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
    assert(Thread.isMainThread)
    
    if let currentTask = task, lastCode == code {
      handler(.failure(AuthServiceError.duplicateRequest))
      return
    }
    
    task?.cancel()
    
    guard let request = makeOauthTokenRequest(code: code) else {
      handler(.failure(AuthServiceError.invalidRequest))
      return
    }
    
    let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.task = nil
        self.lastCode = nil
        if let error = error {
          handler(.failure(error))
          print("Failed to fetch OAuth token: \(error)")
        } else if let data = data {
          do {
            let tokenResponse = try SnakeCaseJSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            OAuth2TokenStorage().token = tokenResponse.accessToken
            handler(.success(tokenResponse.accessToken))
          } catch {
            handler(.failure(error))
            print("Failed to decode OAuthTokenResponseBody: \(error)")
          }
        } else {
          handler(.failure(AuthServiceError.invalidRequest))
          print("Failed to fetch OAuth token: No data received")
        }
      }
    }
    self.task = task
    self.lastCode = code
    task.resume()
  }
  
  // MARK: - Private Methods
  
  private func makeOauthTokenRequest(code: String) -> URLRequest? {
    guard var baseUrlComponent = URLComponents(string: "https://unsplash.com/oauth/token") else {
      fatalError("Failed to create baseUrlComponent")
    }
    
    baseUrlComponent.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "client_secret", value: Constants.secretKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "grant_type", value: "authorization_code")
    ]
    
    guard let url = baseUrlComponent.url else {
      fatalError("Failed to create URL from baseUrlComponent")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
  }
}
