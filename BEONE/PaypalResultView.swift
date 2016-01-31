
import UIKit

class PaypalResultView: OrderResultView {

  @IBOutlet weak var paypalEmailLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  
  override func layoutView(order: Order, paymentInfo: PaymentInfo) {
    super.layoutView(order, paymentInfo: paymentInfo)
    paypalEmailLabel.text = paymentInfo.paypalEmail
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
  }
}
