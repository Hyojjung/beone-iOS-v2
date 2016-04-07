
import UIKit

protocol AddintionalPaymentDelegate: NSObjectProtocol {
  func paymentButtonTapped(orderId: Int, paymentInfoId: Int)
}

class AdditionalPaymentView: UIView {
  
  @IBOutlet weak var paymentNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var paymentButton: PaymentButton!
  
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
    paymentButton.setUp(paymentInfo.transactionButtonType, isOrder: false)
  }
  
  // MARK: - Public Methods

  func configureView(paymentInfo: PaymentInfo) {
    layoutView(paymentInfo)
    
    orderId = paymentInfo.orderId
    paymentInfoId = paymentInfo.id
  }
}

class PaymentButton: UIButton {
  func setUp(transactionButtonType: TransactionButtonType, isOrder: Bool) {
    let buttonString = transactionButtonType.actionButtonString(isOrder)
    setTitle(buttonString, forState: .Normal)
    setTitle(buttonString, forState: .Highlighted)
    configureAlpha(transactionButtonType != .None)
  }
}
