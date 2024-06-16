import UIKit

// MARK: - AuthViewControllerDelegate

protocol AuthViewControllerDelegate: AnyObject {
  func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private let showWebViewSegueIdentifier = "ShowWebView"
  private var unsplashLogoImageView = UIImageView()
  private var unsplashLogInButton = UIButton()
  
  // MARK: - Public Properties
  
  weak var delegate: AuthViewControllerDelegate?
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Private Methods
  
  private func configureUI() {
    configureView()
    configureUnsplashLogInButton()
    configureUnsplashLogoImageView()
    configureBackButton()
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
  
  private func configureUnsplashLogInButton() {
    unsplashLogInButton.layer.cornerRadius = 16
    unsplashLogInButton.layer.masksToBounds = true
    unsplashLogInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    unsplashLogInButton.setTitleColor(UIColor(named: "YPBlack"), for: .normal)
    unsplashLogInButton.setTitle("Войти", for: .normal)
    unsplashLogInButton.backgroundColor = .white
    unsplashLogInButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(unsplashLogInButton)
    
    NSLayoutConstraint.activate([
      unsplashLogInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
      unsplashLogInButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
      unsplashLogInButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
      unsplashLogInButton.heightAnchor.constraint(equalToConstant: 48)
    ])
    
    unsplashLogInButton.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
  }
  
  private func configureBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
  }
  
  @objc private func openWebViewController() {
    performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showWebViewSegueIdentifier {
      guard let webViewViewController = segue.destination as? WebViewViewController else {
        fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
      }
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthentificateWithCode code: String) {
    vc.dismiss(animated: true)
    
    OAuth2Service.shared.fetchOAuthToken(code: code) { result in
      switch result {
      case .success(_):
        self.delegate?.didAuthenticate(self)
      case .failure(let error):
        print("Failed to fetch OAuth token: \(error)")
      }
    }
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
