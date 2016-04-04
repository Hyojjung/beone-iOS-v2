
import UIKit

let kCardNumberFirstTextFieldTag = 100
let kCardNumberLastTextFieldTag = 103
let kNextYearButtonTextFieldTag = 105
let kBirthdayTextFieldTag = 106
let kCardNameTextFieldTag = 108

class AddingBillKeyViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum BillKeyTableViewSection: Int {
    case BillKeyType
    case CardNumber
    case ExpiredAt
    case CorporationNumber
    case Password
    case Birthday
    case CardName
    case Policy
    case Button
    case Count
  }
  
  private let kBillKeyTableViewCellIdentifiers = [
    "billKeyTypeCell",
    "cardNumberCell",
    "expiredDateCell",
    "corporationNumberCell",
    "passwordCell",
    "birthdayCell",
    "cardNameCell",
    "policyCell",
    "buttonCell"]
  
  private let monthArray = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
  
  lazy var yearArray: [String] = {
    var yearArray = [String]()
    for i in 0..<12 {
      yearArray.appendObject("\(NSDate().year() + i)년")
    }
    return yearArray
  }()
  
  var billKey = BillKey()
  var isGoingDown = true
  var isPolicyAgreement = false
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
}

extension AddingBillKeyViewController {
  func addToolbar(textField: UITextField) {
    let previousButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 105)!,
      target: self,
      action: #selector(AddingBillKeyViewController.previousButtonTapped))
    previousButton.tintColor = gold
    
    let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
    fixedSpace.width = 20
    
    let nextButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 106)!,
      target: self,
      action: #selector(AddingBillKeyViewController.nextButtonTapped))
    nextButton.tintColor = gold
    
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
      target: self,
      action: #selector(NSMutableAttributedString.endEditing))
    doneButton.tintColor = gold
    
    let toolBar = UIToolbar()
    toolBar.barStyle = .Default
    toolBar.items = [previousButton, fixedSpace, nextButton, flexibleSpace, doneButton]
    toolBar.sizeToFit()
    textField.inputAccessoryView = toolBar
  }
  
  private func firstResponder() -> UITextField? {
    for i in kCardNumberFirstTextFieldTag..<(kCardNameTextFieldTag + 1) {
      if let textField = view.viewWithTag(i) as? UITextField {
        if textField.isFirstResponder() {
          return textField
        }
      }
    }
    return nil
  }
  
  func nextButtonTapped() {
    isGoingDown = true
    let tag = firstResponder()!.tag
    if let textfield = view.viewWithTag(tag + 1) as? UITextField {
      textfield.becomeFirstResponder()
    } else if tag == kBirthdayTextFieldTag && billKey.type == .Personal {
      let cardNameTextField = self.view.viewWithTag(kCardNameTextFieldTag) as! UITextField
      cardNameTextField.becomeFirstResponder()
    } else {
      endEditing()
      if tag == kCardNumberLastTextFieldTag {
        selectMonthButtonTapped()
      }
    }
  }
  
  func previousButtonTapped() {
    isGoingDown = false
    let tag = firstResponder()!.tag
    if let textfield = view.viewWithTag(tag - 1) as? UITextField {
      textfield.becomeFirstResponder()
    } else if tag == kCardNameTextFieldTag && billKey.type == .Personal {
      let birthdayTextField = self.view.viewWithTag(kBirthdayTextFieldTag) as! UITextField
      birthdayTextField.becomeFirstResponder()
    } else {
      endEditing()
      if tag == kNextYearButtonTextFieldTag {
        selectYearButtonTapped()
      }
    }
  }
}

// MARK: - Actions

extension AddingBillKeyViewController {
  
  @IBAction func postBillKeyButtonTapped() {
    endEditing()
    for i in kCardNumberFirstTextFieldTag..<kCardNameTextFieldTag {
      if let textField = view.viewWithTag(i) as? UITextField {
        if textField.text == nil || textField.text!.isEmpty {
          showAlertView("항목을 모두 입력 해주세요.")
          return
        }
      }
    }
    if !isPolicyAgreement {
      showAlertView("NICEPAY 정기과금 개인정보 취급방침 및 카드정보 수집 및 이용방침에 동의 해주세요.")
      return
    }
    
    var cardNumber = String()
    for i in kCardNumberFirstTextFieldTag..<(kCardNumberLastTextFieldTag + 1) {
      let textField = view.viewWithTag(i) as! UITextField
      cardNumber += textField.text!
    }
    billKey.cardNumber = cardNumber
    let cardNameTextField = view.viewWithTag(kCardNameTextFieldTag) as! UITextField
    billKey.desc = cardNameTextField.text
    if billKey.type == .Personal {
      let passwordTextField = view.viewWithTag(kNextYearButtonTextFieldTag) as! UITextField
      billKey.password = passwordTextField.text
      
      let birthdayTextField = view.viewWithTag(kBirthdayTextFieldTag) as! UITextField
      billKey.idNumber = birthdayTextField.text
    } else {
      var corporationNumber = String()
      for i in kNextYearButtonTextFieldTag..<(kNextYearButtonTextFieldTag + 3) {
        let textField = view.viewWithTag(i) as! UITextField
        corporationNumber += textField.text!
      }
      billKey.idNumber = corporationNumber
    }
    billKey.post({ (_) -> Void in
      self.popView()
      }) { (error) -> Void in
        if error.statusCode == NetworkResponseCode.Invalid.rawValue ||
          error.statusCode == NetworkResponseCode.CannotGoThrough.rawValue {
            if let responseObject = error.responseObject as? [String: AnyObject],
              error = responseObject["error"] as? [String: AnyObject],
              key = error["alert"] as? String {
                self.showAlertView("'" + key + "' 다시 확인해주세요.")
            }
        }
    }
  }
  
