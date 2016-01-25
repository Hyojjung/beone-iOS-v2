
import UIKit

enum CurrencyType: String {
  case KRW = "KRW"
  case USD = "USD"
}

class PaymentInfo: BaseModel {
  var price = 0
  var currencyType = CurrencyType.KRW
  var isMainPayment = false
  var paymentStatus: String?
  var title: String?
  var orderId: Int?
  
  var bankName: String?
  var issureName: String?
  var account: String?
  var paypalEmail: String?
  var cardNumber: String?
  var expiredAt: NSDate?
  var paidAt: NSDate?
  
  var paymentType = PaymentType()
  
  override func fetchUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)"
  }
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      let paymentInfoObejct = data[kNetworkResponseKeyData] != nil ? data[kNetworkResponseKeyData] : data
      if let paymentInfo = paymentInfoObejct as? [String: AnyObject] {
        if let paymentType = paymentInfo["paymentType"] as? [String: AnyObject] {
          self.paymentType.assignObject(paymentType)
        }
        id = paymentInfo[kObjectPropertyKeyId] as? Int
        
        if let price = paymentInfo["actualPrice"] as? Int {
          self.price = price
        }
        if let currencyTypeString = paymentInfo["currencyType"] as? String,
          currencyType = CurrencyType(rawValue: currencyTypeString) {
            self.currencyType = currencyType
        }
        if let isMainPayment = paymentInfo["isMainPayment"] as? Bool {
          self.isMainPayment = isMainPayment
        }
        
        paymentStatus = paymentInfo["paymentStatus"] as? String
        title = paymentInfo["title"] as? String
      }
    }
  }
}
