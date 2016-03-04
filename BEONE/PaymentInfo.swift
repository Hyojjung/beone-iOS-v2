
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
  
  var actualPrice = 0
  var currencyType = CurrencyType.KRW
  
  var isCancellable = false
  var isPayable = false
  var isMainPayment = false
  var isSuccess = false
  
  var title: String?
  var orderId: Int?
  var paymentType = PaymentType()
  
  var vbankIssuerName: String?
  var vbankIssuerAccount: String?
  var vbankIssuerBankName: String?
  var vbankExpiredAt: NSDate?
  
  var cardNumber: String?
  var cardName: String?
  
  var paypalEmail: String?

  var paidAt: NSDate?
  var paymentStatus = PaymentStatus.Success
  
  var billKeyInfoId: Int?
  
  override func getUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)"
  }
  
  override func assignObject(data: AnyObject?) {
    if let paymentInfo = data as? [String: AnyObject] {
      id = paymentInfo[kObjectPropertyKeyId] as? Int
      
      if let actualPrice = paymentInfo["actualPrice"] as? Int {
        self.actualPrice = actualPrice
      }
      if let currencyTypeString = paymentInfo["currencyType"] as? String,
        currencyType = CurrencyType(rawValue: currencyTypeString) {
          self.currencyType = currencyType
      }
      
      if let isMainPayment = paymentInfo["isMainPayment"] as? Bool {
        self.isMainPayment = isMainPayment
      }
      if let isCancellable = paymentInfo["isCancellable"] as? Bool {
        self.isCancellable = isCancellable
      }
      if let isPayable = paymentInfo["isPayable"] as? Bool {
        self.isPayable = isPayable
      }
      if let isSuccess = paymentInfo["isSuccess"] as? Bool {
        self.isSuccess = isSuccess
      }
      title = paymentInfo["title"] as? String
      paypalEmail = paymentInfo["payerEmail"] as? String
      orderId = paymentInfo["orderId"] as? Int
      
      paymentType.assignObject(paymentInfo["paymentType"])
      vbankIssuerName = paymentInfo["vbankIssuerName"] as? String
      vbankIssuerBankName = paymentInfo["vbankIssuerBankName"] as? String
      vbankIssuerAccount = paymentInfo["vbankIssuerAccount"] as? String
      if let vbankExpiredAt = paymentInfo["vbankExpiredAt"] as? String {
        self.vbankExpiredAt = vbankExpiredAt.date()
      }
      
      cardNumber = paymentInfo["cardNumber"] as? String
      cardName = paymentInfo["cardName"] as? String
      
      if let paidAt = paymentInfo["paidAt"] as? String {
        self.paidAt = paidAt.date()
      }
      
      if let status = paymentInfo["status"] as? String,
        paymentStatus = PaymentStatus(rawValue: status) {
          self.paymentStatus = paymentStatus
      }
      
    }
  }
  
  override func postUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)/transactions"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["paymentTypeId"] = paymentType.id
    parameter["billKeyInfoId"] = billKeyInfoId
    return parameter
  }
  
  override func putUrl() -> String {
    return "users/\(MyInfo.sharedMyInfo().userId!)/orders/\(orderId!)/payment-infos/\(id!)/transactions"
  }
}
