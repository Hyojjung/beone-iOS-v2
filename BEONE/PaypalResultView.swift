
import UIKit

class PaypalResultView: OrderResultView {

  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var paypalEmailLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateKeyLabel: UILabel!
  @IBOutlet weak var deliveryDateLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  override func layoutView(paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.price.priceNotation(.Korean)
    paypalEmailLabel.text = paymentInfo.paypalEmail
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
    // TODO : 희망배송일 표기
  }
}
