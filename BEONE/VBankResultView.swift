
import UIKit

class VBankResultView: UIView {

  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var bankLabel: UILabel!
  @IBOutlet weak var issureNameLabel: UILabel!
  @IBOutlet weak var accountLabel: UILabel!
  @IBOutlet weak var expiredAtLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateKeyLabel: UILabel!
  @IBOutlet weak var deliveryDateLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  func layoutView(paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.price.priceNotation(.Korean)
    bankLabel.text = paymentInfo.bankName
    issureNameLabel.text = paymentInfo.issureName
    accountLabel.text = paymentInfo.account
    expiredAtLabel.text = paymentInfo.expiredAt?.dueDateDateString()
    // TODO : 희망배송일 표기
  }
}
