
import UIKit

extension UIView {
  func addSubViewAndEnableAutoLayout(subView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subView)
  }
  
  func addSubViewAndCenterLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .CenterY,
      relatedBy: .Equal,
      toItem: self,
      attribute: .CenterY,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .CenterX,
      relatedBy: .Equal,
      toItem: self,
      attribute: .CenterX,
      multiplier: 1,
      constant: 0))
  }
  
  func addSubViewAndLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Top,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Bottom,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Left,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Right,
      multiplier: 1,
      constant: 0))
  }
  
  func addSubViewAndMarginLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopMarginLayout(subView)
    addBottomMarginLayout(subView)
    addHorizontalMarginLayout(subView)
  }
  
  func addHorizontalMarginLayout(subView: UIView) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: self,
      attribute: .LeftMargin,
      multiplier: 1,
      constant: 0))
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: self,
      attribute: .RightMargin,
      multiplier: 1,
      constant: 0))
  }
  
  func addTopMarginLayout(subView: UIView) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: .TopMargin,
      multiplier: 1,
      constant: 0))
  }
  
  func addBottomMarginLayout(subView: UIView) {
    let bottomMarginConstraint = NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: self,
      attribute: .BottomMargin,
      multiplier: 1,
      constant: 0)
    bottomMarginConstraint.priority = UILayoutPriorityDefaultHigh
    addConstraint(bottomMarginConstraint)
  }
  
  func changeHeightLayoutConstant(height: CGFloat?) {
    if let height = height {
      for constraint in constraints {
        if constraint.firstAttribute == .Height {
          constraint.constant = height
        }
      }
    }
  }
}

extension UIViewController {
  func addVerticalLayoutGuideLayout(subView: UIView) {
    view.addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: topLayoutGuide,
      attribute: .Bottom,
      multiplier: 1,
      constant: 0))
    view.addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: bottomLayoutGuide,
      attribute: .Top,
      multiplier: 1,
      constant: 0))
  }
}
