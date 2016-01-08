
import UIKit

class CardResultView: UIView {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var bankLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  @IBOutlet weak var cardNumberLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateKeyLabel: UILabel!
  @IBOutlet weak var deliveryDateLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  func layoutView(paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.price.priceNotation(.Korean)
    bankLabel.text = paymentInfo.bankName
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
    cardNumberLabel.text = paymentInfo.cardNumber
    // TODO : 희망배송일 표기
  }
}
