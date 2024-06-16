import UIKit
import WebKit

// MARK: - WebViewViewControllerDelegate

protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ vc: WebViewViewController, didAuthentificateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - WebViewConstants

enum WebViewConstants {
  static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

// MARK: - WebViewViewController

final class WebViewViewController: UIViewController {
  
  // MARK: - Private Properties
  
  weak var delegate: WebViewViewControllerDelegate?
  private var webView = WKWebView()
  private var progressView = UIProgressView()
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    loadAuthView()
    webView.navigationDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if self.isMovingFromParent {
      webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(WKWebView.estimatedProgress) {
      updateProgress()
    } else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
  
  // MARK: - Private Methods
  
  private func updateProgress() {
    progressView.progress = Float(webView.estimatedProgress)
    progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
  }
  
  private func loadAuthView() {
    guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
    
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: Constants.accessScope)
    ]
    
    guard let url = urlComponents.url else { return }
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  private func configureUI() {
    configureWebView()
    configureUIProgressView()
  }
  
  private func configureWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(webView)
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func configureUIProgressView() {
    progressView.tintColor = UIColor(named: "YPBlack")
    progressView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(progressView)
    
    NSLayoutConstraint.activate([
      progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      progressView.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
  
  private func fetchCode(from url: URL?) -> String? {
    guard
      let url = url,
      let urlComponents = URLComponents(string: url.absoluteString),
      urlComponents.path == "/oauth/authorize/native",
      let item = urlComponents.queryItems?.first(where: { $0.name == "code" }) else { return nil }
    return item.value
  }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let code = fetchCode(from: navigationAction.request.url) {
      delegate?.webViewViewController(self, didAuthentificateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}
