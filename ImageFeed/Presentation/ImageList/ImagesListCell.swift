import UIKit

final class ImagesListCell: UITableViewCell {
  static let reusedIdentifier = "ImagesListCell"
  
  @IBOutlet private weak var cellImage: UIImageView!
  @IBOutlet private weak var likeButton: UIButton!
  @IBOutlet private weak var dateLabel: UILabel!
  
  func configure(image: UIImage?, date: String, isLiked: Bool) {
    cellImage.image = image
    dateLabel.text = date
    
    let likeImage = isLiked ? UIImage(named: "likeButtonActive") : UIImage(named: "likeButtonInactive")
    likeButton.setImage(likeImage, for: .normal)
  }
}
