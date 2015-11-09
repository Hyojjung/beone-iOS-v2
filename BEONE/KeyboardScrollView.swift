
import UIKit

class KeyboardScrollView: UIScrollView {
  
  var focusOffset = CGFloat(0)
  private let tapRecognizer = UITapGestureRecognizer()
  
  // MARK: - Init & Deinit
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    tapRecognizer.addTarget(self, action: "handleScrollViewTapped")
    addGestureRecognizer(tapRecognizer)
    addKeyboardObservers()
  }
  
  deinit {
    removeKeyboardObservers()
    removeGestureRecognizer(tapRecognizer)
  }
  
  // MARK: - Private Methods
  
  private func addKeyboardObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleKeyboardWillShow:",
      name: UIKeyboardWillShowNotification,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleKeyboardWillHide:",
      name: UIKeyboardWillHideNotification,
      object: nil)
  }
  
  private func removeKeyboardObservers() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - Notification Actions
  
  func handleScrollViewTapped() {
    endEditing(true)
  }
  
  func handleKeyboardWillShow(notification: NSNotification) {
    if let info = notification.userInfo, let keyboadSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
      if contentSize.height - focusOffset + keyboadSize.height >= frame.height {
        setContentOffset(CGPointMake(contentOffset.x, focusOffset), animated: true)
      } else if contentSize.height + keyboadSize.height <= frame.height {
        setContentOffset(CGPointMake(contentOffset.x, 0), animated: true)
      } else {
        setContentOffset(CGPointMake(contentOffset.x, contentSize.height - frame.height + keyboadSize.height), animated: true)
      }
      
      if contentSize.height + keyboadSize.height >= ViewControllerHelper.screenHeight - frame.origin.y {
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboadSize.height, 0)
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
      }
    }
  }
  
  func handleKeyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.25) { () -> Void in
      self.contentInset = UIEdgeInsetsZero
      self.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  }
}
