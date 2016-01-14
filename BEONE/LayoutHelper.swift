
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
    addCenterXLayout(subView)
  }
  
  func addSubViewAndEdgeLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopLayout(subView)
    addBottomLayout(subView)
    addLeadingLayout(subView)
    addTrailingLayout(subView)
  }
  
  func addSubViewAndEdgeMarginLayout(subView: UIView) {
    addSubViewAndEnableAutoLayout(subView)
    addTopMarginLayout(subView)
    addBottomMarginLayout(subView)
    addLeadingMarginLayout(subView)
    addTrailingMarginLayout(subView)
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
  
  func addEqualWidthLayout(view1: UIView, view2: UIView) {
    addConstraint(NSLayoutConstraint(item: view1,
      attribute: .Width,
      relatedBy: .Equal,
      toItem: view2,
      attribute: .Width,
      multiplier: 1,
      constant: 0))
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
  
  func addWidthLayout(width: CGFloat = 0, multiplier: CGFloat = 1, view: UIView? = nil) {
    let layoutAttribute: NSLayoutAttribute = view == nil ? .NotAnAttribute : .Width
    addConstraint(NSLayoutConstraint(item: self,
      attribute: .Width,
      relatedBy: .Equal,
      toItem: view,
      attribute: layoutAttribute,
      multiplier: multiplier,
      constant: width))
  }
  
  func addVerticalLayout(topView: UIView, bottomView: UIView, contsant: CGFloat = 0) {
    addConstraint(NSLayoutConstraint(item: bottomView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: topView,
      attribute: .Bottom,
      multiplier: 1,
      constant: contsant))
  }
  
  func addHorizontalLayout(leftView: UIView, rightView: UIView, contsant: CGFloat = 0) {
    addConstraint(NSLayoutConstraint(item: rightView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: leftView,
      attribute: .Right,
      multiplier: 1,
      constant: contsant))
  }
  
  func addLeftLayout(leftView: UIView, rightView: UIView, contsant: CGFloat = 0) {
    addConstraint(NSLayoutConstraint(item: rightView,
      attribute: .Left,
      relatedBy: .Equal,
      toItem: leftView,
      attribute: .Left,
      multiplier: 1,
      constant: contsant))
  }
  
  func addRightLayout(leftView: UIView, rightView: UIView, contsant: CGFloat = 0) {
    addConstraint(NSLayoutConstraint(item: rightView,
      attribute: .Right,
      relatedBy: .Equal,
      toItem: leftView,
      attribute: .Right,
      multiplier: 1,
      constant: contsant))
  }
}

// MARK: - Bottom Layout Methods

extension UIView {
  func addBottomLayout(subView: UIView, constant: CGFloat = 0) {
    addBottomMarginLayout(subView, constant: constant, layoutAttribute: .Bottom)
  }
 
  func addBottomMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addBottomMarginLayout(subView, constant: constant, layoutAttribute: .BottomMargin)
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
  func addTopLayout(subView: UIView, constant: CGFloat = 0) {
    addTopMarginLayout(subView, constant: constant, layoutAttribute: .Top)
  }
  
  func addTopMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addTopMarginLayout(subView, constant: constant, layoutAttribute: .TopMargin)
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
  func addLeadingLayout(subView: UIView, constant: CGFloat = 0) {
    addLeadingMarginLayout(subView, constant: constant, layoutAttribute: .Left)
  }
  
  
  func addLeadingMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addLeadingMarginLayout(subView, constant: constant, layoutAttribute: .LeftMargin)
  }
  
  private func addLeadingMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
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
  func addTrailingLayout(subView: UIView, constant: CGFloat = 0) {
    addTrailingMarginLayout(subView, constant: constant, layoutAttribute: .Right)
  }
  
  func addTrailingMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addTrailingMarginLayout(subView, constant: constant, layoutAttribute: .RightMargin)
  }
  
  private func addTrailingMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
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
  func addCenterXLayout(subView: UIView, constant: CGFloat = 0) {
    addCenterXMarginLayout(subView, constant: constant, layoutAttribute: .CenterX)
  }
  
  func addCenterXMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addCenterXMarginLayout(subView, constant: constant, layoutAttribute: .CenterXWithinMargins)
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

// MARK: - CenterY Layout Methods

extension UIView {
  func addCenterYLayout(subView: UIView, constant: CGFloat = 0) {
    addCenterYMarginLayout(subView, constant: constant, layoutAttribute: .CenterY)
  }
  
  func addCenterYMarginLayout(subView: UIView, constant: CGFloat = 0) {
    addCenterYMarginLayout(subView, constant: constant, layoutAttribute: .CenterYWithinMargins)
  }
  
  private func addCenterYMarginLayout(subView: UIView, constant: CGFloat, layoutAttribute: NSLayoutAttribute) {
    addConstraint(NSLayoutConstraint(item: subView,
      attribute: .CenterY,
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
