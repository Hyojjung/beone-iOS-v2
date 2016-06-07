
import UIKit
import Mixpanel

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
  @IBOutlet weak var deliveryMemoTextView: BeoneTextView1!
  
  @IBOutlet weak var newAddressSelectButton: UIButton!
  @IBOutlet weak var firstAddressSelectButton: UIButton!
  @IBOutlet weak var secondAddressSelectButton: UIButton!
  @IBOutlet weak var thirdAddressSelectButton: UIButton!
  @IBOutlet weak var findAddressButton: UIButton!
  @IBOutlet weak var saveAddressButton: UIButton!
  @IBOutlet weak var saveAddressLabel: UILabel!
  @IBOutlet weak var zipCodeTextFieldTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var newButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondButtonTrailingLayoutConstraint: NSLayoutConstraint!
  
  var order = Order()
  var newAddress = Address()
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
    addresses.get {
      if let recentAddress = self.addresses.recentAddress() {
        self.newAddress = recentAddress
      }
      if let selectedAddress = BEONEManager.selectedAddress {
        if let addressId = selectedAddress.id, index = self.addresses.indexOfModel(with: addressId) {
          // if selected address is from stored addresses
          self.selectedAddressIndex = index
        } else {
          self.newAddress = selectedAddress
        }
      } else if !self.addresses.list.isEmpty && self.newAddress.addressType == nil {
        self.selectedAddressIndex = 0
      }
      self.setUpAddressButtons()
      self.setUpAddressViewWithSelectedAddress()
    }
    MyInfo.sharedMyInfo().get {
      self.senderNameTextField.text = MyInfo.sharedMyInfo().name
      self.senderPhoneTextField.text = MyInfo.sharedMyInfo().phone
    }
  }
}

// MARK: - Action Methods

extension OrderAddressViewController {
  @IBAction func toggleButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
  }
  
  @IBAction func sameButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    if sender.selected {
      if selectedAddressIndex != nil {
        selectedAddressIndex = nil
        setUpAddressViewWithSelectedAddress()
      }
      receiverNameTextField.background = UIImage(named: kInputActiveImageName)
      receiverPhoneTextField.background = UIImage(named: kInputActiveImageName)
    }
    setUpViewWithIsSame(sender.selected)
  }

  @IBAction func segueToAddressViewButtonTapped() {
    endEditing()
    showWebView(kPostCodesWebViewUrl, title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func sendAddressButtonTapped() {
    endEditing()
    makeAllInputsDefaultBackground()
    if let error = errorMessage() {
      showAlertView(error)
    } else {
      setUpAddress()
      
      var properties = [String: AnyObject]()
      properties[kMixpanelKeyAddress] = selectedAddress().addressString()
      Mixpanel.sharedInstance().people.set(properties)
      
      OrderHelper.fetchDeliverableCartItems(order.cartItemIds,
                                            address: order.address.addressString()!,
                                            addressType: order.address.addressType!,
                                            getSuccess: { (cartItemIds) -> Void in
                                              if cartItemIds.hasEqualObjects(self.order.cartItemIds) {
                                                if self.saveAddressButton.selected && self.selectedAddressIndex == nil {
                                                  self.newAddress.post()
                                                }
                                                self.performSegueWithIdentifier("From Order Address To Order", sender: nil)
                                              } else {
                                                self.performSegueWithIdentifier("From Order Address To Invalid Address", sender: cartItemIds)
                                              }
      })
    }
  }
  
  @IBAction func selectIndexButtonTapped(sender: UIButton) {
    endEditing()
    if sender.tag == kInvalidAddressIndex {
      selectedAddressIndex = nil
    } else {
      selectedAddressIndex = sender.tag
      sameButton.selected = false
    }
    setUpAddressViewWithSelectedAddress()
  }
}

// MARK: - Observer Methods

extension OrderAddressViewController: AddressDelegate {
  func handleAddress(address: Address) {
    newAddress = address
    newAddress.receiverName = receiverNameTextField.text
    newAddress.receiverPhone = receiverPhoneTextField.text
    setUpAddressViewWithSelectedAddress()
    
    let inputActiveImage = UIImage(named: kInputActiveImageName)
    zonecodeTextField.background = inputActiveImage
    addressTextField.background = inputActiveImage
  }
}

extension OrderAddressViewController {
  private func setUpAddress() {
    let address = selectedAddress()
    address.detailAddress = detailAddressTextField.text
    address.receiverName = receiverNameTextField.text
    address.receiverPhone = receiverPhoneTextField.text
    
    order.senderName = senderNameTextField.text
    order.senderPhone = senderPhoneTextField.text
    order.isSecret = secretButton.selected
    order.address = address
    order.deliveryMemo = deliveryMemoTextView.text
  }
  
  private func setUpAddressButtons() {
    firstAddressSelectButton.configureAlpha(addresses.total > 0)
    secondAddressSelectButton.configureAlpha(addresses.total > 1)
    thirdAddressSelectButton.configureAlpha(addresses.total > 2)
    
    if addresses.total > 3 {
      addresses.total = 3
    }
    
    newButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total) * 46
    firstButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total - 1) * 46
    secondButtonTrailingLayoutConstraint.constant = 10 + CGFloat(addresses.total - 2) * 46
  }
  
  private func setUpAddressButtonsSelected() {
    newAddressSelectButton.selected = selectedAddressIndex == nil
    firstAddressSelectButton.selected = selectedAddressIndex == 0
    secondAddressSelectButton.selected = selectedAddressIndex == 1
    thirdAddressSelectButton.selected = selectedAddressIndex == 2
    
    findAddressButton.configureAlpha(selectedAddressIndex == nil)
    zipCodeTextFieldTrailingLayoutConstraint.constant = selectedAddressIndex == nil ? 146 : 10
    saveAddressButton.configureAlpha(selectedAddressIndex == nil)
    saveAddressLabel.configureAlpha(selectedAddressIndex == nil)
  }
  
  private func makeAllInputsDefaultBackground() {
    let inputImage = UIImage(named: kInputImageName)
    senderNameTextField.background = inputImage
    senderPhoneTextField.background = inputImage
    receiverNameTextField.background = inputImage
    receiverPhoneTextField.background = inputImage
    zonecodeTextField.background = inputImage
    addressTextField.background = inputImage
    detailAddressTextField.background = inputImage
    deliveryMemoTextView.isHighlighted = false
  }
}

