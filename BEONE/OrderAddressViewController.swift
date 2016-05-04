
import UIKit

class OrderAddressViewController: BaseViewController {
  
  let kScrollViewAdjustHeight = CGFloat(98)
  private let kInvalidAddressIndex = 4

  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var senderNameTextField: UITextField!
  @IBOutlet weak var senderPhoneTextField: UITextField!
  @IBOutlet weak var sameButton: UIButton!
  @IBOutlet weak var secretButton: UIButton!
  @IBOutlet weak var receiverNameTextField: UITextField!
  @IBOutlet weak var receiverPhoneTextField: UITextField!
  @IBOutlet weak var zonecodeTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var detailAddressTextField: UITextField!
  @IBOutlet weak var deliveryMemoTextView: UITextView!
  
  @IBOutlet weak var newAddressSelectButton: UIButton!
  @IBOutlet weak var firstAddressSelectButton: UIButton!
  @IBOutlet weak var secondAddressSelectButton: UIButton!
  @IBOutlet weak var thirdAddressSelectButton: UIButton!
  @IBOutlet weak var findAddressButton: UIButton!
  @IBOutlet weak var zipCodeTextFieldTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var newButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondButtonTrailingLayoutConstraint: NSLayoutConstraint!
  
  var order = Order()
  var address: Address?
  var addresses = Addresses()
  var selectedAddressIndex: Int?
  
  // MARK: - Init & Deinit
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let selectingPaymentTypeViewController = segue.destinationViewController as? SelectingPaymentTypeViewController {
      selectingPaymentTypeViewController.order = order
    } else if let invalidAddressViewController = segue.destinationViewController as? InvalidAddressViewController,
      orderableCartItemIds = sender as? [Int] {
        invalidAddressViewController.order = order
        invalidAddressViewController.orderableCartItemIds = orderableCartItemIds
    }
  }
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    
    self.senderNameTextField.addTarget(self, action: #selector(OrderAddressViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    self.senderPhoneTextField.addTarget(self, action: #selector(OrderAddressViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    self.receiverNameTextField.addTarget(self, action: #selector(OrderAddressViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    self.receiverPhoneTextField.addTarget(self, action: #selector(OrderAddressViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
  
  override func setUpData() {
    super.setUpData()
    if let selectedAddress = BEONEManager.selectedAddress {
      handleAddress(selectedAddress)
    } else {
      addresses.get {
        if !self.addresses.list.isEmpty {
          self.selectedAddressIndex = 0
        }
        self.handleAddresses()
        self.setUpAddressButtons()
      }
    }
    MyInfo.sharedMyInfo().get { 
      self.senderNameTextField.text = MyInfo.sharedMyInfo().name
      self.senderPhoneTextField.text = MyInfo.sharedMyInfo().phone
    }
  }
}

// MARK: - Action Methods

extension OrderAddressViewController {
  @IBAction func secretButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
  }
  
  @IBAction func sameButtonTapped(sender: UIButton) {
    setUpSameButtonSelected(!sender.selected)
  }
  
  private func setUpSameButtonSelected(selected: Bool) {
    sameButton.selected = selected
    if selected {
      setUpSenderAndReceiverView()
    }
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView(kPostCodesWebViewUrl, title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func sendAddressButtonTapped() {
    endEditing()
    if let error = errorMessage() {
      showAlertView(error)
    } else {
      setUpAddress()
      
      OrderHelper.fetchDeliverableCartItems(order.cartItemIds,
        address: order.address.addressString()!,
        addressType: order.address.addressType!,
        getSuccess: { (cartItemIds) -> Void in
          if cartItemIds.hasEqualObjects(self.order.cartItemIds) {
            self.performSegueWithIdentifier("From Order Address To Order", sender: nil)
          } else {
            self.performSegueWithIdentifier("From Order Address To Invalid Address", sender: cartItemIds)
          }
      })
    }
  }
  
  @IBAction func selectIndexButtonTapped(sender: UIButton) {
    if sender.tag == kInvalidAddressIndex {
      selectedAddressIndex = nil
    } else {
      endEditing()
      selectedAddressIndex = !sender.selected ? sender.tag : nil
    }
    handleAddresses()
  }
}

// MARK: - Observer Methods

extension OrderAddressViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    self.address = address
    setUpAddressView()
  }
}

extension OrderAddressViewController {
  
  private func handleAddresses() {
    setUpAddressButtonsSelected()

    address = addresses.list.objectAtIndex(selectedAddressIndex) as? Address
    setUpAddressView()
  }
  
