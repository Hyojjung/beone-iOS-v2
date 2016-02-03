
import UIKit

class OrderResultView: UIView {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  func layoutView(order: Order, paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.actualPrice.priceNotation(.Korean)
    deliveryDateLabel.text = order.deliveryDateString()
  }
}

class EtcResultView: OrderResultView {
  
}
