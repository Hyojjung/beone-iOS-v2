
import UIKit

let kRecentProductsSchemeString = "recent-products"

enum SchemeTabViewIdentifier: String {
  case Home = "home"
  case Search = "search"
  case Category = "categories"
  case Shop = "shops"
  case More = "more"
  
  func viewControllerTabIndex() -> Int {
    switch (self) {
    case .Home:
      return 0
    case .Search:
      return 1
    case .Category:
      return 2
    case .Shop:
      return 3
    case .More:
      return 4
    }
  }
}

enum SchemeIdentifier: String {
  case Profile = "profile"
  case Orders = "orders"
  case Product = "product"
  case Cart = "cart"
  case Help = "help"
  case Notice = "notice"
  case Products = "products"
  case Coupons = "coupons"
  case SpeedOrder = "speed-order"
  case Setting = "setting"
  case Option = "option"
  case Shop = "shop"
  
  func viewIdentifiers() -> (storyboardName: String, viewIdentifier: String, isForUser: Bool) {
    switch (self) {
    case .Profile:
      return (kProfileStoryboardName, kProfileViewViewIdentifier, true)
    case .Orders:
      return (kOrdersStoryboardName, kOrdersViewNibName, true)
    case .Product:
      return (kProductDetailStoryboardName, kProductDetailViewIdentifier, false)
    case .Cart:
      return ("Cart", "CartView", true)
    case .SpeedOrder:
      return ("SpeedOrder", "SpeedOrderView", true)
    case .Coupons:
      return ("Coupon", "CouponsView", true)
    case .Help:
      return ("Help", "HelpsView", false)
    case .Notice:
      return ("Notice", "NoticesView", false)
    case .Setting:
      return ("Setting", "SettingView", false)
    case .Products:
      return (kProductsStoryboardName, kProductsViewViewIdentifier, false)
    case .Shop:
      return (kShopStoryboardName, kShopViewIdentifier, false)
    case .Option:
      return (kProductDetailStoryboardName, kProductOptionViewIdentifier, true)
    }
  }
}

protocol SchemeDelegate {
  func handleScheme(with id: Int)
}

class SchemeHelper {
  
  static var schemeStrings: [String]?
  static var index = 0
  
  static func rootNavigationController() -> UINavigationController? {
    let root = UIApplication.sharedApplication().delegate?.window!!.rootViewController as? SWRevealViewController
    return root?.frontViewController as? UINavigationController
  }
  
  static func setUpScheme(scheme: String) {
    let navi = rootNavigationController()
    navi?.dismissViewControllerAnimated(false, completion: nil)
    navi?.popToRootViewControllerAnimated(false)
    
    var schemeString = scheme
    if scheme.hasPrefix(kSchemeBaseUrl) {
      schemeString = schemeString.stringByReplacingOccurrencesOfString(kSchemeBaseUrl, withString: "")
    }
    
    schemeStrings = schemeString.componentsSeparatedByString("/")
    setUpTabController()
  }
  
  static func setUpTabController() {
    let navi = rootNavigationController()
    if let mainTabViewController = navi?.topViewController as? MainTabViewController,
      mainTabViewIdentifier = schemeStrings?.first,
      mainTabScheme = SchemeTabViewIdentifier(rawValue: mainTabViewIdentifier) {
      schemeStrings?.removeAtIndex(0)
      if mainTabViewController.selectedIndex == mainTabScheme.viewControllerTabIndex() {
        if let viewController = mainTabViewController.selectedViewController as? BaseViewController {
          viewController.handleScheme()
        }
      } else {
        mainTabViewController.selectedIndex = mainTabScheme.viewControllerTabIndex()
      }
    }
  }
}

extension BaseViewController {
  
  func handleScheme() {
    if let schemeStrings = SchemeHelper.schemeStrings {
      if SchemeHelper.index < schemeStrings.count {
        let schemeString = schemeStrings[SchemeHelper.index]
        SchemeHelper.index += 1
        if let schemeIdentifier = SchemeIdentifier(rawValue: schemeString) {
          showViewController(schemeIdentifier)
        } else if let topViewController = SchemeHelper.rootNavigationController()?.topViewController {
          if let id = Int(schemeString), topViewController = topViewController as? SchemeDelegate {
            topViewController.handleScheme(with: id)
          } else if schemeString == kRecentProductsSchemeString {
            let productsViewController = UIViewController.viewController(.Products) as! ProductsViewController
            productsViewController.productList.type = .Recent
            showViewController(productsViewController, sender: nil)
          }
        }
      } else {
        SchemeHelper.schemeStrings = nil
        SchemeHelper.index = 0
      }
    }
  }
}
