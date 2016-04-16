
import UIKit

class SpeedOrderAddressViewController: BaseTableViewController {
  
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
  var tempAddress: Address?
  var address: Address?
  var addresses = Addresses()
  
  var selectedIndex: Int? {
    didSet {
      if selectedIndex == nil {
        address = tempAddress
      } else {
        address = addresses.list.objectAtIndex(selectedIndex) as? Address
      }
    
      self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0,
        inSection: SpeedOrderAddressTableViewSection.Address.rawValue)],
                                            withRowAnimation: .Automatic)
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    addresses.get { 
      self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0,
        inSection: SpeedOrderAddressTableViewSection.Address.rawValue)],
        withRowAnimation: .Automatic)
    }
  }
  
  @IBAction func selectIndexButtonTapped(sender: UIButton) {
    if sender.tag == kInvalidAddressIndex {
      selectedIndex = nil
    } else {
      endEditing()
      selectedIndex = !sender.selected ? sender.tag : nil
    }
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView("postcodes", title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func selectAddressButtonTapped() {
    endEditing()
    if let address = address, _ = address.detailAddress {
      addressDelegate?.handleAddress(address)
      popView()
    } else {
      showAlertView("주소를 입력해주세요.")
    }
  }
}

extension SpeedOrderAddressViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    address?.detailAddress = textField.text
    if selectedIndex == nil {
      tempAddress = address
    }
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    endEditing()
    return true
  }
}

extension SpeedOrderAddressViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    self.address = address
    if selectedIndex == nil {
      tempAddress = address
    }
    tableView.reloadData()
  }
}

extension SpeedOrderAddressViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SpeedOrderAddressTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? AddressCell {
      cell.configureCell(address, selectedIndex: selectedIndex, addressCount: addresses.total)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}

extension SpeedOrderAddressViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSpeedOrderAddressTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == SpeedOrderAddressTableViewSection.Top.rawValue {
      return 118
    } else {
      return 240
    }
  }
}

class AddressCell: UITableViewCell {
  
  @IBOutlet weak var newAddressSelectButton: UIButton!
  @IBOutlet weak var firstAddressSelectButton: UIButton!
  @IBOutlet weak var secondAddressSelectButton: UIButton!
  @IBOutlet weak var thirdAddressSelectButton: UIButton!
  @IBOutlet weak var zipCodeTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var detailAddressTextField: UITextField!
  @IBOutlet weak var findAddressButton: UIButton!
  @IBOutlet weak var zipCodeTextFieldTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var newButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstButtonTrailingLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondButtonTrailingLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(address: Address?, selectedIndex: Int?, addressCount: Int) {
    newAddressSelectButton.selected = selectedIndex == nil
    firstAddressSelectButton.selected = selectedIndex == 0
    secondAddressSelectButton.selected = selectedIndex == 1
    thirdAddressSelectButton.selected = selectedIndex == 2
    
    zipCodeTextField.text = address?.zipCode()
    addressTextField.text = address?.addressString()
    detailAddressTextField.text = address?.detailAddress
    
    findAddressButton.configureAlpha(selectedIndex == nil)
    zipCodeTextFieldTrailingLayoutConstraint.constant = selectedIndex == nil ? 144 : 8
    
    firstAddressSelectButton.configureAlpha(addressCount > 0)
    secondAddressSelectButton.configureAlpha(addressCount > 1)
    thirdAddressSelectButton.configureAlpha(addressCount > 2)
    
    newButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addressCount) * 48
    firstButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addressCount - 1) * 48
    secondButtonTrailingLayoutConstraint.constant = 8 + CGFloat(addressCount - 2) * 48
  }
}