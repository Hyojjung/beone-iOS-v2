
import UIKit

class SettingViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SettingTableViewSection: Int {
    case TopSpace
    case Profile
    case NotiTitle
    case Push
    case InfoTitle
    case Notice
    case Version
    case MiddleSpace
    case Inquiry
    case ServiceRule
    case PrivacyPolicy
    case BottomSpace
    case LogOut
    case Logo
    case Count
  }
  
  private let kProfileSectionProfileLabelTag = 100
  private let kPushSectionSwitchTag = 100
  private let kVersionSectionVersionLabelTag = 100
  private let kVersionSectionUpgradeLabelTag = 101
  
  private let kSettingTableViewCellIdentifiers = ["topSpaceCell",
    "profileCell",
    "pushSectionCell",
    "pushCell",
    "infoSectionCell",
    "noticeCell",
    "versionCell",
    "middleSpaceCell",
    "inquiryCell",
    "serviceCell",
    "privacyCell",
    "bottomSpaceCell",
    "logOutCell",
    "logoCell"]
  
  // MARK: - Property
  
  private let deviceInfo = DeviceInfo()
  private let version = Version()
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    version.get { () -> Void in
      self.tableView.reloadData()
    }
    deviceInfo.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationLogOutSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationSigningSuccess, object: nil)
  }
}

// MARK: - Actions

extension SettingViewController {
  
  @IBAction func pushReceivingSwitchToggled() {
    deviceInfo.isReceivingPush = !deviceInfo.isReceivingPush
    deviceInfo.put()
  }
}

// MARK: - UITableViewDataSource

extension SettingViewController {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SettingTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == SettingTableViewSection.LogOut.rawValue && !MyInfo.sharedMyInfo().isUser() ? 0 : 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SettingViewController {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch SettingTableViewSection(rawValue: indexPath.section)! {
    case .LogOut:
      logOut()
    case .ServiceRule:
      showWebView("\(kBaseApiUrl)\(kServicePolicyUrlString)", title: NSLocalizedString("service policy", comment: "title"))
    case .PrivacyPolicy:
      showWebView("\(kBaseApiUrl)\(kPrivacyPolicyUrlString)", title: NSLocalizedString("privacy policy", comment: "title"))
    case .Profile:
      showSigningView()
    case .Inquiry:
      print("inquiry")
      //      [[UIApplication sharedApplication] openURL:[BOBEONEManager sharedInstance].sharedVersionInfo.kakaoInquiryUrl];
    case .Version:
      UIApplication.sharedApplication().openURL(kAppDownloadUrl.url())
    default:
      break
    }
  }
  
  private func logOut() {
    let logOutAction = Action()
    logOutAction.type = .Method
    logOutAction.content = "logOut"
    showAlertView(NSLocalizedString("sure log out", comment: "alert"), hasCancel: true,
      confirmAction: logOutAction, cancelAction: nil, delegate: MyInfo.sharedMyInfo())
  }
}

// MARK: - DynamicHeightTableViewProtocol

extension SettingViewController: DynamicHeightTableViewProtocol {
 
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSettingTableViewCellIdentifiers[indexPath.section]
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    switch SettingTableViewSection(rawValue: indexPath.section)! {
    case .Profile:
      configureProfileCell(cell)
    case .Push:
      configurePushCell(cell)
    case .Version:
      configureVersionCell(cell)
    default:
      break
    }
  }

  private func configureProfileCell(cell: UITableViewCell) {
    let profileLabel = cell.viewWithTag(kProfileSectionProfileLabelTag) as? UILabel
    profileLabel?.text = MyInfo.sharedMyInfo().isUser() ?
      NSLocalizedString("my info", comment: "section name") : NSLocalizedString("sign in", comment: "section name")
  }
  
  private func configurePushCell(cell: UITableViewCell) {
    let pushSwitch = cell.viewWithTag(kPushSectionSwitchTag) as? UISwitch
    pushSwitch?.on = deviceInfo.isReceivingPush
  }
  
  private func configureVersionCell(cell: UITableViewCell) {
    let versionLabel = cell.viewWithTag(kVersionSectionVersionLabelTag) as? UILabel
    versionLabel?.text = version.version
    
    let needUpdate = version.needUpdate == true
    let updateLabel = cell.viewWithTag(kVersionSectionUpgradeLabelTag) as? UILabel
    updateLabel?.text = needUpdate ?
      NSLocalizedString("need update", comment: "update label") : NSLocalizedString("latest version", comment: "update label")
    cell.selectionStyle = needUpdate ? .Gray : .None
  }
}