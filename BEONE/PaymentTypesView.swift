
import UIKit

let kPaymentTypeButtonHeight = CGFloat(50)
let kPaymentTypeButtonInterval = CGFloat(7)

protocol PaymentTypesViewDelegate: NSObjectProtocol {
  func selectPaymentTypeButtonTapped(paymentTypeId: Int)
}

class PaymentTypesView: UIView {
  
  weak var delegate: PaymentTypesViewDelegate?
  
  func layoutView(paymentTypes: [PaymentType], selectedPaymentTypeId: Int?) {
    var previousView: UIView?
    for (index, paymentType) in paymentTypes.enumerate() {
      let paymentTypeView = self.paymentTypeView(paymentType, isSelected: paymentType.id == selectedPaymentTypeId)
      addSubViewAndEnableAutoLayout(paymentTypeView)
      addLeadingLayout(paymentTypeView)
      addTrailingLayout(paymentTypeView)
      if let previousView = previousView {
        addVerticalLayout(previousView, bottomView: paymentTypeView, contsant: kPaymentTypeButtonInterval)
      } else {
        addTopLayout(paymentTypeView)
      }
      
      previousView = paymentTypeView
      
      if index == paymentTypes.count - 1 {
        addBottomLayout(paymentTypeView)
      }
    }
  }
  
  func selectPaymentTypeViewTapped(sender: UIButton) {
    if let paymentTypeView = sender.superview as? PaymentTypeView {
      paymentTypeView.isSelected = !paymentTypeView.isSelected
      delegate?.selectPaymentTypeButtonTapped(sender.tag)
    }
  }
  
  func paymentTypeView(paymentType: PaymentType, isSelected: Bool) -> PaymentTypeView {
    let paymentTypeView = PaymentTypeView()
    paymentTypeView.layoutView()
    paymentTypeView.isSelected = isSelected
    paymentTypeView.paymentTypeButton.tag = paymentType.id!
    paymentTypeView.paymentTypeButton.setTitle(paymentType.name, forState: .Normal)
    paymentTypeView.paymentTypeButton.addTarget(self, action: #selector(PaymentTypesView.selectPaymentTypeViewTapped(_:)),
      forControlEvents: .TouchUpInside)
    paymentTypeView.alertLabel.text = paymentType.alert
    return paymentTypeView
  }
}

class PaymentTypeView: UIView {
  
  private lazy var checkedImageView: UIImageView = {
    let checkedImageView = UIImageView()
    checkedImageView.highlightedImage = UIImage(named: "iconButtonChecked")
    return checkedImageView
  }()
  lazy var alertLabel: UILabel = {
    let alertLabel = UILabel()
    alertLabel.font = UIFont.systemFontOfSize(12)
    alertLabel.textColor = pinkishGrey
    alertLabel.numberOfLines = 0
    alertLabel.preferredMaxLayoutWidth = ViewControllerHelper.screenWidth - 30
    alertLabel.textAlignment = .Center
    return alertLabel
  }()
  lazy var paymentTypeButton: UIButton = {
    let paymentTypeButton = UIButton()
    paymentTypeButton.setBackgroundImage(UIImage(named: "btnGoldStroke"), forState: .Normal)
    paymentTypeButton.setBackgroundImage(UIImage(named: "btnGoldStrokePressed"), forState: .Selected)
    paymentTypeButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
    paymentTypeButton.setTitleColor(pinkishGrey, forState: .Normal)
    return paymentTypeButton
  }()
  
  var isSelected = false {
    didSet {
      paymentTypeButton.selected = isSelected
      checkedImageView.highlighted = isSelected
    }
  }
  
  func layoutView() {
    addSubViewAndEnableAutoLayout(paymentTypeButton)
    paymentTypeButton.addHeightLayout(kPaymentTypeButtonHeight)
    addTopLayout(paymentTypeButton)
    addLeadingLayout(paymentTypeButton)
    addTrailingLayout(paymentTypeButton)
    
    addSubViewAndEnableAutoLayout(checkedImageView)
    addTopLayout(checkedImageView, constant: 15)
    addLeadingLayout(checkedImageView, constant: 27)
    
    addSubViewAndEnableAutoLayout(alertLabel)
    addVerticalLayout(paymentTypeButton, bottomView: alertLabel, contsant: 4)
    addLeadingLayout(alertLabel)
    addTrailingLayout(alertLabel)
    addBottomLayout(alertLabel)
  }
}
