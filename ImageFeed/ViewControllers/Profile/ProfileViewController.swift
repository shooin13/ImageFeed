import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private var profileImageView = UIImageView()
  private var exitButton = UIButton()
  private var nameLabel = UILabel()
  private var nickLabel = UILabel()
  private var userTextLabel = UILabel()
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Private Methods
  
  private func configureUI() {
    configureProfileImageView()
    configureExitButtonView()
    configureNameLabel()
    configureNickLabel()
    configureUserTextLabel()
  }
  
  private func configureProfileImageView() {
    profileImageView.image = UIImage(named: "profilePicture")
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.layer.cornerRadius = 35
    profileImageView.layer.masksToBounds = true
    
    view.addSubview(profileImageView)
    
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      profileImageView.widthAnchor.constraint(equalToConstant: 70),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
    ])
  }
  
  private func configureExitButtonView() {
    exitButton.setImage(UIImage(named: "exitButton"), for: .normal)
    exitButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(exitButton)
    
    NSLayoutConstraint.activate([
      exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      exitButton.widthAnchor.constraint(equalToConstant: 24),
      exitButton.heightAnchor.constraint(equalTo: exitButton.widthAnchor)
    ])
  }
  
  private func configureNameLabel() {
    nameLabel.text = "Павел Николаев"
    nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
    nameLabel.textColor = .white
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
    ])
  }
  
  private func configureNickLabel() {
    nickLabel.text = "@the314"
    nickLabel.font = UIFont.systemFont(ofSize: 13)
    nickLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    nickLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nickLabel)
    
    NSLayoutConstraint.activate([
      nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      nickLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
    ])
  }
  
  private func configureUserTextLabel() {
    userTextLabel.text = "Hello, Praktikum"
    userTextLabel.font = UIFont.systemFont(ofSize: 13)
    userTextLabel.textColor = .white
    userTextLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(userTextLabel)
    
    NSLayoutConstraint.activate([
      userTextLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
      userTextLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
    ])
  }
}
