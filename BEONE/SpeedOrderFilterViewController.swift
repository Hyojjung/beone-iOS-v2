
import UIKit

class SpeedOrderFilterViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SpeedOrderFilterTableViewSection: Int {
    case Top
    case Address
    case Date
    case Usage
    case Count
  }
  
  private let kSpeedOrderFilterableViewCellIdentifiers = [
    "topCell",
    "addressCell",
    "dateCell",
    "usageCell"]
  
  var address: Address?
  var addresses = Addresses()
  var selectedUsageIndex: Int?
  var selectedDeliveryDateIndex: Int?
  var productSearchData = ProductSearchData()
  var productProperties: ProductProperties = {
    let productProperties = ProductProperties()
    productProperties.forQuickSearch = true
    return productProperties
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  deinit {
    BEONEManager.selectedAddress = nil
    BEONEManager.selectedDate = nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: segue)
    if let speedOrderAddressViewController = segue.destinationViewController as? SpeedOrderAddressViewController {
      speedOrderAddressViewController.addressDelegate = self
    } else if let speedOrderResultsViewController = segue.destinationViewController as? SpeedOrderResultsViewController {
      if let productProperty = productProperties.list.first as? ProductProperty,
        selectedUsageIndex = selectedUsageIndex {
        speedOrderResultsViewController.productPropertyValueIds = [productProperty.values[selectedUsageIndex].id!]
      }
      if let selectedDeliveryDateIndex = selectedDeliveryDateIndex {
        speedOrderResultsViewController.availableDates =
          [productSearchData.reservationDateOptions[selectedDeliveryDateIndex].value!]
      }
      speedOrderResultsViewController.address = address
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    productProperties.get()
    productSearchData.get { 
      if !self.productSearchData.reservationDateOptions.isEmpty {
        self.selectedDeliveryDateIndex = 0
        for (index, reservationDateOption) in self.productSearchData.reservationDateOptions.enumerate() {
          if reservationDateOption.isSelected {
            self.selectedDeliveryDateIndex = index
          }
        }
        self.tableView.reloadData()
      }
    }
    addresses.get {
      self.address = self.addresses.recentAddress()
      self.tableView.reloadData()
    }
  }
  
  @IBAction func selectUsageButtonTapped() {
    if let productProperty = productProperties.list.first as? ProductProperty {
      showActionSheet(NSLocalizedString("select usage", comment: "action sheet title"),
                      rows: productProperty.valueTitles(),
                      initialSelection: selectedUsageIndex,
                      sender: nil,
                      doneBlock: { (_, index, _) -> Void in
                        self.selectedUsageIndex = index
                        self.tableView.reloadData()
      })
    }
  }
  
  @IBAction func selectDeliveryDateButtonTapped() {
    showActionSheet(NSLocalizedString("select delivery date for search", comment: "action sheet title"),
                    rows: productSearchData.reservationDateOptionsNames(),
                    initialSelection: selectedDeliveryDateIndex,
                    sender: nil,
                    doneBlock: { (_, index, _) -> Void in
                      self.selectedDeliveryDateIndex = index
                      self.tableView.reloadData()
    })
  }
  
  @IBAction func showResultViewButtonTapped() {
    if selectedDeliveryDateIndex == nil {
      showAlertView(NSLocalizedString("select delivery date for search", comment: "alert title"))
    } else if address == nil {
      showAlertView(NSLocalizedString("select address for search",
        comment: "alert title"))
    } else {
      let dayInterval = productSearchData.reservationDateOptions[selectedDeliveryDateIndex!]
      if let day = Double(dayInterval.value!) {
        let calendar = DateFormatterHelper.koreanCalendar
        let selectedDate = calendar.components([.Year, .Month, .Day],
                                               fromDate: NSDate().dateByAddingTimeInterval(day * kSecondToDay))
        BEONEManager.selectedDate = selectedDate
      }
      BEONEManager.selectedAddress = address
      performSegueWithIdentifier("From Quick Search To Search Result", sender: nil)
    }
  }
}

extension SpeedOrderFilterViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    self.address = address
    tableView.reloadData()
  }
}

extension SpeedOrderFilterViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SpeedOrderFilterTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? SpeedOrderAddressCell {
      cell.configureCell(address)
    } else if let cell = cell as? UsageCell {
      var usageValue: ProductPropertyValue? = nil
      if let selectedUsageIndex = selectedUsageIndex,
        productProperty = productProperties.list.first as? ProductProperty {
        usageValue = productProperty.values[selectedUsageIndex]
      }
      cell.configureCell(usageValue)
    } else if let cell = cell as? DeliveryDateCell {
      cell.configureCell(productSearchData.reservationDateOptions.objectAtIndex(selectedDeliveryDateIndex))
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}

extension SpeedOrderFilterViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSpeedOrderFilterableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == SpeedOrderFilterTableViewSection.Top.rawValue {
      return 118
    } else {
      return 94
    }
  }
}

class SpeedOrderAddressCell: UITableViewCell {
  
  @IBOutlet weak var addressLabel: UILabel!
  
  func configureCell(address: Address?) {
    if let address = address {
      addressLabel.text = address.fullAddressString(true)
    } else {
      addressLabel.text = NSLocalizedString("select address for search",
                                            comment: "selection")
    }
  }
}

class UsageCell: UITableViewCell {
  
  @IBOutlet weak var usageLabel: UILabel!
  
  func configureCell(usage: ProductPropertyValue?) {
    if let usage = usage {
      usageLabel.text = usage.name
      usageLabel.font = UIFont.systemFontOfSize(20)
    } else {
      usageLabel.text = NSLocalizedString("select usage", comment: "label text")
      usageLabel.font = UIFont.systemFontOfSize(15)
    }
  }
}

class DeliveryDateCell: UITableViewCell {
  
  @IBOutlet weak var deliveryDateTitleLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  func configureCell(reservationDateOption: ReservationDateOption?) {
    if let deliveryDateTitle = reservationDateOption?.display {
      deliveryDateLabel.text = deliveryDateTitle
    } else {
      deliveryDateLabel.text = NSLocalizedString("select delivery date for search",
                                                 comment: "selection")
    }
    deliveryDateTitleLabel.text = reservationDateOption?.name
  }
}
