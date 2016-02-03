
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
  lazy var usageValues: ProductProperty = {
    let useValues = ProductProperty()
    useValues.alias = "usage"
    return useValues
  }()
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: segue)
    if let speedOrderAddressViewController = segue.destinationViewController as? SpeedOrderAddressViewController {
      speedOrderAddressViewController.addressDelegate = self
    } else if let quickSelectResultsViewController = segue.destinationViewController as? QuickSelectResultsViewController,
      selectedUsageIndex = selectedUsageIndex {
        quickSelectResultsViewController.productList.productPropertyValueIds = [Int]()
        quickSelectResultsViewController.productList.productPropertyValueIds!.append(usageValues.values[selectedUsageIndex].id!)
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    usageValues.get()
  }
  
  @IBAction func selectUsageButtonTapped() {
    let initialSelection = selectedUsageIndex != nil ? selectedUsageIndex! : 0
    showActionSheet("용도를 선택해 주세요",
      rows: usageValues.valueTitles(),
      initialSelection: initialSelection,
      sender: nil,
      doneBlock: { (_, index, _) -> Void in
        self.selectedUsageIndex = index
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
      if let selectedUsageIndex = selectedUsageIndex {
        usageValue = usageValues.values[selectedUsageIndex]
      }
      cell.configureCell(usageValue)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}

extension SpeedOrderFilterViewController: DynamicHeightTableViewProtocol {
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
