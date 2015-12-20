
import UIKit

class ProfileViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum ProfileTableViewSection: Int {
    case TopImage
    case Anniversary
    case AnniversaryAddButton
    case AccountTitle
    case Account
    case ProfileTitle
    case Profile
    case Address
    case Logo
    case Count
  }
  
  private let kAnniversarySectionDateLabelTag = 100
  private let kAnniversarySectionNameLabelTag = 101
  
  private let kProfileTableViewCellIdentifiers = ["topImageCell",
    "annivesaryCell",
    "anniveraryAddButtoncell",
    "accountTitleCell",
    "accountCell",
    "profileTitleCell",
    "profileCell",
    "addressCell",
    "logoCell"]
  
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
}

// MARK: - UITableViewDataSource

extension ProfileViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return ProfileTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell(cellIdentifier(indexPath), indexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ProfileViewController {
  
//  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    if let tableView = tableView as? DynamicHeightTableView {
//      return tableView.heightForBasicCell(indexPath)
//    }
//    return 0
//  }
}

extension ProfileViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kProfileTableViewCellIdentifiers[indexPath.section]
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {

  }
}