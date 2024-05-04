import UIKit

final class ImagesListViewController: UIViewController {
  
  private let mockImagesArray = [UIImage(systemName: "0"), UIImage(systemName: "1")]
  
  @IBOutlet private var tableView: UITableView!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 200
  }
}

extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reusedIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
      print("Cells returned empty")
      return UITableViewCell()
    }
    configCell(for: imageListCell)
    return imageListCell
  }
}

extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension ImagesListViewController {
  private func configCell(for cell: ImagesListCell) {
    
  }
}
