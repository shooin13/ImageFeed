import UIKit

final class GradientUIView: UIView {
  private let gradientLayer = CAGradientLayer()
  private let maskLayer = CAShapeLayer() // Добавляем новый слой для маски
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradient()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGradient()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    updateMask()
  }
  
  private func setupGradient() {
    self.layer.addSublayer(gradientLayer)
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
