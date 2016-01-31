
import UIKit

class MobileResultView: OrderResultView {
  
  @IBOutlet weak var paidAtLabel: UILabel!
  
  override func layoutView(order: Order, paymentInfo: PaymentInfo) {
    super.layoutView(order, paymentInfo: paymentInfo)
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
  }
}
