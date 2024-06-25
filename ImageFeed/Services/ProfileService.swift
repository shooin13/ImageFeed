import Foundation

// MARK: - ProfileService

final class ProfileService {
  
  // MARK: - Private properties
  
  private let urlSession = URLSession.shared
  private var task: URLSessionTask?
  
  // MARK: - Public properties
  
  private(set) var profile: Profile?
  
  // MARK: - Public Methods
  
  func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
    assert(Thread.isMainThread)
    
    if task != nil {
      print("Profile fetch in progress")
      return
    }
    
    guard let request = makeProfileRequest(token: token) else {
      completion(.failure(NetworkError.urlSessionError))
      print("Failed to create URLRequest for fetching profile")
      return
    }
    
    let task = urlSession.data(for: request) { [weak self] result in
      DispatchQueue.main.async {
        self?.task = nil
        switch result {
        case .success(let data):
          do {
            let profileResult = try SnakeCaseJSONDecoder().decode(ProfileResult.self, from: data)
            let profile = Profile(from: profileResult)
            self?.profile = profile
            completion(.success(profile))
          } catch {
            completion(.failure(error))
            print("Failed to decode ProfileResult: \(error)")
          }
        case .failure(let error):
          completion(.failure(error))
          print("Failed to fetch profile: \(error)")
        }
      }
    }
    self.task = task
    task.resume()
  }
  
  // MARK: - Private Methods
  
  private func makeProfileRequest(token: String) -> URLRequest? {
    guard let url = URL(string: "\(Constants.defaultBaseURL!)me") else {
      fatalError("Failed to create URL for profile request")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}
