
import UIKit

class OrderResultViewController: BaseViewController {

  @IBOutlet weak var resultImageView: UIImageView!
  @IBOutlet weak var resultView: UIView!
  var orderResult: [String: AnyObject]?
  var paymentInfo = PaymentInfo()
  
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
    
//    let paymentInfoView =
  }
}
