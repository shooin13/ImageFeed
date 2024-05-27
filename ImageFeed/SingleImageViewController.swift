import UIKit

final class SingleImageViewController: UIViewController {
  
  var image: UIImage? {
    didSet {
        guard isViewLoaded, let image else { return }

        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
  }
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var scrollView: UIScrollView!
  
  @IBOutlet private weak var shareButton: UIButton!
  
  @IBAction func didTapBackButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapShareButton(_ sender: Any) {
    guard let image else { return }
    let sharedImage = [image]
    let activityViewController = UIActivityViewController(activityItems: sharedImage, applicationActivities: nil)
    self.present(activityViewController, animated: true)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupInterface()
  }
  
  private func setupInterface() {
    guard let image else { return }
    imageView.image = image
    imageView.frame.size = image.size
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
    scrollView.contentSize = imageView.frame.size
    rescaleAndCenterImageInScrollView(image: image)
    shareButton.layer.cornerRadius = 25
    shareButton.titleLabel?.text = ""
  }
  
  private func rescaleAndCenterImageInScrollView(image: UIImage) {
    let minZoomScale = scrollView.minimumZoomScale
    let maxZoomScale = scrollView.maximumZoomScale
    view.layoutIfNeeded()
    let visibleRectSize = scrollView.bounds.size
    let imageSize = image.size
    let hScale = visibleRectSize.width / imageSize.width
    let vScale = visibleRectSize.height / imageSize.height
    let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
    scrollView.setZoomScale(scale, animated: false)
    scrollView.layoutIfNeeded()
    let newContentSize = scrollView.contentSize
    let x = (newContentSize.width - visibleRectSize.width) / 2
    let y = (newContentSize.height - visibleRectSize.height) / 2
    scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
  }
}

extension SingleImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
}
