
import UIKit
import FBSDKLoginKit

class AccountsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum AccountsTableViewSection: Int {
    case TopSpace
    case Account
    case PasswordChange
    case SnsHeader
    case Facebook
    case Kakao
    case BottomSpace
    case LogOut
    case Count
  }
  
  private let kAccountsTableViewCellIdentifiers = [
    "topSpaceCell",
    "accountCell",
    "passwordChangeCell",
    "snsHeaderCell",
    "facebookAccountCell",
    "kakaoAccountCell",
    "topSpaceCell",
    "logOutCell"]
  
  let snsInfos = SnsInfos()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    snsInfos.get {
      self.tableView.reloadData()
    }
    MyInfo.sharedMyInfo().get {
      self.tableView.reloadData()
    }
  }
  
  func reloadData() {
    tableView.reloadData()
  }
}

extension AccountsViewController {
  
  @IBAction func logOutButtonTapped() {
    let confirmAction = Action()
    confirmAction.type = .Method
    confirmAction.content = "logOut"
    
    let cancelAction = Action()
    cancelAction.type = .Method
    cancelAction.content = "reloadData"
    
    showAlertView(NSLocalizedString("sure log out", comment: "alert"),
                  hasCancel: true, confirmAction: confirmAction, cancelAction: cancelAction, delegate: self)
  }
  
  @IBAction func facebookSwitchToggled(sender: UISwitch) {
    snsInfoButtonTapped(sender.on, snsType: .Facebook) {
      FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email"], fromViewController: self)
      { (result, error) -> Void in
        if !result.isCancelled {
          self.loadingView.show()
          self.addSnsInfo(.Facebook, uid: FBSDKAccessToken.currentAccessToken().userID,
                          snsToken: FBSDKAccessToken.currentAccessToken().tokenString)
        } else {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  @IBAction func kakaoSwitchToggled(sender: UISwitch) {
    snsInfoButtonTapped(sender.on, snsType: .Kakao) { 
      KOSession.sharedSession().openWithCompletionHandler() { (error) -> Void in
        if KOSession.sharedSession().isOpen() {
          self.loadingView.show()
          SigningHelper.requestKakaoSignIn() {(uid, snsToken) in
            self.addSnsInfo(.Kakao, uid: uid,
              snsToken: snsToken)
          }
        } else {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func snsInfoButtonTapped(switchOn: Bool, snsType: SnsType, onFunction: () -> Void) {
    if switchOn {
      onFunction()
    } else if snsInfos.list.count == 1 && MyInfo.sharedMyInfo().account == nil {
      logOutButtonTapped()
    } else {
      deleteSnsInfo(snsType)
    }
  }
  
  func logOut() {
    MyInfo.sharedMyInfo().logOut {
      self.navigationController?.popToRootViewControllerAnimated(true)
    }
  }
  
  func addSnsInfo(snsType: SnsType, uid: String, snsToken: String) {
    let snsInfo = SnsInfo()
    snsInfo.type = snsType
    snsInfo.uid = uid
    snsInfo.snsToken = snsToken
    snsInfo.post({ (_) in
      self.setUpData()
      }, postFailure: { (error) in
        if let statusCode = error.statusCode {
          if statusCode == NetworkResponseCode.Duplicated.rawValue {
            self.showAlertView(NSLocalizedString("linked sns info", comment: "alert title"))
          }
        }
        self.tableView.reloadData()
    })
  }
  
  func deleteSnsInfo(snsType: SnsType) {
    if let snsInfo = snsInfos.snsInfo(snsType) {
      snsInfo.remove({ (_) in
        self.setUpData()
        if snsType == .Kakao {
          KOSession.sharedSession().close()
        } else {
          FBSDKLoginManager().logOut()
        }
        }, deleteFailure: { (_) in
          self.tableView.reloadData()
      })
    }
  }
}

extension AccountsViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kAccountsTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
}

extension AccountsViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return AccountsTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == AccountsTableViewSection.PasswordChange.rawValue && MyInfo.sharedMyInfo().account == nil {
      return 0
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    if let cell = cell as? SnsInfoCell {
      if indexPath.section == AccountsTableViewSection.Facebook.rawValue {
        cell.setUpCell(snsInfos.isConnected(.Facebook))
      } else {
        cell.setUpCell(snsInfos.isConnected(.Kakao))
      }
    } else if let cell = cell as? MyAccountCell {
      cell.setUpCell(MyInfo.sharedMyInfo().account)
    }
    return cell
  }
}

class SnsInfoCell: UITableViewCell {
  
  @IBOutlet weak var connectedSwitch: UISwitch!
  
  func setUpCell(isConnected: Bool) {
    connectedSwitch.on = isConnected
  }
}

class MyAccountCell: UITableViewCell {
  
  @IBOutlet weak var accountLabel: UILabel!
  
  func setUpCell(account: String?) {
    if let account = account {
      accountLabel.text = account
    } else {
      accountLabel.text = "계정이 없습니다."
    }
  }
  
}