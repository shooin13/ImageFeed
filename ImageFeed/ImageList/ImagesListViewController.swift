import UIKit

final class ImagesListViewController: UIViewController {
  
  private let photosName: [String] = Array(0..<20).map{"\($0)"}
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  @IBOutlet private weak var tableView: UITableView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 200
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
  }
}

private extension ImagesListViewController {
  private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    guard let image = UIImage(named: photosName[indexPath.row]) else { return }
    cell.cellImage.image = image
    
    cell.dateLabel.text = dateFormatter.string(from: Date())
    
    let isLIked = indexPath.row % 2 == 0
    let likeImage = isLIked ? UIImage(named: "likeButtonInactive") : UIImage(named: "likeButtonActive")
    cell.likeButton.setImage(likeImage, for: .normal)
  }
}

extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    photosName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reusedIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      print("Cells returned empty")
      return UITableViewCell()
    }
    configCell(for: imageListCell, with: indexPath)
    return imageListCell
  }
}

extension ImagesListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let image = UIImage(named: photosName[indexPath.row]) else {
      print("returns 0")
      return 0
    }
    
    print("calculates size")
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = image.size.width
    let scale = imageViewWidth / imageWidth
    let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}
