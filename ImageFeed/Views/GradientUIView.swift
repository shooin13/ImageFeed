import UIKit

// MARK: - GradientUIView

final class GradientUIView: UIView {
  
  // MARK: - Private Properties
  
  private let gradientLayer = CAGradientLayer()
  private let maskLayer = CAShapeLayer()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradient()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGradient()
  }
  
  // MARK: - Lifecycle Methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    updateMask()
  }
  
  // MARK: - Private Methods
  
  private func setupGradient() {
    layer.addSublayer(gradientLayer)
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ypBlack.cgColor]
    gradientLayer.masksToBounds = true
  }
  
  private func updateMask() {
    let maskPath = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: [.bottomLeft, .bottomRight],
      cornerRadii: CGSize(width: 16, height: 16)
    ).cgPath
    maskLayer.path = maskPath
    layer.mask = maskLayer
  }
}
