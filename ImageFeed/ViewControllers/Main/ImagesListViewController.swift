import UIKit

// MARK: - ImagesListViewController

final class ImagesListViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private let photosName: [String] = Array(0..<20).map { "\($0)" }
  private let showSingleImageIdentifier = "ShowSingleImage"
  
  // MARK: - Lazy Properties
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Lifecycle Methods
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 200
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showSingleImageIdentifier {
      guard
        let viewController = segue.destination as? SingleImageViewController,
        let indexPath = sender as? IndexPath
      else {
        assertionFailure("Invalid Segue Identifier")
        return
      }
      let image = UIImage(named: photosName[indexPath.row])
      viewController.image = image
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  // MARK: - Private Methods
  
  private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    guard let image = UIImage(named: photosName[indexPath.row]) else { return }
    let isLiked = indexPath.row % 2 == 0
    cell.configure(image: image, date: dateFormatter.string(from: Date()), isLiked: isLiked)
  }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photosName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reusedIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      return UITableViewCell()
    }
    configCell(for: imageListCell, with: indexPath)
    return imageListCell
  }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    guard let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath) else { return true }
    selectedCell.contentView.backgroundColor = UIColor(named: "YPBlack")
    return true
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let image = UIImage(named: photosName[indexPath.row]) else {
      return 0
    }
    
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = image.size.width
    let scale = imageViewWidth / imageWidth
    let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}
