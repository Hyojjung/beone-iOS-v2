
import UIKit

struct ActionSheetButton {
  let title: String
  let action: UIAlertAction -> Void
}

class ViewControllerHelper: NSObject {
  static var showingNavigationViewController: UINavigationController?
  
  static var screenWidth: CGFloat = {
    return UIScreen.mainScreen().bounds.width
  }()
  
  static func showActionSheet(viewController: UIViewController, title: String?, actionSheetButtons: [ActionSheetButton]) {
    let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
    
    for actionSheetButton in actionSheetButtons {
      let button = UIAlertAction(title: actionSheetButton.title, style: .Default, handler: actionSheetButton.action)
      actionSheet.addAction(button)
    }
    
    let cancelButton = UIAlertAction(title: "취소", style: .Cancel, handler:nil)
    actionSheet.addAction(cancelButton)
    
    viewController.presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  static func showAlertView(message: String?, hasCancel: Bool?, confirmAction: Action?, cancelAction: Action?) {
    if let topViewController = showingNavigationViewController?.topViewController, message = message {
      let alertViewController =
      AlertViewController(message: message, hasCancel: hasCancel, confirmAction: confirmAction, cancelAction: cancelAction)
      alertViewController.modalPresentationStyle = .OverCurrentContext
      alertViewController.modalTransitionStyle = .CrossDissolve
      topViewController.presentViewController(alertViewController, animated: true, completion: nil)
    }
  }
  
  static func setUpFloatingLabel(textfield: UIFloatLabelTextField, placeholder: String) {
    textfield.placeholder = placeholder;
    textfield.floatLabelActiveColor = darkGold
    textfield.tintColor = grey
  }
  
  static func showWebView(urlString: String?, title: String?) {
    if let urlString = urlString, showingNavigationViewController = showingNavigationViewController {
      let webViewController = WebViewController()
      webViewController.url = urlString
      webViewController.title = title
      showingNavigationViewController.pushViewController(webViewController, animated: true)
    }
  }
}

extension UIView {
  static func loadFromNibName(nibName: String?, bundle : NSBundle? = nil) -> UIView? {
    if let nibName = nibName {
      return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    return nil
  }
}