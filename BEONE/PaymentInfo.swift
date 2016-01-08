
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
  
  var bankName: String?
  var issureName: String?
  var account: String?
  var paypalEmail: String?
  var cardNumber: String?
  var expiredAt: NSDate?
  var paidAt: NSDate?
  
  override func assignObject(data: AnyObject) {
    if let paymentInfo = data as? [String: AnyObject] {
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