// MARK: - Private Methods

extension OrderAddressViewController {
  private func selectedAddress() -> Address {
    if let selectedAddressIndex = selectedAddressIndex {
      return addresses.list.objectAtIndex(selectedAddressIndex) as! Address
    }
    return newAddress
  }
  
  private func setUpViewWithIsSame(selected: Bool) {
    sameButton.selected = selected
    if selected {
      setUpSenderAndReceiverView()
    }
  }
  
  func setUpAddressViewWithSelectedAddress() {
    setUpAddressButtonsSelected()
    makeAllInputsDefaultBackground()
    let address = selectedAddress()
    
    zonecodeTextField.text = address.zipCode()
    let addressString = address.addressString()
    if addressTextField.text != addressString {
      addressTextField.text = addressString
      detailAddressTextField.text = address.detailAddress
    }
    receiverNameTextField.text = address.receiverName
    receiverPhoneTextField.text = address.receiverPhone
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
    } else if addressTextField.text == nil || addressTextField.text!.isEmpty {
      return NSLocalizedString("enter address", comment: "alert")
    } else if detailAddressTextField.text == nil || detailAddressTextField.text!.isEmpty {
      return NSLocalizedString("enter detail address", comment: "alert")
    }
    return nil
  }
}

// MARK: - UITextFieldDelegate

extension OrderAddressViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if selectedAddressIndex == nil || textField == senderNameTextField || textField == senderPhoneTextField {
      makeAllInputsDefaultBackground()
      textField.background = UIImage(named: kInputActiveImageName)
      scrollView.focusOffset =
        textField.convertPoint(textField.frame.origin, toView: scrollView).y - kScrollViewAdjustHeight
      return true
    }
    return false
  }
  
  func textFieldDidChange(textField: UITextField) {
    if sameButton.selected && (textField == senderNameTextField || textField == senderPhoneTextField) {
      setUpSenderAndReceiverView()
    } else if sameButton.selected && textField == receiverNameTextField || textField == receiverPhoneTextField {
      setUpViewWithIsSame(false)
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
    if let textView = textView as? BeoneTextView1 {
      makeAllInputsDefaultBackground()
      textView.isHighlighted = true
    }
    scrollView.focusOffset =
      textView.convertPoint(textView.frame.origin, toView: scrollView).y - kScrollViewAdjustHeight
    return true
  }
}
