
import UIKit

enum PaymentTypeId: Int {
  case ISPCard = 1
  case Mobile
  case VBank
  case Card
  case PayPal = 21
  case KakaoPay = 31
}

class PaymentType: BaseModel {
  var isAvailable = false
  var isWebViewTransaction = false
  var name: String?
  
  override func assignObject(data: AnyObject) {
    if let paymentType = data as? [String: AnyObject] {
      id = paymentType[kObjectPropertyKeyId] as? Int
      name = paymentType["name"] as? String
      if let isAvailable = paymentType["isAvailable"] as? Bool {
        self.isAvailable = isAvailable
      }
      if let isWebViewTransaction = paymentType["isWebViewTransaction"] as? Bool {
        self.isWebViewTransaction = isWebViewTransaction
      }
    }
  }
}