  @IBAction func toggleAgreementButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    isPolicyAgreement = sender.selected
  }
  
  @IBAction func showPrivacyPolicyViewButtonTapped() {
    endEditing()
    let url = "policies/billing".urlForm()
    showWebView(url, title: "NICEPAY 정기과금 개인정보 취급방침")
  }
  
  @IBAction func showCardInfoPolicyViewButtonTapped() {
    endEditing()
    let url = "policies/card".urlForm()
    showWebView(url, title: "카드정보 수집 및 이용방침")
  }
  
  @IBAction func selectMonthButtonTapped() {
    showActionSheet(NSLocalizedString("select month", comment: "action sheet title"),
      rows: monthArray,
      initialSelection: billKey.expiredMonth - 1,
      sender: nil,
      doneBlock: { (_, index, _) -> Void in
        self.billKey.expiredMonth = index + 1
        self.tableView.reloadSections(NSIndexSet(index: BillKeyTableViewSection.ExpiredAt.rawValue),
          withRowAnimation: .Automatic)
        
        if self.isGoingDown {
          self.selectYearButtonTapped()
        } else {
          let cardNumberLastTextField = self.view.viewWithTag(kCardNumberLastTextFieldTag) as! UITextField
          cardNumberLastTextField.becomeFirstResponder()
        }
    })
  }
  
  @IBAction func selectYearButtonTapped() {
    let initialSelection = NSDate().year() - billKey.expiredYear
    showActionSheet(NSLocalizedString("select year", comment: "action sheet title"),
      rows: yearArray,
      initialSelection: initialSelection,
      sender: nil,
      doneBlock: { (_, index, _) -> Void in
        self.billKey.expiredYear = NSDate().year() + index
        self.tableView.reloadSections(NSIndexSet(index: BillKeyTableViewSection.ExpiredAt.rawValue),
          withRowAnimation: .Automatic)
        
        if self.isGoingDown {
          let nextButtonTextField = self.view.viewWithTag(kNextYearButtonTextFieldTag) as! UITextField
          nextButtonTextField.becomeFirstResponder()
        } else {
          self.selectMonthButtonTapped()
        }
    })
  }
  
  @IBAction func selectPersonalCardButtonTapped() {
    billKey.type = .Personal
    tableView.reloadData()
  }
  
  @IBAction func selectCorporationCardButtonTapped() {
    billKey.type = .Corporation
    tableView.reloadData()
  }
}

extension AddingBillKeyViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    addToolbar(textField)
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    endEditing()
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let stringLength = string.characters.count + textField.text!.characters.count
    let tag = textField.tag
    if !string.isEmpty && Int(string) == nil && tag != kCardNameTextFieldTag {
      return false
    } else if textField.text != nil && range.length == 0 {
      if tag >= kCardNumberFirstTextFieldTag && tag <= kCardNumberLastTextFieldTag && stringLength > 4 ||
        ((tag == kNextYearButtonTextFieldTag && billKey.type == .Personal) || tag == kNextYearButtonTextFieldTag + 1 && billKey.type == .Corporation) && stringLength > 2 ||
        tag == kNextYearButtonTextFieldTag && billKey.type == .Corporation && stringLength > 3 ||
        tag == kNextYearButtonTextFieldTag + 2 && billKey.type == .Corporation && stringLength > 5 ||
        tag == kBirthdayTextFieldTag && billKey.type == .Personal && stringLength > 6 {
          return false
      }
    }
    return true
  }
}

extension AddingBillKeyViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return BillKeyTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? BillKeyTypeCell {
      cell.configureCell(billKey.type)
    } else if let cell = cell as? ExpiredDateCell {
      cell.configureCell(billKey.expiredMonthString(), year: billKey.expiredYear)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if billKey.type == .Personal && section == BillKeyTableViewSection.CorporationNumber.rawValue ||
      billKey.type == .Corporation &&
      (section == BillKeyTableViewSection.Password.rawValue || section == BillKeyTableViewSection.Birthday.rawValue) {
        return 0
    }
    return 1
  }
}

extension AddingBillKeyViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kBillKeyTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    switch (BillKeyTableViewSection(rawValue: indexPath.section)!) {
    case .BillKeyType:
      return 84
    case .Policy:
      return 120
    case .Button:
      return 50
    case .CardName:
      return 79
    default:
      return 44
    }
  }
}

class BillKeyTypeCell: UITableViewCell {
  
  @IBOutlet weak var personalTypeButton: UIButton!
  @IBOutlet weak var corporationTypeButton: UIButton!
  
  func configureCell(billKeyType: BillKeyType) {
    personalTypeButton.selected = billKeyType == .Personal
    corporationTypeButton.selected = billKeyType == .Corporation
  }
}

class ExpiredDateCell: UITableViewCell {
  
  @IBOutlet weak var expiredMonthLabel: UILabel!
  @IBOutlet weak var expiredYearLabel: UILabel!
  
  func configureCell(monthString: String, year: Int) {
    expiredMonthLabel.text = monthString + "월"
    expiredYearLabel.text = "\(year)년"
  }
}

