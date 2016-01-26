
import UIKit

class Coupon: BaseModel {
  
  private let kCouponPropertyKeySerialNumber = "serialNumber"
  
  var title: String?
  var subTitle: String?
  var expiredAt: NSDate?
  var serialNumber: String?
  var summary: String?
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
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject], prototype = data["prototype"] as? [String: AnyObject] {
      print(data)
      id = data[kObjectPropertyKeyId] as? Int
      title = prototype["title"] as? String
      subTitle = prototype["subtitle"] as? String
      serialNumber = prototype[kCouponPropertyKeySerialNumber] as? String
      summary = prototype["description"] as? String
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
        if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
          let dateComponents = calendar.components([.Day, .Hour], fromDate: date, toDate: expiredAt, options: [])
          let earlyDate = calendar.dateByAddingUnit([.Hour],
            value: dateComponents.hour,
            toDate: date,
            options: [])
          if earlyDate?.briefDateString() != date.briefDateString() {
            return "(\(dateComponents.day + 1)" + NSLocalizedString("day left", comment: "day left desctiption")
          } else if dateComponents.day == 0 {
            return NSLocalizedString("expired today", comment: "day left desctiption")
          } else {
            return "(\(dateComponents.day)" + NSLocalizedString("day left", comment: "day left desctiption")
          }
        }
      }
    }
    return nil
  }
  
}
