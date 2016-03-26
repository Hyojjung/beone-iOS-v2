
import UIKit
import ActionSheetPicker_3_0

struct ActionSheetButton {
  let title: String
  let action: UIAlertAction -> Void
}

class ViewControllerHelper: NSObject {
  
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
  
  static func topViewController() -> UIViewController? {
    if let revealViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? SWRevealViewController,
    navigationViewController = revealViewController.frontViewController as? UINavigationController {
     return navigationViewController.topViewController
    }
    return nil
  }
}

extension UIView {
  static func loadFromNibName(nibName: String?, bundle : NSBundle? = nil) -> UIView? {
    if let nibName = nibName {
      return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil).first as? UIView
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
      let webViewController = WebViewController()
      webViewController.url = urlString
      webViewController.title = title
      webViewController.addressDelegate = addressDelegate
      navigationController?.showViewController(webViewController, sender: nil)
      navigationController?.navigationBar.hidden = false
    }
  }
  
  func showLocationPicker(selectedLocation: Location? = BEONEManager.selectedLocation, doneBlock: (Int) -> Void) {
    var initialSelection = 0
    for (index, location) in (BEONEManager.sharedLocationList.list as! [Location]).enumerate() {
      if location == selectedLocation {
        initialSelection = index
      }
    }
    showActionSheet(NSLocalizedString("select location", comment: "picker title"),
      rows: BEONEManager.sharedLocationList.locationNames(),
      initialSelection: initialSelection,
      doneBlock: { (_, selectedIndex, _) -> Void in
        doneBlock(selectedIndex)
    })
  }
  
  func showSigningView() {
    presentViewController(kSigningStoryboardName, viewIdentifier: kSigningNavigationViewIdentifier)
  }
  
  func showOrderView(orderingCartItemIds: [Int]) {
    if let deliveryDateViewController = UIViewController.viewController(kOrderStoryboardName, viewIdentifier: kDeliveryDateViewViewIdentifier) as? DeliveryDateViewController {
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
  
  static func viewController(schemeIdentifier: SchemeIdentifier) -> UIViewController {
    let viewIdentifiers = schemeIdentifier.viewIdentifiers()
    return viewController(viewIdentifiers.storyboardName, viewIdentifier: viewIdentifiers.viewIdentifier)
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
      sender?.selected = true
      let selectedIndex = initialSelection == nil ? 0 : initialSelection
      let actionSheet =
      ActionSheetStringPicker(title: title,
        rows: rows,
        initialSelection: selectedIndex!,
        doneBlock: { (actionSheet, selectedIndex, selectedString) -> Void in
          doneBlock?(actionSheet, selectedIndex, selectedString)
          sender?.selected = false
        }, cancelBlock: {(actionSheet) -> Void in
          cancelBlock?(actionSheet)
          sender?.selected = false
        }, origin: view)
      
      actionSheet.showActionSheetPicker()
  }
  
  func showPayment(paymentTypes: [PaymentType]?, order: Order, paymentInfoId: Int) {
    if let paymentTypes = paymentTypes {
      var actionSheetButtons = [ActionSheetButton]()
      for paymentType in paymentTypes {
        let paymentTypeButton = ActionSheetButton(title: paymentType.name!)
          {(_) -> Void in
            if paymentType.id == PaymentTypeId.Card.rawValue {
              self.showBillKeysView(order, paymentInfoId: paymentInfoId)
            } else {
              self.showOrderWebView(order, paymentTypeId: paymentType.id!, paymentInfoId: paymentInfoId)
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
    let orderResultViewController = OrderResultViewController()
    orderResultViewController.order = order
    orderResultViewController.paymentInfoId = paymentInfoId
    orderResultViewController.orderResult = orderResult
    navigationController?.showViewController(orderResultViewController, sender: nil)
  }
  
  func showOrderWebView(order: Order, paymentTypeId: Int, paymentInfoId: Int? = nil) {
    let orderWebViewController = OrderWebViewController()
    orderWebViewController.order = order
    orderWebViewController.paymentInfoId = paymentInfoId
    orderWebViewController.paymentTypeId = paymentTypeId
    navigationController?.showViewController(orderWebViewController, sender: nil)
  }
  
  func showShopView(shopId: Int?) {
    let shopViewController = UIViewController.viewController(.Shop) as! ShopViewController
    shopViewController.shop.id = shopId
    showViewController(shopViewController, sender: nil)
  }
}