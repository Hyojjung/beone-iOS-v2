
import UIKit

class LoadingView: UIView {
  
  private let indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.color = darkGold
    return indicator
  }()
  private let blurEffectView: UIVisualEffectView = {
    let blurEffectView = UIVisualEffectView()
    blurEffectView.effect = UIBlurEffect(style: .Light)
    return blurEffectView
  }()
  
  func layout() {
    hide()
    backgroundColor = UIColor.clearColor()
    translatesAutoresizingMaskIntoConstraints = false

    addSubViewAndEdgeLayout(blurEffectView)
    // background view
    
    addSubViewAndCenterLayout(indicator)
    indicator.startAnimating()
    // indicator
  }
  
  func show() {
    hidden = false
  }
  
  func hide() {
    hidden = true
  }
}
