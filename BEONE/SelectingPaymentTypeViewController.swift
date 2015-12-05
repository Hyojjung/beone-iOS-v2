
import UIKit

class SelectingPaymentTypeViewController: BaseTableViewController {
  // MARK: - Constant
  
  private enum SelectingPaymentTypeTableViewSection: Int {
    case ItemTitle
    case Item
    case DeliveryTitle
    case IsRightNow
    case DeliveryDate
    case DeliveryAlert
    case Parcel
    case DiscountInfoTitle
    case DiscountWay
    case Discount
    case PriceTitle
    case Price
    case PaymentTitle
    case Payment
    case PayButton
    case Count
  }
  
  private let kSelectingPaymentTypeTableViewCellIdentifiers = ["itemTitleCell",
    "itemCell",
    "deliveryTypeTitleCell",
    "deliveryDateTypeCell",
    "timeCell",
    "alertCell",
    "parcelLabelCell",
    "discountInfoTitleCell",
    "discountWayCell",
    "discountSection",
    "priceTitleCell",
    "priceCell",
    "wayTitleCell",
    "waySection",
    "payButtonCell"]
  
}

extension SelectingPaymentTypeViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SelectingPaymentTypeTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell(cellIdentifier(indexPath), indexPath: indexPath)
    return cell
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    switch SelectingPaymentTypeTableViewSection(rawValue: indexPath.section)! {
    case .Discount:
      return "nothingCell"
    case .Payment:
      return "wayCell"
    default:
      return kSelectingPaymentTypeTableViewCellIdentifiers[indexPath.section]
    }
  }
}
