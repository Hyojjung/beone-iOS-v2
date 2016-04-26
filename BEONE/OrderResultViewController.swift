
import UIKit

enum OrderStatus: String {
  case Success
  case Canceled = "canceled"
  case Failure = "failure"
}

let kOrderResultKeyStatus = "status"
let kOrderResultKeyMessage = "message"

class OrderResultViewController: BaseViewController {
  
  @IBOutlet weak var resultImageView: UIImageView!
  @IBOutlet weak var resultView: UIView!
  
  private var paymentInfo: PaymentInfo?
  
  var paymentInfoId: Int?
  var order: Order?
  var status = OrderStatus.Success
  var orderResult: [String: AnyObject]? {
    didSet {
      if let orderStatus = orderResult?[kOrderResultKeyStatus] as? String, status = OrderStatus(rawValue: orderStatus) {
        self.status = status
      } else if let isSuccess = orderResult?["isSuccess"] as? String {
        if isSuccess == "false" {
          self.status = .Failure
        }
      }
    }
  }
  lazy var orderResultView: OrderResultLabelView = {
    let resultLabelView = UIView.loadFromNibName(kOrderResultLabelViewNibName) as! OrderResultLabelView
    return resultLabelView
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = true
    navigationController?.interactivePopGestureRecognizer?.enabled = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.hidden = false
    navigationController?.interactivePopGestureRecognizer?.enabled = true
  }
  
  override func setUpData() {
    super.setUpData()
    if status == .Canceled || status == .Failure {
      configureFailureResultView()
    } else if let order = order {
      order.isDone = true
      order.get { 
        self.paymentInfo = order.paymentInfos.model(self.paymentInfoId) as? PaymentInfo
        if self.paymentInfo?.isSuccess == true {
          CartItemManager.removeCartItem(order.cartItemIds)
          self.configureSuccessResultView()
        }
      }
    }
  }
  
  @IBAction func closeViewButtonTapped() {
    if status == .Success {
      // rootView까지 갔다가 주문 목록 보여줌.
      let navigation = navigationController;
      navigation?.popToRootViewControllerAnimated(false)
      let ordersViewController = UIViewController.viewController(.Orders)
      navigation?.pushViewController(ordersViewController!, animated: true)
      
    } else {
      popView()
    }
  }
}

// MARK: - Private Methods

extension OrderResultViewController {
  
  private func configureSuccessResultView() {
    if let paymentInfo = paymentInfo {
      resultImageView.image = UIImage(named: kImagePaymentSuccessImageName)
      resultView.subviews.forEach { $0.removeFromSuperview() }
      if let paymentInfoViewNibName = paymentInfoViewNibName(),
        resultInfoView = UIView.loadFromNibName(paymentInfoViewNibName) as? OrderResultView {
          resultInfoView.layoutView(order!, paymentInfo: paymentInfo)
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
  
  private func configureFailureResultView() {
    configureResultLabel()
    resultView.addSubViewAndCenterLayout(orderResultView)
  }
  
  private func configureResultLabel() {
    orderResultView.orderResultLabel.text = nil
    if status == .Canceled {
      resultImageView.image = UIImage(named: kImagePaymentCancelImageName)
      orderResultView.orderResultLabel.text = NSLocalizedString("order cancel", comment: "result label")
    } else if paymentInfo?.isSuccess == true {
      if PaymentTypeId.VBank.rawValue == paymentInfo?.paymentType.id {
        orderResultView.orderResultLabel.text = NSLocalizedString("pay message", comment: "result label")
      }
    } else {
      resultImageView.image = UIImage(named: kImagePaymentFailImageName)
      var failureMessage = String()
      if let orderResult = orderResult, message = orderResult[kOrderResultKeyMessage] as? String {
        failureMessage += message
        failureMessage += " "
      }
      failureMessage += NSLocalizedString("order failure", comment: "result label")
      orderResultView.orderResultLabel.text = failureMessage
    }
  }
  
  private func paymentInfoViewNibName() -> String? {
    if let paymentInfo = paymentInfo {
      if let paymentTypeId = PaymentTypeId(rawValue: paymentInfo.paymentType.id!) {
        switch (paymentTypeId) {
        case .ISPCard, .Card:
          return kCardResultViewNibName
        case .Mobile:
          return kMobileResultViewNibName
        case .VBank:
          return kVBankResultViewNibName
        case .PayPal:
          return kPaypalResultViewNibName
        case .KakaoPay:
          return kOrderResultViewNibName
        }
      } else {
        return kOrderResultViewNibName
      }
    }
    return nil
  }
}
