
import UIKit

class VBankResultView: OrderResultView {

  @IBOutlet weak var bankLabel: UILabel!
  @IBOutlet weak var issureNameLabel: UILabel!
  @IBOutlet weak var accountLabel: UILabel!
  @IBOutlet weak var expiredAtLabel: UILabel!
  
  override func layoutView(order: Order, paymentInfo: PaymentInfo) {
    super.layoutView(order, paymentInfo: paymentInfo)
    bankLabel.text = paymentInfo.bankName
    issureNameLabel.text = paymentInfo.vbankIssuerName
    accountLabel.text = paymentInfo.account
    expiredAtLabel.text = paymentInfo.expiredAt?.dueDateDateString()
  }
}
