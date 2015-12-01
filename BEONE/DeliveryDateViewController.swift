
import UIKit

class DeliveryDateViewController: BaseTableViewController {
  var order = BEONEManager.selectedOrder
}

extension DeliveryDateViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return order.orderableItemSets.count
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let orderableItemSet = order.orderableItemSets[section]
    return orderableItemSet.deliveryType.isReservable() ?
      orderableItemSet.orderableItems.count + 4 : orderableItemSet.orderableItems.count + 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell(cellIdentifier(indexPath), indexPath: indexPath)
    return cell
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    let orderableItemSet = order.orderableItemSets[indexPath.section]
    if indexPath.row == 0 {
      return kDeliveryTypeCellIdentifier
    } else if indexPath.row == 1 {
      return kShopNameCellIdentifier
    } else if indexPath.row == orderableItemSet.orderableItems.count + 2 {
      return orderableItemSet.deliveryType.isReservable() ? "timeCell" : "parcelLabelCell"
    } else if indexPath.row == orderableItemSet.orderableItems.count + 3 {
      return "alertCell"
    } else {
      return "itemCell"
    }
  }
}
