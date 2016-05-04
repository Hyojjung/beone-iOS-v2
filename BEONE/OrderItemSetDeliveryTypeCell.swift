
import UIKit

class OrderItemSetDeliveryTypeCell: UITableViewCell {
  @IBOutlet weak var deliveryTypeLabel: UILabel!
  
  func configureCell(orderableItemSet: OrderableItemSet, needCell: Bool) {
    deliveryTypeLabel.text = orderableItemSet.deliveryType.name
    deliveryTypeLabel.configureAlpha(needCell)
    contentView.backgroundColor = needCell ? UIColor.whiteColor() : UIColor.clearColor()
  }
  
  func calculatedHeight(needCell: Bool) -> CGFloat {
    return needCell ? 40 : 1
  }
}
