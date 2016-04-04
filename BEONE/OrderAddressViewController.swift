
import UIKit

class OrderAddressViewController: BaseViewController {
  
  let kScrollViewAdjustHeight = CGFloat(98)
  
  @IBOutlet weak var scrollView: KeyboardScrollView!
  @IBOutlet weak var senderNameTextField: UITextField!
  @IBOutlet weak var senderPhoneTextField: UITextField!
  @IBOutlet weak var sameButton: UIButton!
  @IBOutlet weak var secretButton: UIButton!
  @IBOutlet weak var receiverNameTextField: UITextField!
  @IBOutlet weak var receiverPhoneTextField: UITextField!
  @IBOutlet weak var zonecodeLabel: UILabel!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var detailAddressTextField: UITextField!
  @IBOutlet weak var deliveryMemoTextView: UITextView!
  
  var order = Order()
  var address = Address()
  var addresses = Addresses()
  
  // MARK: - Init & Deinit
  
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
      addresses.get { () -> Void in
        self.handleAddresses()
      }
    }
    MyInfo.sharedMyInfo().get { () -> Void in
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
    showWebView("postcodes", title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
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
}

// MARK: - Observer Methods

extension OrderAddressViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    self.address = address
    setUpAddressView()
  }
}

extension OrderAddressViewController {
  
  func handleAddresses() {
    if addresses.list.count > 0 {
      address = addresses.list.first as! Address
    }
    receiverNameTextField.text = address.receiverName
    receiverPhoneTextField.text = address.receiverPhone
    setUpAddressView()
  }
  
  func setUpAddress() {
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

// MARK: - Private Methods

extension OrderAddressViewController {
  
  func setUpAddressView() {
    if let zonecode = address.zonecode {
      zonecodeLabel.text = zonecode
    } else if let zipcode1 = address.zipcode01, zipcode2 = address.zipcode02 {
      zonecodeLabel.text = "\(zipcode1) - \(zipcode2)"
    }
    
    let addressString = address.addressString()
    if addressTextField.text != addressString {
      addressTextField.text = addressString
      detailAddressTextField.text = address.detailAddress
    }
  }
  
  func setUpSenderAndReceiverView() {
    receiverNameTextField.text = senderNameTextField.text
    receiverPhoneTextField.text = senderPhoneTextField.text
  }
  
  func errorMessage() -> String? {
    if senderNameTextField.text == nil || senderNameTextField.text!.isEmpty {
      return NSLocalizedString("enter sender", comment: "alert")
    } else if senderPhoneTextField.text == nil || senderPhoneTextField.text!.isEmpty {
      return NSLocalizedString("enter sender phone", comment: "alert")
    } else if receiverNameTextField.text == nil || receiverNameTextField.text!.isEmpty {
      return NSLocalizedString("enter receiver", comment: "alert")
    } else if receiverPhoneTextField.text == nil || receiverPhoneTextField.text!.isEmpty {
      return NSLocalizedString("enter receiver phone", comment: "alert")
    } else if addressTextField.text == nil || addressTextField.text!.isEmpty {
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
