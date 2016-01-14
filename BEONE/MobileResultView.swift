
import UIKit

class MobileResultView: UIView {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateKeyLabel: UILabel!
  @IBOutlet weak var deliveryDateLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  func layoutView(paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.price.priceNotation(.Korean)
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
    // TODO : 희망배송일 표기
  }
}