
import UIKit

class SideBarViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SideBarTableViewSection: Int {
    case Top
    case UserInfo
    case Buttons
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = ["productCountCell",
    "priceCell",
    "searchPropertyCell",
    "searchPropertyCell",
    "moreUsageButtonCell",
    "searchPropertyCell",
    "searchButtonCell"]
  
  var sideBarViewContents = SideBarViewContents()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    if MyInfo.sharedMyInfo().isUser() {
      sideBarViewContents.get { () -> Void in
        
      }
    } else {
      showSigningView()
    }
  }
}

extension SideBarViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SideBarTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}

extension SideBarViewController: DynamicHeightTableViewProtocol {
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    switch (SideBarTableViewSection(rawValue: indexPath.section)!) {
    case .Top:
      return 64
    case .UserInfo:
      return 64
    case .Buttons:
      return 158
    default:
      return nil
    }
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    switch (SideBarTableViewSection(rawValue: indexPath.section)!) {
    case .Top:
      return "topCell"
    case .UserInfo:
      return "userInfoCell"
    case .Buttons:
      return "buttonsCell"
    default:
      return "nil"
    }
  }
}
