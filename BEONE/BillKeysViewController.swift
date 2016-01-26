
import UIKit

class BillKeysViewController: BaseTableViewController {

  // MARK: - Constant
  
  private enum BillKeyTableViewSection: Int {
    case Card
    case AddCardButton
    case Info
    case Count
  }
  
  private let kBillKeyTableViewCellIdentifiers = [
    "cardCell",
    "addCardCell",
    "infoCell"]
  
  var billKeyList = BillKeyList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    billKeyList.get { () -> Void in
      
    }
  }
}

extension BillKeysViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return BillKeyTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    return cell
  }
}

extension BillKeysViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kBillKeyTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
}
