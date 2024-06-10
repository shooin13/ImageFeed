import UIKit

final class AuthViewController: UIViewController {
  
  private let showWebViewSegueIdentifier = "ShowWebView"
  private var unsplashLogoImageView = UIImageView()
  private var unsplashLogInButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    let webViewViewController = WebViewViewController()
    webViewViewController.delegate = self
  }
  
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
      unsplashLogInButton.widthAnchor.constraint(equalToConstant: 60),
      unsplashLogInButton.heightAnchor.constraint(equalTo: unsplashLogInButton.widthAnchor)
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
  
  private func configureBackButton(){
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button") // 1
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button") // 2
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
    navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
  }
  
  @objc private func openWebViewController() {
    performSegue(withIdentifier: showWebViewSegueIdentifier, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showWebViewSegueIdentifier {
      guard
        let webViewViewController = segue.destination as? WebViewViewController
      else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthentificateWithCode code: String) {
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
  
  
}
