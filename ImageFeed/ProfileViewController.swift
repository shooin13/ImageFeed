import UIKit

final class ProfileViewController: UIViewController {
  
  private weak var profileImageView: UIImageView?
  private weak var exitButton: UIButton?
  private weak var nameLabel: UILabel?
  private weak var nickLabel: UILabel?
  private weak var userTextLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  private func configureUI() {
    configureProfileImageView()
    configureExitButtonView()
    configureNameLabel()
    configureNickLabel()
    configureUserTextLabel()
  }
  
  private func configureProfileImageView() {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "profilePicture")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 35
    imageView.layer.masksToBounds = true
    
    view.addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      imageView.widthAnchor.constraint(equalToConstant: 70),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    ])
    profileImageView = imageView
  }
  
  private func configureExitButtonView() {
    guard let profileImageView else { return }
    let button = UIButton()
    button.setImage(UIImage(named: "exitButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      button.widthAnchor.constraint(equalToConstant: 24),
      button.heightAnchor.constraint(equalTo: button.widthAnchor)
    ])
    
    exitButton = button
  }
  
  private func configureNameLabel() {
    
    guard let profileImageView else { return }
    
    let name = UILabel()
    
    name.text = "Павел Николаев"
    name.font = UIFont.boldSystemFont(ofSize: 23)
    name.textColor = .white
    
    name.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(name)
    
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
      name.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
    ])
    nameLabel = name
  }
  
  private func configureNickLabel() {
    
    guard let profileImageView, let nameLabel else { return }
    
    let nick = UILabel()
    
    nick.text = "@the314"
    nick.font = UIFont.systemFont(ofSize: 13)
    nick.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    
    nick.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nick)
    
    NSLayoutConstraint.activate([
      nick.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      nick.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
    ])
    nickLabel = nick
  }
  
  private func configureUserTextLabel() {
    guard let profileImageView, let nickLabel else { return }
    
    let text = UILabel()
    
    text.text = "Hello, Praktikum"
    text.font = UIFont.systemFont(ofSize: 13)
    text.textColor = .white
    text.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(text)
    
    NSLayoutConstraint.activate([
      text.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
      text.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
    ])
    userTextLabel = text
  }
}

