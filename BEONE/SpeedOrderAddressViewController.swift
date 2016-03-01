
import UIKit

class SpeedOrderAddressViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SpeedOrderAddressTableViewSection: Int {
    case Top
    case Address
    case Count
  }
  
  private let kSpeedOrderAddressTableViewCellIdentifiers = [
    "topCell",
    "addressCell"]
  
  weak var addressDelegate: AddressDelegate?
  var address: Address?
  var addressList = AddressList()
  
  var selectedIndex: Int? {
    didSet {
      if selectedIndex != nil && selectedIndex < addressList.list.count {
        address = addressList.list[selectedIndex!] as? Address
      } else {
        selectedIndex = nil
        address = nil
      }
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    super.setUpView()
    addressList.get { () -> Void in
      if !self.addressList.list.isEmpty {
        self.selectedIndex = 0
      }
    }
    tableView.dynamicHeightDelgate = self
  }
  
  @IBAction func selectIndexButtonTapped(sender: UIButton) {
    selectedIndex = !sender.selected ? sender.tag : nil
  }
  
  @IBAction func segueToAddressViewButtonTapped() {
    showWebView("postcodes", title: NSLocalizedString("order view title", comment: "view title"), addressDelegate: self)
  }
  
  @IBAction func selectAddressButtonTapped() {
    if let address = address, _ = address.detailAddress {
      addressDelegate?.handleAddress(address)
      popView()
    } else {
      showAlertView("주소를 입력해주세요.")
    }
  }
}

extension SpeedOrderAddressViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    selectedIndex = nil
    self.address = address
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
      cell.configureCell(address, selectedIndex: selectedIndex)
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
  
  @IBOutlet weak var firstAddressSelectButton: UIButton!
  @IBOutlet weak var secondAddressSelectButton: UIButton!
  @IBOutlet weak var thirdAddressSelectButton: UIButton!
  @IBOutlet weak var zipCodeTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var detailAddressTextField: UITextField!
  
  func configureCell(address: Address?, selectedIndex: Int?) {
    firstAddressSelectButton.selected = selectedIndex == 0
    secondAddressSelectButton.selected = selectedIndex == 1
    thirdAddressSelectButton.selected = selectedIndex == 2
    
    zipCodeTextField.text = address?.zipCode()
    addressTextField.text = address?.addressString()
    detailAddressTextField.text = address?.detailAddress
  }
}