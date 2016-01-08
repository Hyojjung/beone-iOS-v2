
import UIKit

@objc protocol DynamicHeightTableViewProtocol: NSObjectProtocol {
  var dynamicHeightTableViewCells: [String: UITableViewCell] { get set }
  
  optional func configure(cell: UITableViewCell, indexPath: NSIndexPath, forCalculateHeight: Bool)
  func cellIdentifier(indexPath: NSIndexPath) -> String
}

class DynamicHeightTableView: UITableView {
  
  weak var dynamicHeightDelgate: DynamicHeightTableViewProtocol!
  
  // MARK: - UITableViewDynamicHeightHelper
  
  func heightForBasicCell(indexPath: NSIndexPath) -> CGFloat {
    let cellIdentifier = dynamicHeightDelgate.cellIdentifier(indexPath)
    var cell = dynamicHeightDelgate.dynamicHeightTableViewCells[cellIdentifier]
    if cell == nil {
      cell = dequeueReusableCellWithIdentifier(cellIdentifier)
      if cell == nil {
        registerNib(UINib(nibName: cellIdentifier.convertToBigCamelCase(), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        cell = dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
      }
      dynamicHeightDelgate.dynamicHeightTableViewCells[cellIdentifier] = cell
    }
    if let cell = cell {
      dynamicHeightDelgate.configure?(cell, indexPath: indexPath, forCalculateHeight: true)
      return calculateHeight(cell)
    }
    return 0
  }
  
  private func calculateHeight(cell: UITableViewCell) -> CGFloat {
    cell.setNeedsDisplay()
    cell.layoutIfNeeded()
    let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    print(size.height)
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
