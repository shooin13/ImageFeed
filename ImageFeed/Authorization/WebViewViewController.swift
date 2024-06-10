import UIKit
import WebKit

enum WebViewConstants {
  static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController {
  
  weak var delegate: WebViewViewControllerDelegate?
  
  private var webView = WKWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    loadAuthView()
    webView.navigationDelegate = self
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
    print(request)
  }
  
  private func configureUI() {
    configureWebView()
  }
  
  private func configureWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(webView)
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
}

extension WebViewViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if code(from: navigationAction) != nil {
      //TODO: process code
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
  
  private func code(from navigationAction: WKNavigationAction) -> String? {
    if
      let url = navigationAction.request.url,
      let urlComponents = URLComponents(string: url.absoluteString),
      urlComponents.path == "/oauth/authorize/native",
      let items = urlComponents.queryItems,
      let codeItem = items.first(where: { $0.name == "code" })
    {
      return codeItem.value
    } else {
      return nil
    }
  }
}

protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ vc: WebViewViewController, didAuthentificateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

