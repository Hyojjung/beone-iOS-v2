
import UIKit

enum CurrencyType: String {
  case KRW = "KRW"
  case USD = "USD"
}

enum PaymentStatus: String {
  case Waiting = "waiting"
  case Success = "success"
}

class PaymentInfo: BaseModel {
  var price = 0
  var currencyType = CurrencyType.KRW
  var isMainPayment = false
  var isPaid = false
  var title: String?
  var orderId: Int?
  
  var bankName: String?
  var vbankIssuerName: String?
  var account: String?
  var paypalEmail: String?
  var cardNumber: String?
  var expiredAt: NSDate?
  var paidAt: NSDate?
  var paymentStatus = PaymentStatus.Success
  
  var paymentType = PaymentType()
  var billKeyInfoId: Int?
  var paypalPaymentId: Int?
  
  override func fetchUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)"
  }
  
  override func assignObject(data: AnyObject) {
    if let paymentInfo = data as? [String: AnyObject] {
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
      if let paidAt = paymentInfo["paidAt"] as? String {
        self.paidAt = paidAt.date()
      }
      if let expiredAt = paymentInfo["vbankExpiredAt"] as? String {
        self.expiredAt = expiredAt.date()
      }
      vbankIssuerName = paymentInfo["vbankIssuerName"] as? String
      bankName = paymentInfo["vbankIssuerBankName"] as? String
      account = paymentInfo["vbankIssuerAccount"] as? String
      if let isMainPayment = paymentInfo["isMainPayment"] as? Bool {
        self.isMainPayment = isMainPayment
      }
      if let status = paymentInfo["status"] as? String,
        paymentStatus = PaymentStatus(rawValue: status) {
        self.paymentStatus = paymentStatus
      }
      
      title = paymentInfo["title"] as? String
      orderId = paymentInfo["orderId"] as? Int
    }
  }
  
  override func postUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)/transactions"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["paymentTypeId"] = paymentType.id
    parameter["billKeyInfoId"] = billKeyInfoId
    parameter["paypalPaymentId"] = paypalPaymentId
    return parameter
  }
}
