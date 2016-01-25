
import UIKit

class OrderResultViewController: BaseViewController {

  @IBOutlet weak var resultImageView: UIImageView!
  @IBOutlet weak var resultView: UIView!
  var orderingCartItemIds: [Int]?
  var orderResult: [String: AnyObject]?
  var paymentInfo = PaymentInfo() {
    didSet {
      if let isSuccess = orderResult?["isSuccess"] as? Bool {
        if isSuccess {
          CartItemManager.removeCartItem(orderingCartItemIds!)
          
        } else {
          
        }
      }
    }
  }
  
  override func setUpData() {
    super.setUpData()
    paymentInfo.id = Int(orderResult?["paymentInfoId"] as! String)
    paymentInfo.orderId = orderResult?["orderId"] as? Int
    paymentInfo.get { () -> Void in
      self.configureResultView()
    }
  }
  
  func configureResultView() {
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
      resultInfoView.layoutView(paymentInfo)
      resultView.addSubViewAndEdgeLayout(resultInfoView)
    }
  }
}
