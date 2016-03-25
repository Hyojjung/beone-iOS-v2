
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
  var selectedUsageIndex: Int?
  var selectedDeliveryDateIndex: Int?
  var productSearchData = ProductSearchData()
  var productPropertyList: ProductPropertyList = {
    let productPropertyList = ProductPropertyList()
    productPropertyList.forQuickSearch = true
    return productPropertyList
  }()
  
  deinit {
    BEONEManager.selectedAddress = nil
    BEONEManager.selectedDate = nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: segue)
    if let speedOrderAddressViewController = segue.destinationViewController as? SpeedOrderAddressViewController {
      speedOrderAddressViewController.addressDelegate = self
    } else if let speedOrderResultsViewController = segue.destinationViewController as? SpeedOrderResultsViewController,
      selectedUsageIndex = selectedUsageIndex, productProperty = productPropertyList.list.first as? ProductProperty {
        speedOrderResultsViewController.productList.productPropertyValueIds = [Int]()
        speedOrderResultsViewController.productList.address = address
        if let selectedDeliveryDateIndex = selectedDeliveryDateIndex {
          speedOrderResultsViewController.productList.availableDates =
            [productSearchData.reservationDateOptions[selectedDeliveryDateIndex].value!]
        }
        speedOrderResultsViewController.productList.productPropertyValueIds!.appendObject(productProperty.values[selectedUsageIndex].id)
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    productPropertyList.get()
    productSearchData.get()
  }
  
  @IBAction func selectUsageButtonTapped() {
    if let productProperty = productPropertyList.list.first as? ProductProperty {
      showActionSheet("용도를 선택해 주세요",
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
    showActionSheet("배송 받으실 날짜를 선택해 주세요",
      rows: productSearchData.reservationDateOptionsNames(),
      initialSelection: selectedDeliveryDateIndex,
      sender: nil,
      doneBlock: { (_, index, _) -> Void in
        self.selectedDeliveryDateIndex = index
        
        let dayInterval = self.productSearchData.reservationDateOptions[index]
        BEONEManager.selectedDate = nil
        if let day = Double(dayInterval.value!) {
          let calendar = DateFormatterHelper.koreanCalendar
          let selectedDate = calendar.components([.Month, .Day],
            fromDate: NSDate().dateByAddingTimeInterval(day * kSecondToDay))
          BEONEManager.selectedDate = selectedDate
        }
        
        self.tableView.reloadData()
    })
  }
  
  @IBAction func showResultViewButtonTapped() {
    performSegueWithIdentifier("From Quick Search To Search Result", sender: nil)
  }
}

extension SpeedOrderFilterViewController: AddressDelegate {
  
  func handleAddress(address: Address) {
    self.address = address
    BEONEManager.selectedAddress = address
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
        productProperty = productPropertyList.list.first as? ProductProperty {
          usageValue = productProperty.values[selectedUsageIndex]
      }
      cell.configureCell(usageValue)
    } else if let cell = cell as? DeliveryDateCell, selectedDeliveryDateIndex = selectedDeliveryDateIndex {
      cell.configureCell(productSearchData.reservationDateOptions[selectedDeliveryDateIndex].name)
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
      addressLabel.text = "배송지를 선택해 주세요"
    }
  }
}

class UsageCell: UITableViewCell {
  
  @IBOutlet weak var usageLabel: UILabel!
  
  func configureCell(usage: ProductPropertyValue?) {
    if let usage = usage {
      usageLabel.text = usage.name
    } else {
      usageLabel.text = "용도 (선택)"
    }
  }
}

class DeliveryDateCell: UITableViewCell {
  
  @IBOutlet weak var deliveryDateLabel: UILabel!
  
  func configureCell(deliveryDateTitle: String?) {
    if let deliveryDateTitle = deliveryDateTitle {
      deliveryDateLabel.text = deliveryDateTitle
    } else {
      deliveryDateLabel.text = "배송 받으실 날짜를 선택해 주세요"
    }
  }
}
