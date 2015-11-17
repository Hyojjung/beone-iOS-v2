
import UIKit

class ProfileViewController: BaseViewController {
  
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
  
  // MARK: - Property

  @IBOutlet weak var tableView: UITableView!

  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.estimatedRowHeight = kTableViewDefaultHeight
    tableView.rowHeight = UITableViewAutomaticDimension
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
    let cell = tableView.dequeueReusableCellWithIdentifier(kProfileTableViewCellIdentifiers[indexPath.section],
      forIndexPath: indexPath)
    
    return cell
  }
}
