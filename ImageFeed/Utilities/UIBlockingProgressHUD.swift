import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
  private static var window: UIWindow? {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first
            }
            return nil
  }
  
  static func show() {
    window?.isUserInteractionEnabled = false
    ProgressHUD.animate()
  }
  
  static func dismiss() {
    window?.isUserInteractionEnabled = true
    ProgressHUD.dismiss()
  }
}
