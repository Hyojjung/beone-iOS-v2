
import UIKit
import ActionSheetPicker_3_0

struct ActionSheetButton {
  let title: String
  let action: UIAlertAction -> Void
}

class ViewControllerHelper: NSObject {
  
  static var networkErrorViewController: NetworkErrorViewController = {
    let networkErrorViewController = NetworkErrorViewController(nibName: "NetworkErrorViewController", bundle: nil)
    networkErrorViewController.modalPresentationStyle = .OverCurrentContext
    networkErrorViewController.modalTransitionStyle = .CrossDissolve
    return networkErrorViewController
  }()
  
  static var screenWidth: CGFloat = {
    return UIScreen.mainScreen().bounds.width
  }()
  
  static var screenHeight: CGFloat = {
    return UIScreen.mainScreen().bounds.height
  }()
  
  static func heightFromRatio(template: Template?, imageSize: CGSize?) -> CGFloat? {
    if let imageSize = imageSize, template = template {
      let width = ViewControllerHelper.screenWidth -
        (template.style.margin.left + template.style.margin.right +
          template.style.padding.left + template.style.padding.right)
      return imageSize.height / imageSize.width * width
    }
    return nil
  }
  
  static func topRootViewController() -> UIViewController? {
    if var topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
      while topViewController.presentedViewController != nil {
        topViewController = topViewController.presentedViewController!
      }
      if let topRootViewController = topViewController as? SWRevealViewController,
        rootNavigationViewController = topRootViewController.frontViewController as? UINavigationController {
        return rootNavigationViewController
      } else if let topRootViewController = topViewController as? UINavigationController {
        return topRootViewController.topViewController
      }
      return topViewController
    }
    return nil
  }
  
  static func topMostViewController() -> UIViewController? {
    if let topRootViewController = topRootViewController() {
      if let topRootViewController = topRootViewController as? UINavigationController {
        if let mainTabViewController = topRootViewController.topViewController as? MainTabViewController {
          return mainTabViewController.viewControllers?.objectAtIndex(mainTabViewController.selectingIndex)
        }
        return topRootViewController.topViewController
      }
      return topRootViewController
    }
    return nil
  }
  
  static func showNetworkErrorViewController() {
    if !networkErrorViewController.showing {
      if let topRootViewController = ViewControllerHelper.topRootViewController() {
        networkErrorViewController.showing = true
        networkErrorViewController.networkError = true
        topRootViewController.presentViewController(networkErrorViewController, animated: true, completion: nil)
      }
    }
  }
  
  static func showServerCheckViewController() {
    if !networkErrorViewController.showing {
      if let topRootViewController = ViewControllerHelper.topRootViewController() {
        networkErrorViewController.showing = true
        networkErrorViewController.networkError = false
        topRootViewController.presentViewController(networkErrorViewController, animated: true, completion: nil)
      }
    }
  }
}

extension UIView {
  static func loadFromNibName(nibName: String?, bundle : NSBundle? = nil) -> UIView? {
    if let nibName = nibName {
      return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil).first as? UIView
    }
    return nil
  }
  
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
  
  func showAlertView(message: String?, hasCancel: Bool? = false, confirmAction: Action? = nil, cancelAction: Action? = nil, delegate: AnyObject? = nil) {
    if let message = message {
      let alertViewController =
        AlertViewController(message: message, hasCancel: hasCancel, confirmAction: confirmAction, cancelAction: cancelAction, actionDelegate: delegate)
      alertViewController.modalPresentationStyle = .OverCurrentContext
      alertViewController.modalTransitionStyle = .CrossDissolve
      presentViewController(alertViewController, animated: true, completion: nil)
    }
  }
  
  func showWebView(urlString: String?, title: String?, addressDelegate: AddressDelegate? = nil) {
    if let urlString = urlString {
      let webViewController = WebViewController(nibName: "WebViewController", bundle: nil)
      webViewController.url = urlString
      webViewController.title = title
      webViewController.addressDelegate = addressDelegate
      navigationController?.showViewController(webViewController, sender: nil)
      navigationController?.navigationBar.hidden = false
    }
  }
  
  func showLocationPicker(selectedLocation: Location? = BEONEManager.selectedLocation, doneBlock: (Int) -> Void) {
    var initialSelection = 0
    for (index, location) in (BEONEManager.sharedLocations.list as! [Location]).enumerate() {
      if location == selectedLocation {
        initialSelection = index
      }
    }
    showActionSheet(NSLocalizedString("select location", comment: "picker title"),
                    rows: BEONEManager.sharedLocations.locationNames(),
                    initialSelection: initialSelection,
                    doneBlock: { (_, selectedIndex, _) -> Void in
                      doneBlock(selectedIndex)
    })
  }
  
  func showSigningView() {
    presentViewController(kSigningStoryboardName, viewIdentifier: kSigningNavigationViewIdentifier)
  }
  
  func showOrderView(orderingCartItemIds: [Int]) {
    if let deliveryDateViewController = UIViewController.viewController(kOrderStoryboardName, viewIdentifier: kDeliveryDateViewIdentifier) as? DeliveryDateViewController {
      deliveryDateViewController.order.cartItemIds = orderingCartItemIds
      navigationController?.showViewController(deliveryDateViewController, sender: nil)
    }
  }
  
  func showProductView(productId: Int?) {
    if let productDetailViewController =
      UIViewController.viewController(kProductDetailStoryboardName, viewIdentifier: kProductDetailViewIdentifier) as? ProductDetailViewController,
      productId = productId {
      productDetailViewController.product.id = productId
      showViewController(productDetailViewController, sender: nil)
    }
  }
}

