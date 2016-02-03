
import UIKit

class CardResultView: OrderResultView {
  
  @IBOutlet weak var bankLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  @IBOutlet weak var cardNumberLabel: UILabel!
  
  override func layoutView(order: Order, paymentInfo: PaymentInfo) {
    super.layoutView(order, paymentInfo: paymentInfo)
    bankLabel.text = paymentInfo.cardName
    paidAtLabel.text = paymentInfo.paidAt?.paidAtDateString()
    cardNumberLabel.text = paymentInfo.cardNumber
  }
}
