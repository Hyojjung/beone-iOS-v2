
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
  
  func addSubViewAndEdgeLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopLayout(subView)
    addBottomLayout(subView)
    addLeftLayout(subView)
    addRightLayout(subView)
  }
  
  func addSubViewAndEdgeMarginLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopMarginLayout(subView)
    addBottomMarginLayout(subView)
    addLeftMarginLayout(subView)
    addRightMarginLayout(subView)
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
  
  func changeWidthLayoutConstant(width: CGFloat?) {
    if let width = width {
      for constraint in constraints {
        if constraint.firstAttribute == .Width {
          constraint.constant = width
        }
      }
    }
  }
  
  func addHeightLayout(height: CGFloat) {
    addConstraint(NSLayoutConstraint(item: self,
      attribute: .Height,
      relatedBy: .Equal,
      toItem: nil,
      attribute: .NotAnAttribute,
      multiplier: 1,
      constant: height))
  }
}

// MARK: - Bottom Layout Methods

extension UIView {
  func addBottomLayout(subView: UIView, constant: CGFloat) {
    addBottomMarginLayout(subView, constant: constant, layoutAttribute: .Bottom)
  }
  
  func addBottomLayout(subView: UIView) {
    addBottomLayout(subView, constant: 0)
  }
  
  func addBottomMarginLayout(subView: UIView, constant: CGFloat) {
    addBottomMarginLayout(subView, constant: constant, layoutAttribute: .BottomMargin)
  }
  
  func addBottomMarginLayout(subView: UIView) {
    addBottomMarginLayout(subView, constant: 0)
  }
  
  private func addBottomMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    let bottomMarginConstraint = NSLayoutConstraint(item: subView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: self,
      attribute: layoutAttribute,
      multiplier: 1,
      constant: -constant)
    bottomMarginConstraint.priority = UILayoutPriorityDefaultHigh
    addConstraint(bottomMarginConstraint)
  }
}

// MARK: - Top Layout Methods

extension UIView {
  func addTopLayout(subView: UIView, constant: CGFloat) {
    addTopMarginLayout(subView, constant: constant, layoutAttribute: .Top)
  }
  
  func addTopLayout(subView: UIView) {
    addTopLayout(subView, constant: 0)
  }
  
  func addTopMarginLayout(subView: UIView, constant: CGFloat) {
    addTopMarginLayout(subView, constant: constant, layoutAttribute: .TopMargin)
  }
  
  func addTopMarginLayout(subView: UIView) {
    addTopMarginLayout(subView, constant: 0)
  }
  
  private func addTopMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: layoutAttribute,
      multiplier: 1,
      constant: constant))
  }
}

// MARK: - Left Layout Methods

extension UIView {
  func addLeftLayout(subView: UIView, constant: CGFloat) {
    addLeftMarginLayout(subView, constant: constant, layoutAttribute: .Left)
  }
  
  func addLeftLayout(subView: UIView) {
    addLeftLayout(subView, constant: 0)
  }
  
  func addLeftMarginLayout(subView: UIView, constant: CGFloat) {
    addLeftMarginLayout(subView, constant: constant, layoutAttribute: .LeftMargin)
  }
  
  func addLeftMarginLayout(subView: UIView) {
    addLeftMarginLayout(subView, constant: 0)
  }
  
  private func addLeftMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: self,
      attribute: layoutAttribute,
      multiplier: 1,
      constant: constant))
  }
}

// MARK: - Right Layout Methods

extension UIView {
  func addRightLayout(subView: UIView, constant: CGFloat) {
    addRightMarginLayout(subView, constant: constant, layoutAttribute: .Right)
  }
  
  func addRightLayout(subView: UIView) {
    addRightLayout(subView, constant: 0)
  }
  
  func addRightMarginLayout(subView: UIView, constant: CGFloat) {
    addRightMarginLayout(subView, constant: constant, layoutAttribute: .RightMargin)
  }
  
  func addRightMarginLayout(subView: UIView) {
    addRightMarginLayout(subView, constant: 0)
  }
  
  private func addRightMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: self,
      attribute: layoutAttribute,
      multiplier: 1,
      constant: -constant))
  }
}

// MARK: - CenterX Layout Methods

extension UIView {
  func addCenterXLayout(subView: UIView, constant: CGFloat) {
    addCenterXMarginLayout(subView, constant: constant, layoutAttribute: .CenterX)
  }
  
  func addCenterXLayout(subView: UIView) {
    addCenterXLayout(subView, constant: 0)
  }
  
  func addCenterXMarginLayout(subView: UIView, constant: CGFloat) {
    addCenterXMarginLayout(subView, constant: constant, layoutAttribute: .CenterXWithinMargins)
  }
  
  func addCenterXMarginLayout(subView: UIView) {
    addCenterXMarginLayout(subView, constant: 0)
  }
  
  private func addCenterXMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .CenterX,
      relatedBy: .Equal,
      toItem: self,
      attribute: layoutAttribute,
      multiplier: 1,
      constant: -constant))
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
