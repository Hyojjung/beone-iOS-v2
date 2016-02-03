
import UIKit

class PaymentInfoList: BaseListModel {
  
  var mainPaymentInfo: PaymentInfo?

  override func assignObject(data: AnyObject) {
    if let paymentInfoObjects = data as? [[String: AnyObject]] {
      list.removeAll()
      for paymentInfoObject in paymentInfoObjects {
        let paymentInfo = PaymentInfo()
        paymentInfo.assignObject(paymentInfoObject)
        list.append(paymentInfo)
        if paymentInfo.isMainPayment {
          mainPaymentInfo = paymentInfo
        }
      }
    }
  }
}
