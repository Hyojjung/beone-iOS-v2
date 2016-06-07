
import UIKit

class SpeedOrderAddressViewController: BaseViewController {
  
  // MARK: - Constant
  
  private let kInvalidAddressIndex = 4
  
  private enum SpeedOrderAddressTableViewSection: Int {
    case Top
    case Address
    case Count
  }
  
  private let kSpeedOrderAddressTableViewCellIdentifiers = [
    "topCell",
    "addressCell"]
  
  weak var addressDelegate: AddressDelegate?
  var newAddress =  Address()
  var addresses = Addresses()
  var selectedIndex: Int? {
    didSet {
      setUpAddress()
    }
  }
  
  @IBOutlet weak var zipCodeTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var detailAddressTextField: UITextField!
  
  @IBOutlet weak var findAddressButton: UIButton!
  
  @IBOutlet weak var newAddressSelectButton: UIButton!
  @IBOutlet weak var firstAddressSelectButton: UIButton!
  @IBOutlet weak var secondAddressSelectButton: UIButton!
  @IBOutlet weak var thirdAddressSelectButton: UIButton!
  
  @IBOutlet weak var zipCodeTextFieldTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var newButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondButtonTrailingLayoutConstraint: NSLayoutConstraint!
  
  // MARK: - Init & Deinit
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func setUpView() {
    super.setUpView()
    setUpButtonsLayout()
    setUpAddressView()
  }
  
  override func setUpData() {
    super.setUpData()
    addresses.get {
      if let recentAddress = self.addresses.recentAddress() {
        self.newAddress = recentAddress
      }
      self.setUpButtonsLayout()
      self.setUpAddressView()
    }
  }
  
  @IBAction func selectIndexButtonTapped(sender: UIButton) {
    if sender.tag == kInvalidAddressIndex {
      selectedIndex = nil
    } else {
      endEditing()
      selectedIndex = sender.tag
    }
    setUpAddressView()
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView(kPostCodesWebViewUrl, title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func selectAddressButtonTapped() {
    endEditing()
    if selectedAddress().addressString() != nil && selectedAddress().detailAddress != nil {
      addressDelegate?.handleAddress(selectedAddress())
      popView()
    } else {
      showAlertView("주소를 입력해주세요.")
    }
  }
  
  private func selectedAddress() -> Address {
    let address: Address
    if let selectedIndex = selectedIndex {
      address = addresses.list.objectAtIndex(selectedIndex) as! Address
    } else {
      address = newAddress
    }
    return address
  }
  
  func setUpButtonsLayout() {
    firstAddressSelectButton.configureAlpha(addresses.total > 0)
    secondAddressSelectButton.configureAlpha(addresses.total > 1)
    thirdAddressSelectButton.configureAlpha(addresses.total > 2)
    
    newButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addresses.total) * 48
    firstButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addresses.total - 1) * 48
    secondButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addresses.total - 2) * 48
  }
  
  func setUpAddress() {
    let address = selectedAddress()
    zipCodeTextField.text = address.zipCode()
    addressTextField.text = address.addressString()
    detailAddressTextField.text = address.detailAddress
  }
  
  func setUpAddressView() {
    newAddressSelectButton.selected = selectedIndex == nil
    firstAddressSelectButton.selected = selectedIndex == 0
    secondAddressSelectButton.selected = selectedIndex == 1
    thirdAddressSelectButton.selected = selectedIndex == 2
    
    findAddressButton.configureAlpha(selectedIndex == nil)
    zipCodeTextFieldTrailingLayoutConstraint.constant = selectedIndex == nil ? 144 : 8
    
    setUpAddress()
  }
}

extension SpeedOrderAddressViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    let address = selectedAddress()
    address.detailAddress = textField.text
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if selectedIndex == nil {
      zipCodeTextField.background = UIImage(named: kInputImageName)
      addressTextField.background = UIImage(named: kInputImageName)
      textField.background = UIImage(named: kInputActiveImageName)
      return true
    }
    return false
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    endEditing()
    return true
  }
}

extension SpeedOrderAddressViewController: AddressDelegate {
  func handleAddress(address: Address) {
    newAddress = address
    zipCodeTextField.background = UIImage(named: kInputActiveImageName)
    addressTextField.background = UIImage(named: kInputActiveImageName)
    detailAddressTextField.background = UIImage(named: kInputImageName)
    setUpAddress()
  }
}