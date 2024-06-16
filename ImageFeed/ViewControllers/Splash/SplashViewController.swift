import UIKit

// MARK: - SplashViewController

final class SplashViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private var unsplashLogoImageView = UIImageView()
  private let storage = OAuth2TokenStorage()
  
  // MARK: - Lifecycle Methods
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    configureUI()
    
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
  
  private func switchToTabBarController() {
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("Invalid window configuration")
      return
    }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
  
  private func configureUI() {
    configureView()
    configureUnsplashLogoImageView()
  }
  
  private func configureView() {
    view.backgroundColor = UIColor(named: "YPBlack")
  }
  
  private func configureUnsplashLogoImageView() {
    unsplashLogoImageView.image = UIImage(named: "unsplashLogoWhite")
    unsplashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(unsplashLogoImageView)
    
    NSLayoutConstraint.activate([
      unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60),
      unsplashLogoImageView.heightAnchor.constraint(equalTo: unsplashLogoImageView.widthAnchor)
    ])
  }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
  func didAuthenticate(_ vc: AuthViewController) {
    vc.dismiss(animated: true) {
      self.switchToTabBarController()
    }
  }
}
