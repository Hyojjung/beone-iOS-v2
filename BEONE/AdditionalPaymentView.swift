
import UIKit

protocol AddintionalPaymentDelegate: NSObjectProtocol {
  func paymentButtonTapped(orderId: Int, paymentInfoId: Int)
}

class AdditionalPaymentView: UIView {
  
  @IBOutlet weak var paymentNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var paymentButton: UIButton!
  
  weak var addintionalPaymentDelegate: AddintionalPaymentDelegate?

  var orderId: Int?
  var paymentInfoId: Int?
  
  // MARK: - Actions
  
  @IBAction func paymentButtonTapped() {
    if let orderId = orderId, paymentInfoId = paymentInfoId {
      addintionalPaymentDelegate?.paymentButtonTapped(orderId, paymentInfoId: paymentInfoId)
    }
  }
  
  // MARK: - Private Methods

  private func layoutView(paymentInfo: PaymentInfo) {
    paymentNameLabel.text = paymentInfo.title
    priceLabel.text = paymentInfo.actualPrice.priceNotation(.Korean)
    
    let buttonString = paymentInfo.actionButtonString()
    paymentButton.setTitle(buttonString, forState: .Normal)
    paymentButton.setTitle(buttonString, forState: .Highlighted)
    paymentButton.configureAlpha(buttonString != nil)
  }
  
  // MARK: - Public Methods

  func configureView(paymentInfo: PaymentInfo) {
    layoutView(paymentInfo)
    
    orderId = paymentInfo.orderId
    paymentInfoId = paymentInfo.id
  }
}
