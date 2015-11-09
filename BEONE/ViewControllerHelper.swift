
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
  
  static var screenHeight: CGFloat = {
    return UIScreen.mainScreen().bounds.height
  }()
  
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
      showingNavigationViewController.navigationBar.hidden = false
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
  
  func showAlertView(message: String?, hasCancel: Bool?, confirmAction: Action?, cancelAction: Action?) {
    if let message = message {
      let alertViewController = AlertViewController(message: message, hasCancel: hasCancel, confirmAction: confirmAction, cancelAction: cancelAction)
      alertViewController.modalPresentationStyle = .OverCurrentContext
      alertViewController.modalTransitionStyle = .CrossDissolve
      presentViewController(alertViewController, animated: true, completion: nil)
    }
  }
}