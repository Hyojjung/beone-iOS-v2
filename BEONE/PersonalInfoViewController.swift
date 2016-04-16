
import UIKit
import ActionSheetPicker_3_0

class PersonalInfoViewController: BaseTableViewController {
  
  private let kMaxEmailLength = 50
  private let kMaxPhoneLength = 20
  
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
  
  func syncMyInfoWithView() {
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

extension PersonalInfoViewController {
  
  @IBAction func saveButtonTapped() {
    syncMyInfoWithView()
    if MyInfo.sharedMyInfo().email?.isValidEmail() == false {
      showAlertView(NSLocalizedString("check email form", comment: "alert title"))
    } else {
      MyInfo.sharedMyInfo().put {
        self.popView()
      }
    }
  }
  
  @IBAction func birthdayButtonTapped() {
    endEditing()
    
    let selectedDate: NSDate
    if let birthday = MyInfo.sharedMyInfo().birthday {
      selectedDate = birthday
    } else {
      selectedDate = NSDate()
    }
    
    let datePicker = ActionSheetDatePicker(title: "생일을 선택해주세요",
                                           datePickerMode: .Date,
                                           selectedDate: selectedDate,
                                           doneBlock: { (_, selectedDate, _) in
                                            if selectedDate.compare(NSDate()) != .OrderedDescending {
                                              MyInfo.sharedMyInfo().birthday = selectedDate as? NSDate
                                              self.syncMyInfoWithView()
                                              self.tableView.reloadData()
                                            } else {
                                              let action = Action()
                                              action.type = .Method
                                              action.content = "birthdayButtonTapped"
                                              
                                              self.showAlertView("오늘 이후는 선택하실 수 없습니다.",
                                                confirmAction: action,
                                                delegate: self)
                                            }
      }, cancelBlock: nil, origin: view)
    datePicker.showActionSheetPicker()
  }
  
  @IBAction func maleButtonTapped(sender: UIButton) {
    MyInfo.sharedMyInfo().gender = Gender.Male.rawValue
    tableView.reloadData()
  }
  
  @IBAction func femaleButtonTapped(sender: UIButton) {
    MyInfo.sharedMyInfo().gender = Gender.Female.rawValue
    tableView.reloadData()
  }
}

extension PersonalInfoViewController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if range.length == 0 {
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
        inSection: PersonalInfoTableViewSection.Name.rawValue)) as? InfoTextFieldCell {
        if cell.textField == textField {
          if textField.text != nil && (textField.text?.characters.count)! + string.characters.count > kMaxPhoneLength {
            return false
          }
        }
      }
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
        inSection: PersonalInfoTableViewSection.Phone.rawValue)) as? InfoTextFieldCell {
        if cell.textField == textField {
          if textField.text != nil && (textField.text?.characters.count)! + string.characters.count > kMaxPhoneLength {
            return false
          }
          return string.isEmpty || Int(string) != nil
        }
      }
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0,
        inSection: PersonalInfoTableViewSection.Email.rawValue)) as? InfoTextFieldCell {
        if cell.textField == textField {
          if textField.text != nil && (textField.text?.characters.count)! + string.characters.count > kMaxEmailLength {
            return false
          }
          return string.isNonKorean()
        }
      }
    }
    return true
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
    case .Birthday:
      if let cell = cell as? BirthdayCell {
        cell.setUpCell(MyInfo.sharedMyInfo().birthday)
      }
    case .Gender:
      if let cell = cell as? GenderCell {
        if let gender = MyInfo.sharedMyInfo().gender {
          cell.setUpCell(Gender(rawValue: gender))
        }
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

class BirthdayCell: UITableViewCell {
  
  @IBOutlet weak var birthdayButton: UIButton!
  
  func setUpCell(birthday: NSDate?) {
    birthdayButton.setTitle(birthday?.briefDateString(), forState: .Normal)
    birthdayButton.setTitle(birthday?.briefDateString(), forState: .Highlighted)
  }
}

class GenderCell: UITableViewCell {
  
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var femaleButton: UIButton!
  
  func setUpCell(gender: Gender?) {
    maleButton.selected = gender == .Male
    femaleButton.selected = gender == .Female
  }
}