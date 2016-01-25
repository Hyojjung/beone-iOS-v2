
import UIKit

class OrderResultView: UIView {
  func layoutView(paymentInfo: PaymentInfo) {
  }
}

class EtcResultView: OrderResultView {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var deliveryDateKeyLabel: UILabel!
  @IBOutlet weak var deliveryDateLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  override func layoutView(paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.price.priceNotation(.Korean)
    // TODO : 희망배송일 표기
  }
}
