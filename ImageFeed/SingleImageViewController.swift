import UIKit

final class SingleImageViewController: UIViewController {
  
  var image: UIImage?
  
  @IBOutlet private weak var imageView: UIImageView!
  
  @IBAction func didTapBackButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
    
  }
}
