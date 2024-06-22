import UIKit
//import ProgressHUD

// MARK: - AuthViewControllerDelegate

protocol AuthViewControllerDelegate: AnyObject {
  func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private let showWebViewSegueIdentifier = "ShowWebView"
  
  private lazy var unsplashLogoImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "unsplashLogoWhite")
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var unsplashLogInButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    button.setTitleColor(UIColor(named: "YPBlack"), for: .normal)
    button.setTitle("Войти", for: .normal)
    button.backgroundColor = .white
    return button
  }()
  
  // MARK: - Public Properties
  
  weak var delegate: AuthViewControllerDelegate?
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Private Methods
  
  private func setupViews() {
    view.backgroundColor = UIColor(named: "YPBlack")
    view.addSubview(unsplashLogoImageView)
    view.addSubview(unsplashLogInButton)
    configureBackButton()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60),
      unsplashLogoImageView.heightAnchor.constraint(equalTo: unsplashLogoImageView.widthAnchor),
      
      unsplashLogInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
      unsplashLogInButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
      unsplashLogInButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
      unsplashLogInButton.heightAnchor.constraint(equalToConstant: 48)
    ])
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
    UIBlockingProgressHUD.show()
    
    OAuth2Service.shared.fetchOAuthToken(code: code) { result in
      DispatchQueue.main.async {
        UIBlockingProgressHUD.dismiss()
        switch result {
        case .success(_):
          self.delegate?.didAuthenticate(self)
        case .failure(let error):
          print("Failed to fetch OAuth token: \(error)")
          let alert = UIAlertController(title: "Ошибка входа", message: "Не получилось авторизоваться. Попробуйте еще раз", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          self.present(alert, animated: true)
        }
      }
    }
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
