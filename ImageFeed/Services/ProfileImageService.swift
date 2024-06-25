import Foundation

// MARK: - ProfileImageService

final class ProfileImageService {
  
  // MARK: - Public Properties
  static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
  static let shared = ProfileImageService()
  private(set) var avatarURL: String?
  
  // MARK: - Private Properties
  
  private let urlSession = URLSession.shared
  private var task: URLSessionTask?
  
  // MARK: - Initializer
  
  private init() {}
  
  // MARK: - Public Methods
  
  func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
    assert(Thread.isMainThread)
    
    if task != nil {
      print("Profile image fetch in progress")
      return
    }
    
    guard let request = makeProfileImageRequest(username: username) else {
      completion(.failure(NetworkError.urlSessionError))
      print("Failed to create URLRequest for fetching profile image")
      return
    }
    
    let task = urlSession.data(for: request) { [weak self] result in
      DispatchQueue.main.async {
        self?.task = nil
        switch result {
        case .success(let data):
          do {
            let userResult = try SnakeCaseJSONDecoder().decode(UserResult.self, from: data)
            let avatarURL = userResult.profileImage.small
            self?.avatarURL = avatarURL
            completion(.success(avatarURL))
            NotificationCenter.default.post(
              name: ProfileImageService.didChangeNotification,
              object: self,
              userInfo: ["URL": avatarURL]
            )
          } catch {
            completion(.failure(error))
            print("Failed to decode UserResult: \(error)")
          }
        case .failure(let error):
          completion(.failure(error))
          print("Failed to fetch profile image: \(error)")
        }
      }
    }
    self.task = task
    task.resume()
  }
  
  // MARK: - Private Methods
  
  private func makeProfileImageRequest(username: String) -> URLRequest? {
    guard let url = URL(string: "\(Constants.defaultBaseURL!)users/\(username)") else {
      fatalError("Failed to create URL for profile image request")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    guard let token = OAuth2TokenStorage().token else {
      return nil
    }
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}

// MARK: - UserResult

struct UserResult: Codable {
  let profileImage: ProfileImage
  
  enum CodingKeys: String, CodingKey {
    case profileImage = "profile_image"
  }
}

struct ProfileImage: Codable {
  let small: String
}
