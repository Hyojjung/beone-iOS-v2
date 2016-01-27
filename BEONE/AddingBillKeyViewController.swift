
import UIKit

class AddingBillKeyViewController: BaseTableViewController {
  // MARK: - Constant
  
  private enum BillKeyTableViewSection: Int {
    case CardType
    case CardNumber
    case ExpiredAt
    case CompanyNumber
    case Password
    case Birthday
    case CardName
    case Policy
    case Button
    case Count
  }
  
  private let kBillKeyTableViewCellIdentifiers = [
    "cardTypeCell",
    "cardNumberCell",
    "expiredDateCell",
    "companyNumberCell",
    "passwordCell",
    "birthdayCell",
    "cardNameCell",
    "policyCell",
  "buttonCell"]
}
//
//extension AddingBillKeyViewController: UITableViewDataSource {
//  
//}
