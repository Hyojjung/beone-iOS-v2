
import UIKit

class Coupon: BaseModel {
  
  private let kCouponPropertyKeySerialNumber = "serialNumber"
  
  var title: String?
  var subTitle: String?
  var expiredAt: NSDate?
  var serialNumber: String?
  var desc: String?
  var dayLeft: String?
  var usable = false
  
  override func postUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/coupons"
    } else {
      return "coupons"
    }
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter[kCouponPropertyKeySerialNumber] = serialNumber
    return parameter
  }
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject], prototype = data["prototype"] as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      title = prototype["title"] as? String
      subTitle = prototype["subtitle"] as? String
      serialNumber = prototype[kCouponPropertyKeySerialNumber] as? String
      desc = prototype[kObjectPropertyKeyDescription] as? String
      if let expiredAt = data["expiredAt"] as? String {
        self.expiredAt = expiredAt.date()
        dayLeft = dayLeftFromToday()
      }
    }
  }
  
  func dayLeftFromToday() -> String? {
    if let expiredAt = expiredAt {
      let date = NSDate()
      if date.compare(expiredAt) == NSComparisonResult.OrderedDescending {
        return NSLocalizedString("expired", comment: "day left desctiption")
      } else if !usable {
        return NSLocalizedString("used", comment: "day left desctiption")
      } else {
        let dayPassed = date.numberOfLeftDay(to: expiredAt)
        if dayPassed == 0 {
          return NSLocalizedString("expired today", comment: "day left desctiption")
        } else {
          return "(\(dayPassed)" + NSLocalizedString("day left", comment: "day left desctiption")
        }
      }
    }
    return nil
  }
}
