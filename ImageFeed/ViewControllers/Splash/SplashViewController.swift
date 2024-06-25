import UIKit

// MARK: - SplashViewController

final class SplashViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private let storage = OAuth2TokenStorage()
  
  private lazy var unsplashLogoImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "unsplashLogoWhite")
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private let profileService = ProfileService()
  
  // MARK: - Lifecycle Methods
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    setupViews()
    setupConstraints()
    
    if storage.token != nil {
      switchToTabBarController()
    } else {
      performSegue(withIdentifier: "showAuthenticationScreen", sender: nil)
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAuthenticationScreen" {
      guard
        let navigationController = segue.destination as? UINavigationController,
        let viewController = navigationController.viewControllers.first as? AuthViewController
      else {
        assertionFailure("Failed to prepare for showAuthenticationScreen")
        return
      }
      viewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  // MARK: - Private Methods
  
  private func setupViews() {
    view.backgroundColor = UIColor(named: "YPBlack")
    view.addSubview(unsplashLogoImageView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60),
      unsplashLogoImageView.heightAnchor.constraint(equalTo: unsplashLogoImageView.widthAnchor)
    ])
  }
  
  private func switchToTabBarController() {
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("Invalid window configuration")
      return
    }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
  
  private func showErrorFetchingProfileAlert() {
    let alert = UIAlertController(title: "Error", message: "Failed to fetch profile. Please try again.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
  func didAuthenticate(_ vc: AuthViewController) {
    vc.dismiss(animated: true) {
      self.switchToTabBarController()
    }
    
    guard let token = storage.token else {
      return
    }
    fetchProfile(token)
  }
  
  private func fetchProfile(_ token: String) {
    UIBlockingProgressHUD.show()
    profileService.fetchProfile(token) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      
      guard let self = self else { return }
      
      switch result {
      case .success:
        self.switchToTabBarController()
        
      case .failure:
        self.showErrorFetchingProfileAlert()
      }
    }
  }
}
