
import UIKit

class CouponList: BaseListModel {
  
  var isUsableCouponList = false
  
  override func getUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/coupons"
    }
    return "coupons"
  }
  
  override func getParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["statuses"] = isUsableCouponList ? ["usable"] : ["used", "expired"]
    return parameter
  }
  
  override func assignObject(data: AnyObject?) {
    if let coupons = data as? [[String: AnyObject]] {
      list.removeAll()
      for couponObject in coupons {
        let coupon = Coupon()
        coupon.usable = isUsableCouponList
        coupon.assignObject(couponObject)
        list.append(coupon)
      }
    }
  }
}
