import UIKit

final class ProfileViewController: UIViewController {
  
  
  
  @IBOutlet private weak var profileImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var nickLabel: UILabel!
  @IBOutlet private weak var userTextLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
  }
  
  private func setupInterface() {
    profileImageView.layer.cornerRadius = 35
  }
  
}