  private func setUpAddress() {
    if let address = address {
      address.detailAddress = detailAddressTextField.text
      address.receiverName = receiverNameTextField.text
      address.receiverPhone = receiverPhoneTextField.text
      
      order.senderName = senderNameTextField.text
      order.senderPhone = senderPhoneTextField.text
      order.isSecret = secretButton.selected
      order.address = address
      order.deliveryMemo = deliveryMemoTextView.text
    }
  }
  
  private func setUpAddressButtons() {
    firstAddressSelectButton.configureAlpha(addresses.total > 0)
    secondAddressSelectButton.configureAlpha(addresses.total > 1)
    thirdAddressSelectButton.configureAlpha(addresses.total > 2)
    
    if addresses.total > 3 {
      addresses.total = 3
    }
    
    newButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total) * 48
    firstButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total - 1) * 48
    secondButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total - 2) * 48
  }
  
  private func setUpAddressButtonsSelected() {
    newAddressSelectButton.selected = selectedAddressIndex == nil
    firstAddressSelectButton.selected = selectedAddressIndex == 0
    secondAddressSelectButton.selected = selectedAddressIndex == 1
    thirdAddressSelectButton.selected = selectedAddressIndex == 2
    
    findAddressButton.configureAlpha(selectedAddressIndex == nil)
    zipCodeTextFieldTrailingLayoutConstraint.constant = selectedAddressIndex == nil ? 146 : 10
  }
}

// MARK: - Private Methods

extension OrderAddressViewController {
  
  func setUpAddressView() {
    if let zonecode = address?.zonecode {
      zonecodeTextField.text = zonecode
    } else if let zipcode1 = address?.zipcode01, zipcode2 = address?.zipcode02 {
      zonecodeTextField.text = "\(zipcode1) - \(zipcode2)"
    } else {
      zonecodeTextField.text = nil
    }
    
    let addressString = address?.addressString()
    if addressTextField.text != addressString {
      addressTextField.text = addressString
      detailAddressTextField.text = address?.detailAddress
    }
    
    receiverNameTextField.text = address?.receiverName
    receiverPhoneTextField.text = address?.receiverPhone
    if sameButton.selected {
      setUpSenderAndReceiverView()
    }
  }
  
  func setUpSenderAndReceiverView() {
    receiverNameTextField.text = senderNameTextField.text
    receiverPhoneTextField.text = senderPhoneTextField.text
  }
  
  func errorMessage() -> String? {
    if senderNameTextField.text == nil || senderNameTextField.text!.isEmpty {
      return NSLocalizedString("enter sender", comment: "alert")
    } else if senderPhoneTextField.text?.isValidPhoneNumber() != true {
      return NSLocalizedString("check sender phone", comment: "alert")
    } else if receiverNameTextField.text == nil || receiverNameTextField.text!.isEmpty {
      return NSLocalizedString("enter receiver", comment: "alert")
    } else if receiverPhoneTextField.text?.isValidPhoneNumber() != true {
      return NSLocalizedString("check receiver phone", comment: "alert")
    } else if address == nil {
      return NSLocalizedString("enter address", comment: "alert")
    } else if detailAddressTextField.text == nil || detailAddressTextField.text!.isEmpty {
      return NSLocalizedString("enter detail address", comment: "alert")
    }
    return nil
  }
}

// MARK: - UITextFieldDelegate

extension OrderAddressViewController {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    scrollView.focusOffset =
      textField.convertPoint(textField.frame.origin, toView: scrollView).y - kScrollViewAdjustHeight
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    if sameButton.selected && (textField == senderNameTextField || textField == senderPhoneTextField) {
      setUpSenderAndReceiverView()
    } else if sameButton.selected && textField == receiverNameTextField || textField == receiverPhoneTextField {
      setUpSameButtonSelected(false)
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == senderNameTextField {
      senderPhoneTextField.becomeFirstResponder()
    } else if textField == senderPhoneTextField {
      receiverNameTextField.becomeFirstResponder()
    } else if textField == receiverNameTextField {
      receiverPhoneTextField.becomeFirstResponder()
    } else if textField == receiverPhoneTextField {
      endEditing()
    }
    return true
  }
}

// MARK: - UITextViewDelegate

extension OrderAddressViewController {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    scrollView.focusOffset =
      textView.convertPoint(textView.frame.origin, toView: scrollView).y - kScrollViewAdjustHeight
    return true
  }
}
