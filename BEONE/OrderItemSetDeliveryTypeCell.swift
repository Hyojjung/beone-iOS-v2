
import UIKit

class OrderItemSetDeliveryTypeCell: UITableViewCell {
  @IBOutlet weak var deliveryTypeLabel: UILabel!
  
  func configureCell(orderableItemSet: OrderableItemSet) {
    deliveryTypeLabel.text = orderableItemSet.deliveryType.name
  }
  
  func calculatedHeight(needCell: Bool) -> CGFloat {
    return needCell ? 40 : 1
  }
}
