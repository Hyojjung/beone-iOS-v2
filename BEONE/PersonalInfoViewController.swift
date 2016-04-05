
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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    MyInfo.sharedMyInfo().get {
      self.tableView.reloadData()
    }
  }
  
  @IBAction func saveButtonTapped() {
    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
      inSection: PersonalInfoTableViewSection.Name.rawValue)) as? InfoTextFieldCell {
      MyInfo.sharedMyInfo().name = cell.textField.text
    }
    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
      inSection: PersonalInfoTableViewSection.Phone.rawValue)) as? InfoTextFieldCell {
      MyInfo.sharedMyInfo().phone = cell.textField.text
    }
    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
      inSection: PersonalInfoTableViewSection.Email.rawValue)) as? InfoTextFieldCell {
      MyInfo.sharedMyInfo().email = cell.textField.text
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
    switch PersonalInfoTableViewSection(rawValue: indexPath.section)! {
    case .Name:
      if let cell = cell as? InfoTextFieldCell {
        cell.setUpCell(MyInfo.sharedMyInfo().name)
      }
    case .Phone:
      if let cell = cell as? InfoTextFieldCell {
        cell.setUpCell(MyInfo.sharedMyInfo().phone)
      }
    case .Email:
      if let cell = cell as? InfoTextFieldCell {
        cell.setUpCell(MyInfo.sharedMyInfo().email)
      }
    default:
      break
    }
    return cell
  }
}

class InfoTextFieldCell: UITableViewCell {
  
  @IBOutlet weak var textField: UITextField!
  
  func setUpCell(info: String?) {
    textField.text = info
  }
}