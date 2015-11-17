
import UIKit

class LoadingView: UIView {
  
  let indicator = UIActivityIndicatorView()
  let blurEffectView = UIVisualEffectView()
  
  func layout() {
    translatesAutoresizingMaskIntoConstraints = false
    hide()
    
    backgroundColor = UIColor.clearColor()
    let blurEffect = UIBlurEffect(style: .Light)
    blurEffectView.effect = blurEffect
    addSubViewAndEdgeLayout(blurEffectView)
    // background view
    
    addSubViewAndCenterLayout(indicator)
    indicator.color = darkGold
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
