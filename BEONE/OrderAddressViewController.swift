
import UIKit

class OrderAddressViewController: BaseViewController {
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
  var addressList = AddressList()
  
  // MARK: - Init & Deinit

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addViewObservers()
  }
  
  deinit {
    removeViewObservers()
  }
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "", name: kNotificationFetchMyInfoSuccess, object: nil)
  }
  
  override func setUpView() {
    super.setUpView()
    
    addressList.fetch()
    MyInfo.sharedMyInfo().fetch()
    
    self.senderNameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    self.senderPhoneTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    self.receiverNameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    self.receiverPhoneTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  override func removeObservers() {
    super.removeObservers()
    addViewObservers()
  }
}

// MARK: - Action Methods

extension OrderAddressViewController {
  @IBAction func secretButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
  }
  
  @IBAction func sameButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    setUpSenderAndReceiverView()
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView("postcodes", title: NSLocalizedString("order view title", comment: "view title"))
  }
  
  @IBAction func sendAddressButtonTapped() {
    view.endEditing(true)
    if let error = errorMessage() {
      showAlertView(error)
    } else {
      address.detailAddress = detailAddressTextField.text
      
      order.senderName = senderNameTextField.text
      order.senderPhone = senderPhoneTextField.text
      order.isSecret = secretButton.selected
      order.address = address
      order.deliveryMemo = deliveryMemoTextView.text
    }
  }
}

// MARK: - Observer Methods

extension OrderAddressViewController {
  func handleAddress(notification: NSNotification) {
    if let userInfo = notification.userInfo, addressUrl = userInfo[kNotificationKeyAddress] {
      var address = addressUrl.componentsSeparatedByString("?").last
      address = address?.stringByRemovingPercentEncoding
      address = address?.stringByReplacingOccurrencesOfString("+", withString: " ")
      var addressComponentsDictionary = [String: String]()
      if let addressComponents = address?.componentsSeparatedByString("&") {
        for addressComponent in addressComponents {
          let component = addressComponent.componentsSeparatedByString("=")
          if let first = component.first {
            addressComponentsDictionary[first] = component.last
          }
        }
        self.address.assignObject(addressComponentsDictionary)
        setUpAddressView()
      }
    }
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
    
    var addressString = address.addressType == .Jibun ? address.jibunAddress : address.roadAddress
    if let buildingName = address.buildingName, address = addressString {
      addressString = "\(address) (\(buildingName))"
    }
    if addressTextField.text != addressString {
      addressTextField.text = addressString
      detailAddressTextField.text = nil
    }
  }
  
  func addViewObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAddress:",
      name: kNotificationAddressSelected, object: nil)
  }
  
  func removeViewObservers() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func setUpSenderAndReceiverView() {
    receiverNameTextField.text = senderNameTextField.text
    receiverPhoneTextField.text = senderPhoneTextField.text
  }
  
  func setUpSenderWithMyInfo() {
    senderNameTextField.text = MyInfo.sharedMyInfo().name
    senderPhoneTextField.text = MyInfo.sharedMyInfo().phone
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
    scrollView.focusOffset = textField.convertPoint(textField.frame.origin, toView: scrollView).y - 98
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    if sameButton.selected && textField == senderNameTextField || textField == senderPhoneTextField {
      setUpSenderAndReceiverView()
    } else if sameButton.selected && textField == receiverNameTextField || textField == receiverPhoneTextField {
      sameButtonTapped(sameButton)
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
      view.endEditing(true)
    }
    return true
  }
}

// MARK: - UITextViewDelegate

extension OrderAddressViewController {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    scrollView.focusOffset = textView.convertPoint(textView.frame.origin, toView: scrollView).y - 98
    return true
  }
}
