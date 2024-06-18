import UIKit

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
  
  // MARK: - Static Properties
  
  static let reusedIdentifier = "ImagesListCell"
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var cellImage: UIImageView!
  @IBOutlet private weak var likeButton: UIButton!
  @IBOutlet private weak var dateLabel: UILabel!
  
  // MARK: - Public Methods
  
  func configure(image: UIImage?, date: String, isLiked: Bool) {
    cellImage.image = image
    dateLabel.text = date
    
    let likeImage = isLiked ? UIImage(named: "likeButtonActive") : UIImage(named: "likeButtonInactive")
    likeButton.setImage(likeImage, for: .normal)
  }
}