extension UIViewController {
  func presentViewController(storyboardName: String?, viewIdentifier: String?) {
    if let storyboardName = storyboardName, viewIdentifier = viewIdentifier {
      presentViewController(UIViewController.viewController(storyboardName, viewIdentifier: viewIdentifier),
                            animated: true, completion: nil)
    }
  }
  
  static func viewController(storyboardName: String, viewIdentifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier(viewIdentifier)
  }
  
  static func viewController(schemeIdentifier: SchemeIdentifier) -> UIViewController? {
    if let viewIdentifiers = schemeIdentifier.viewIdentifiers() {
      return viewController(viewIdentifiers.storyboardName, viewIdentifier: viewIdentifiers.viewIdentifier)
    }
    return nil
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
  func showActionSheet(title: String,
                       rows: [String],
                       initialSelection: Int?,
                       sender: UIButton? = nil,
                       doneBlock: ActionStringDoneBlock? = nil,
                       cancelBlock: ActionStringCancelBlock? = nil) {
    view.endEditing(true)
    sender?.selected = true
    let selectedIndex = initialSelection == nil ? 0 : initialSelection
    let actionSheet =
      ActionSheetStringPicker(title: title,
                              rows: rows,
                              initialSelection: selectedIndex!,
                              doneBlock: { (actionSheet, selectedIndex, selectedString) -> Void in
                                doneBlock?(actionSheet, selectedIndex, selectedString)
        }, cancelBlock: {(actionSheet) -> Void in
          cancelBlock?(actionSheet)
        }, origin: view)
    
    actionSheet.showActionSheetPicker()
  }
  
  func showPayment(paymentTypes: [PaymentType]?, order: Order, paymentInfoId: Int,
                   paymentBaseViewController: UIViewController? = nil) {
    if let paymentTypes = paymentTypes {
      var actionSheetButtons = [ActionSheetButton]()
      for paymentType in paymentTypes {
        let paymentTypeButton = ActionSheetButton(title: paymentType.name!)
        {(_) -> Void in
          var viewController = self
          if let paymentBaseViewController = paymentBaseViewController {
            viewController = paymentBaseViewController
            self.revealViewController().revealToggleAnimated(true)
          }
          if paymentType.id == PaymentTypeId.Card.rawValue {
            viewController.showBillKeysView(order, paymentInfoId: paymentInfoId)
          } else {
            viewController.showOrderWebView(order,
                                            paymentTypeId: paymentType.id!,
                                            paymentTypeName: paymentType.name,
                                            paymentInfoId: paymentInfoId)
          }
        }
        actionSheetButtons.appendObject(paymentTypeButton)
      }
      showActionSheet(actionSheetButtons)
    }
  }
  
  func showBillKeysView(order: Order, paymentInfoId: Int) {
    if let billKeysViewController = UIViewController.viewController("Order", viewIdentifier: "BillKeysView") as? BillKeysViewController {
      billKeysViewController.order = order
      billKeysViewController.paymentInfoId = paymentInfoId
      navigationController?.showViewController(billKeysViewController, sender: nil)
    }
  }
  
  func showOrderResultView(order: Order? = nil, paymentInfoId: Int? = nil, orderResult: [String: AnyObject]? = nil) {
    let orderResultViewController = OrderResultViewController(nibName: "OrderResultViewController", bundle: nil)
    orderResultViewController.order = order
    orderResultViewController.paymentInfoId = paymentInfoId
    orderResultViewController.orderResult = orderResult
    navigationController?.showViewController(orderResultViewController, sender: nil)
  }
  
  func showOrderWebView(order: Order, paymentTypeId: Int, paymentTypeName: String?, paymentInfoId: Int? = nil) {
    let orderWebViewController = OrderWebViewController(nibName: "OrderWebViewController", bundle: nil)
    orderWebViewController.title = paymentTypeName
    orderWebViewController.order = order
    orderWebViewController.paymentInfoId = paymentInfoId
    orderWebViewController.paymentTypeId = paymentTypeId
    navigationController?.showViewController(orderWebViewController, sender: nil)
  }
  
  func showShopView(shopId: Int?) {
    if let shopId = shopId {
      let shopViewController = UIViewController.viewController(.Shop) as! ShopViewController
      shopViewController.shop.id = shopId
      showViewController(shopViewController, sender: nil)
    }
  }
}