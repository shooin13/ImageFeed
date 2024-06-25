import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
  
  // MARK: - Private Properties
  
  private lazy var profileImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "profilePicture")
    image.translatesAutoresizingMaskIntoConstraints = false
    image.layer.cornerRadius = 35
    image.layer.masksToBounds = true
    return image
  }()
  
  private lazy var exitButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "exitButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 23)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var nickLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var userTextLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let profileService = ProfileService()
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    updateProfileDetails()
  }
  
  // MARK: - Private Methods
  
  private func setupViews() {
    view.addSubview(profileImageView)
    view.addSubview(exitButton)
    view.addSubview(nameLabel)
    view.addSubview(nickLabel)
    view.addSubview(userTextLabel)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      profileImageView.widthAnchor.constraint(equalToConstant: 70),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
      
      exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      exitButton.widthAnchor.constraint(equalToConstant: 24),
      exitButton.heightAnchor.constraint(equalTo: exitButton.widthAnchor),
      
      nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
      
      nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      nickLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
      
      userTextLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
      userTextLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
    ])
  }
  
  private func updateProfileDetails() {
    if let profile = profileService.profile {
      updateProfileDetails(profile: profile)
    }
  }
  
  private func updateProfileDetails(profile: Profile) {
    nameLabel.text = profile.name
    nickLabel.text = profile.loginName
    userTextLabel.text = profile.bio
  }
}
