
import UIKit

let kRecentProductsSchemeString = "recent-products"
let kFavoriteProductsSchemeString = "favorite-products"

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
  case Order = "order"
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
  case AppView = "app-views"
  
  func viewIdentifiers() -> (storyboardName: String, viewIdentifier: String, isForUser: Bool)? {
    switch (self) {
    case .Profile:
      return (kProfileStoryboardName, kProfileViewIdentifier, true)
    case .Orders:
      return (kOrdersStoryboardName, kOrdersViewIdentifier, true)
    case .Order:
      return (kOrdersStoryboardName, kOrderDetailViewIdentifier, true)
    case .Product:
      return (kProductDetailStoryboardName, kProductDetailViewIdentifier, false)
    case .Cart:
      return ("Cart", "CartView", true)
    case .SpeedOrder:
      return ("SpeedOrder", "SpeedOrderView", false)
    case .Coupons:
      return ("Coupon", "CouponsView", true)
    case .Help:
      return ("Help", "HelpsView", false)
    case .Notice:
      return ("Notice", "NoticesView", false)
    case .Setting:
      return ("Setting", "SettingView", false)
    case .Products:
      return (kProductsStoryboardName, kProductsViewIdentifier, false)
    case .Shop:
      return (kShopStoryboardName, kShopViewIdentifier, false)
    case .Option:
      return (kProductDetailStoryboardName, kProductOptionViewIdentifier, true)
    default:
      return nil
    }
  }
}

protocol SchemeDelegate {
  func handleScheme(with id: Int)
}

class SchemeHelper {
  
  static var schemeStrings = [String]()
  
  static func setUpScheme(scheme: String) {
    let navi = ViewControllerHelper.topRootViewController() as? UINavigationController
    navi?.dismissViewControllerAnimated(false, completion: nil)
    
    var schemeString = scheme
    if scheme.hasPrefix(kSchemeBaseUrl) {
      schemeString = schemeString.stringByReplacingOccurrencesOfString(kSchemeBaseUrl, withString: kEmptyString)
    }
    schemeStrings = schemeString.componentsSeparatedByString("/")
    
    if schemeString.hasPrefix("current") {
      schemeStrings.removeAtIndex(0)
      handleScheme()
    } else {
      setUpTabController()
    }
  }
  
  static func setUpTabController() {
    if let root = UIApplication.sharedApplication().keyWindow?.rootViewController as? SWRevealViewController,
      navi = root.frontViewController as? UINavigationController {
      navi.popToRootViewControllerAnimated(false)
      root.dismissViewControllerAnimated(false, completion: nil)
      root.setFrontViewPosition(.Left, animated: false)
      if let mainTabViewController = navi.topViewController as? MainTabViewController,
        mainTabViewIdentifier = schemeStrings.first,
        mainTabScheme = SchemeTabViewIdentifier(rawValue: mainTabViewIdentifier) {
        schemeStrings.removeAtIndex(0)
        if mainTabViewController.selectedIndex != mainTabScheme.viewControllerTabIndex() {
          mainTabViewController.selectedIndex = mainTabScheme.viewControllerTabIndex()
        } else {
          handleScheme()
        }
      }
    }
  }
  
  static func handleScheme() {
    if let topMostViewController = ViewControllerHelper.topMostViewController() as? BaseViewController {
      topMostViewController.handleScheme()
    }
  }
}

extension BaseViewController {
  func handleScheme() {
    if let schemeString = SchemeHelper.schemeStrings.first {
      if let schemeIdentifier = SchemeIdentifier(rawValue: schemeString) {
        if schemeString == SchemeIdentifier.AppView.rawValue {
          let viewController = TemplatesViewController(nibName: "TemplatesViewController", bundle: nil)
          viewController.templates.type = .AppView
          showViewController(viewController, sender: nil)
        } else {
          showViewController(schemeIdentifier)
        }
      } else if let topViewController = ViewControllerHelper.topMostViewController() {
        if let id = Int(schemeString), topViewController = topViewController as? SchemeDelegate {
          topViewController.handleScheme(with: id)
        } else if schemeString == kRecentProductsSchemeString {
          let productsViewController = UIViewController.viewController(.Products) as! ProductsViewController
          productsViewController.title = "최근 본 상품"
          productsViewController.products.type = .Recent
          showViewController(productsViewController, sender: nil)
        } else if schemeString == kFavoriteProductsSchemeString  {
          let productsViewController = UIViewController.viewController(.Products) as! ProductsViewController
          productsViewController.title = "찜한 상품"
          productsViewController.products.type = .Favorite
          showUserViewController(productsViewController)
        }
      }
      if !SchemeHelper.schemeStrings.isEmpty {
        SchemeHelper.schemeStrings.removeAtIndex(0)
      }
    }
  }
}
