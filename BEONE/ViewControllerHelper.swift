
import UIKit
import ActionSheetPicker_3_0

struct ActionSheetButton {
  let title: String
  let action: UIAlertAction -> Void
}

class ViewControllerHelper: NSObject {
  static var showingNavigationViewController: UINavigationController?
  
  static var screenWidth: CGFloat = {
    return UIScreen.mainScreen().bounds.width
  }()
  
  static var screenHeight: CGFloat = {
    return UIScreen.mainScreen().bounds.height
  }()
}

extension UIView {
  static func loadFromNibName(nibName: String?, bundle : NSBundle? = nil) -> UIView? {
    if let nibName = nibName {
      return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    return nil
  }
}

extension UIImageView {
  func makeCircleView() {
    layer.masksToBounds = false
    layer.borderColor = UIColor.whiteColor().CGColor
    layer.cornerRadius = frame.size.width / 2
    clipsToBounds = true
  }
}

extension UIViewController {
  func showActionSheet(actionSheetButtons: [ActionSheetButton]) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    for actionSheetButton in actionSheetButtons {
      let button = UIAlertAction(title: actionSheetButton.title, style: .Default, handler: actionSheetButton.action)
      actionSheet.addAction(button)
    }
    
    let cancelButton = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .Cancel, handler:nil)
    actionSheet.addAction(cancelButton)
    
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  func showAlertView(message: String?) {
    if let message = message {
      showAlertView(message, hasCancel: false, confirmAction: nil, cancelAction: nil, delegate: nil)
    }
  }
  
  func showAlertView(message: String?, hasCancel: Bool?, confirmAction: Action?, cancelAction: Action?, delegate: AnyObject?) {
    if let message = message {
      let alertViewController =
      AlertViewController(message: message, hasCancel: hasCancel, confirmAction: confirmAction, cancelAction: cancelAction, actionDelegate: delegate)
      alertViewController.modalPresentationStyle = .OverCurrentContext
      alertViewController.modalTransitionStyle = .CrossDissolve
      presentViewController(alertViewController, animated: true, completion: nil)
    }
  }
  
  func showWebView(urlString: String?, title: String?) {
    if let urlString = urlString {
      let webViewController = WebViewController()
      webViewController.url = urlString
      webViewController.title = title
      navigationController?.pushViewController(webViewController, animated: true)
      navigationController?.navigationBar.hidden = false
    }
  }
  
  func showSigningView() {
    presentViewController(kSigningStoryboardName, viewIdentifier: kSigningNavigationViewIdentifier)
  }
  
  func showOrderView(orderingCartItems: [CartItem]) {
    if let deliveryDateViewController = viewController(kOrderStoryboardName, viewIdentifier: kDeliveryDateViewViewIdentifier) as? DeliveryDateViewController {
      for orderingCartItem in orderingCartItems {
        if let id = orderingCartItem.id {
          deliveryDateViewController.orderingCartItemIds.append(id)
        }
      }
      showViewController(deliveryDateViewController, sender: nil)
    }
  }
  
  func showProductView() {
    showViewController(kProductDetailStoryboardName, viewIdentifier: kProductDetailViewIdentifier)
  }
  
  func showOptionView(selectedProduct: Product, selectedCartItem: CartItem? = nil, rightOrdering: Bool = false) {
    BEONEManager.selectedProduct = selectedProduct
    BEONEManager.selectedCartItem = selectedCartItem
    BEONEManager.rightOrdering = rightOrdering
    showViewController(kProductDetailStoryboardName, viewIdentifier: kProductOptionViewIdentifier)
  }
}

extension UIViewController {
  func presentViewController(storyboardName: String?, viewIdentifier: String?) {
    if let storyboardName = storyboardName, viewIdentifier = viewIdentifier {
      presentViewController(viewController(storyboardName, viewIdentifier: viewIdentifier),
        animated: true, completion: nil)
    }
  }
  
  func showViewController(storyboardName: String?, viewIdentifier: String?) {
    if let storyboardName = storyboardName, viewIdentifier = viewIdentifier {
      showViewController(viewController(storyboardName, viewIdentifier: viewIdentifier), sender: nil)
    }
  }
  
  func viewController(storyboardName: String, viewIdentifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier(viewIdentifier)
  }
}

extension UIFloatLabelTextField {
  func setUpFloatingLabel(placeholder: String) {
    self.placeholder = placeholder;
    floatLabelActiveColor = darkGold
    tintColor = grey
  }
}

extension UIViewController {
  func popView() {
    navigationController?.popViewControllerAnimated(true)
  }
}

extension UIViewController {
  func showActionSheet(title: String, rows: [String], initialSelection: Int = 0, sender: UIButton? = nil,
    doneBlock: ActionStringDoneBlock? = nil, cancelBlock: ActionStringCancelBlock? = nil) {
      sender?.selected = true
      let actionSheet =
      ActionSheetStringPicker(title: title,
        rows: rows,
        initialSelection: initialSelection,
        doneBlock: { (actionSheet, selectedIndex, selectedString) -> Void in
          doneBlock?(actionSheet, selectedIndex, selectedString)
          sender?.selected = false
        }, cancelBlock: {(actionSheet) -> Void in
          cancelBlock?(actionSheet)
          sender?.selected = false
        }, origin: view)
      actionSheet.showActionSheetPicker()
  }
}