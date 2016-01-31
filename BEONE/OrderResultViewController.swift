
import UIKit

class OrderResultViewController: BaseViewController {
  
  @IBOutlet weak var resultImageView: UIImageView!
  @IBOutlet weak var resultView: UIView!
  var orderResult: [String: AnyObject]?
  var paymentInfo: PaymentInfo?
  var order = Order() {
    didSet {
      if let isSuccess = orderResult?["isSuccess"] as? String {
        if isSuccess == "true" {
          CartItemManager.removeCartItem(order.cartItemIds)
        }
      }
    }
  }
  lazy var orderResultView: OrderResultLabelView = {
    let resultLabelView = UIView.loadFromNibName("OrderResultLabelView") as! OrderResultLabelView
    return resultLabelView
  }()
  
  override func setUpData() {
    super.setUpData()
    self.configureSuccessResultView()
  }
  
  @IBAction func closeViewButtonTapped(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(false)
  }
  
  func configureSuccessResultView() {
    if let paymentInfo = paymentInfo {
      resultView.subviews.forEach { $0.removeFromSuperview() }
      let paymentInfoViewNibName: String
      if let paymentTypeId = PaymentTypeId(rawValue: paymentInfo.paymentType.id!) {
        switch (paymentTypeId) {
        case .ISPCard, .Card:
          paymentInfoViewNibName = "CardResultView"
        case .Mobile:
          paymentInfoViewNibName = "MobileResultView"
        case .VBank:
          paymentInfoViewNibName = "VBankResultView"
        case .PayPal:
          paymentInfoViewNibName = "PaypalResultView"
        case .KakaoPay:
          paymentInfoViewNibName = "EtcResultView"
        }
      } else {
        paymentInfoViewNibName = "EtcResultView"
      }
      if let resultInfoView = UIView.loadFromNibName(paymentInfoViewNibName) as? OrderResultView {
        resultInfoView.layoutView(order, paymentInfo: paymentInfo)
        resultView.addSubViewAndEnableAutoLayout(resultInfoView)
        resultView.addTopLayout(resultInfoView)
        resultView.addLeadingLayout(resultInfoView)
        resultView.addTrailingLayout(resultInfoView)
        
        configureResultLabel()
        resultView.addSubViewAndEnableAutoLayout(orderResultView)
        resultView.addBottomLayout(orderResultView)
        resultView.addLeadingLayout(orderResultView)
        resultView.addTrailingLayout(orderResultView)
        
        resultView.addVerticalLayout(resultInfoView, bottomView: orderResultView, contsant: 8)
      }
    }
  }
  
  private func configureResultLabel() {
    if let isSuccess = orderResult?["isSuccess"] as? String {
      orderResultView.orderResultLabel.text = nil
      if isSuccess == "true" {
        if PaymentTypeId.VBank.rawValue == paymentInfo?.paymentType.id {
          orderResultView.orderResultLabel.text = NSLocalizedString("pay message", comment: "result label")
        }
      } else {
        orderResultView.orderResultLabel.text = NSLocalizedString("order cancel", comment: "result label")
      }
    }
  }
}
