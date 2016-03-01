
import UIKit

protocol DynamicHeightTableViewDelegate: NSObjectProtocol {  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat?
  func cellIdentifier(indexPath: NSIndexPath) -> String
}

class DynamicHeightTableView: UITableView {
  
  weak var dynamicHeightDelgate: DynamicHeightTableViewDelegate!
  
  // MARK: - UITableViewDynamicHeightHelper
  
  func heightForBasicCell(indexPath: NSIndexPath) -> CGFloat {
    let cellIdentifier = dynamicHeightDelgate.cellIdentifier(indexPath)
    var cell = dequeueReusableCellWithIdentifier(cellIdentifier)
      if cell == nil {
        registerNib(UINib(nibName: cellIdentifier.convertToBigCamelCase(), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        cell = dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
      }
    if let cell = cell {
      return calculateHeight(cell, indexPath: indexPath)
    }
    return 0
  }
  
  private func calculateHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat {
    if let height = dynamicHeightDelgate.calculatedHeight(cell, indexPath: indexPath) {
      return height
    }
    cell.setNeedsDisplay()
    cell.layoutIfNeeded()
    let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    return size.height
  }
  
  // MARK: - Keyboard Scroll
  
  var focusOffset = CGFloat(0)
  private let tapRecognizer = UITapGestureRecognizer()
  
  // MARK: - Init & Deinit
  
  override func awakeFromNib() {
    super.awakeFromNib()
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
