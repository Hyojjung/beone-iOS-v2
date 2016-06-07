
import UIKit

class AddressesViewController: BaseViewController {

  private let kMaxAddressCount = 3
  
  private let addresses = Addresses()
  private var selectedAddressIndex: Int? = nil
  private var selectedAddress: Address? = nil
  private var newAddress = Address()
  
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var firstButton: UIButton!
  @IBOutlet weak var secondButton: UIButton!
  @IBOutlet weak var thirdButton: UIButton!
  @IBOutlet weak var newButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondButtonTrailingLayoutConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var receiverNameTextField: UITextField!
  @IBOutlet weak var receiverPhoneTextField: UITextField!
  @IBOutlet weak var zipCodeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var detailAddressTextField: UITextField!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func setUpData() {
    super.setUpData()
    addresses.get {
      self.addresses.recentAddress()
      if self.addresses.total >= self.kMaxAddressCount {
        self.selectedAddressIndex = 0
      }
      if self.selectedAddressIndex == nil {
        self.selectedAddress = self.newAddress
      } else {
        self.selectedAddress = self.addresses.list.objectAtIndex(self.selectedAddressIndex) as? Address
      }
      self.setUpButtonViewLayout()
      self.setUpAddressView()
    }
  }
  
  @IBAction func addressIndexButtonTapped(sender: UIButton) {
    selectedAddressIndex = sender.tag
    selectedAddress = addresses.list.objectAtIndex(selectedAddressIndex) as? Address
    setUpAddressView()
  }
  
  @IBAction func newAddressButtonTapped() {
    selectedAddressIndex = nil
    selectedAddress = newAddress
    setUpAddressView()
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    selectedAddress?.receiverName = receiverNameTextField.text
    selectedAddress?.receiverPhone = receiverPhoneTextField.text
    showWebView(kPostCodesWebViewUrl, title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func sendAddressButtonTapped() {
    if receiverNameTextField.text == nil || receiverNameTextField.text?.isEmpty == true {
      showAlertView("받으시는 분 성함을 다시 한번 확인 해 주세요.")
      return
    } else if receiverPhoneTextField.text?.isValidPhoneNumber() != true {
      showAlertView("받으시는 분 연락처를 다시 한번 확인 해 주세요.")
      return
    } else if zipCodeLabel.text == nil || addressLabel.text == nil || detailAddressTextField.text == nil {
      showAlertView("주소를 입력 해 주세요.")
      return
    }
    
    selectedAddress?.receiverName = receiverNameTextField.text
    selectedAddress?.receiverPhone = receiverPhoneTextField.text
    selectedAddress?.detailAddress = detailAddressTextField.text
    
    if selectedAddress == newAddress {
      selectedAddress?.post({ (_) in
        self.newAddress = Address()
        self.setUpData()
        }, postFailure: nil)
    } else {
      selectedAddress?.put({ (_) in
        self.setUpData()
        }, putFailure: nil)
    }
  }
  
  private func setUpButtonViewLayout() {
    newButton.configureAlpha(addresses.total < kMaxAddressCount)
    firstButton.configureAlpha(addresses.total > 0)
    secondButton.configureAlpha(addresses.total > 1)
    thirdButton.configureAlpha(addresses.total > 2)
    newButtonTrailingLayoutConstraint.constant = CGFloat(addresses.total) * 50 + 14
    firstButtonTrailingLayoutConstraint.constant = CGFloat(addresses.total - 1) * 50 + 14
    secondButtonTrailingLayoutConstraint.constant = CGFloat(addresses.total - 2) * 50 + 14
  }
  
  private func setUpButtonsSelected() {
    newButton.selected = selectedAddressIndex == nil
    firstButton.selected = selectedAddressIndex == 0
    secondButton.selected = selectedAddressIndex == 1
    thirdButton.selected = selectedAddressIndex == 2
    
    let buttonTitle = selectedAddressIndex == nil ? "저장" : "수정"
    sendButton.setTitle(buttonTitle, forState: .Normal)
    sendButton.setTitle(buttonTitle, forState: .Highlighted)
  }
  
  private func setUpAddressView() {
    setUpButtonsSelected()
    receiverNameTextField.text = selectedAddress?.receiverName
    receiverPhoneTextField.text = selectedAddress?.receiverPhone
    zipCodeLabel.text = selectedAddress?.zipCode()
    addressLabel.text = selectedAddress?.addressString()
    detailAddressTextField.text = selectedAddress?.detailAddress
  }
}

extension AddressesViewController: AddressDelegate {
  func handleAddress(address: Address) {
    selectedAddress?.zipcode01 = address.zipcode01
    selectedAddress?.zipcode02 = address.zipcode02
    selectedAddress?.zonecode = address.zonecode
    selectedAddress?.roadAddress = address.roadAddress
    selectedAddress?.jibunAddress = address.jibunAddress
    selectedAddress?.detailAddress = address.detailAddress
    selectedAddress?.addressType = address.addressType
    
    setUpAddressView()
  }
}
