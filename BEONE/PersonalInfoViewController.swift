
import UIKit

class PersonalInfoViewController: BaseTableViewController {
  
  private enum PersonalInfoTableViewSection: Int {
    case Name
    case Phone
    case Email
    case Birthday
    case Gender
    case SaveButton
    case Count
  }
  
  private let kPersonalInfoTableViewCellIdentifiers = ["nameCell",
                                                       "phoneCell",
                                                       "emailCell",
                                                       "birthdayCell",
                                                       "genderCell",
                                                       "saveButtonCell"]
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    MyInfo.sharedMyInfo().get {
      self.tableView.reloadData()
    }
  }
}

extension PersonalInfoViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kPersonalInfoTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
}

extension PersonalInfoViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return PersonalInfoTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath),
                                                           forIndexPath: indexPath)
    return cell
  }
}

