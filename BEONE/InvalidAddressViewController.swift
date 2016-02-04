
import UIKit

class InvalidAddressViewController: BaseTableViewController {

  var order = Order()
  var orderableCartItemIds: [Int]?
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let selectingPaymentTypeViewController = segue.destinationViewController as? SelectingPaymentTypeViewController {
      selectingPaymentTypeViewController.order = order
    }
  }
  
  @IBAction func orderableOrderButtonTapped() {
    if let orderableCartItemIds = orderableCartItemIds {
      var cartItemIds = order.cartItemIds
      for cartItemId in order.cartItemIds {
        if !orderableCartItemIds.contains(cartItemId) {
          cartItemIds.removeObject(cartItemId)
        }
      }
      if cartItemIds.isEmpty {
        showAlertView("배송가능 상품이 없습니다.")
      } else {
        order.cartItemIds = cartItemIds
        performSegueWithIdentifier("From Invalid Address To Order", sender: nil)
      }
    }
  }
}

extension InvalidAddressViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return order.orderableItemSets.count + 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    let orderableItemSets = order.orderableItemSets[orderItemSetIndex(with: section)]
    return orderableItemSets.orderableItems.count + kSectionCellCount
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension InvalidAddressViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if indexPath.section == 0 {
      return "alertCell"
    } else if indexPath.row == 0 {
      return kDeliveryTypeCellIdentifier
    } else if indexPath.row == 1 {
      return kShopNameCellIdentifier
    } else {
      return "optionProductCell"
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? DeliveryTypeCell {
      return cell.calculatedHeight(order.deliveryTypeCellHeight(orderItemSetIndex(with: indexPath.section)))
    } else if let cell = cell as? OrderableItemCell {
      let orderableItemSet = order.orderableItemSets[orderItemSetIndex(with: indexPath.section)]
      let orderableItem = orderableItemSet.orderableItems[indexPath.row - kSectionCellCount]
      return cell.calculatedHeight(orderableItem, selectedOption: orderableItem.selectedOption)
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeCell {
      cell.configureCell(order.orderableItemSets[orderItemSetIndex(with: indexPath.section)],
        needCell: order.deliveryTypeCellHeight(orderItemSetIndex(with: indexPath.section)))
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[orderItemSetIndex(with: indexPath.section)])
    } else if let cell = cell as? DeliveryOrderableItemCell, orderableCartItemIds = orderableCartItemIds {
      let orderableItemSet = order.orderableItemSets[orderItemSetIndex(with: indexPath.section)]
      let orderableItem = orderableItemSet.orderableItems[indexPath.row - kSectionCellCount]
      cell.configureCell(orderableItemSet, orderableItem: orderableItem, selectedOption: orderableItem.selectedOption, availableCartItemIds: orderableCartItemIds)
    }
  }
  
  func orderItemSetIndex(with section: Int) -> Int {
    return section - 1
  }
}

class DeliveryOrderableItemCell: OrderableItemCell {
  
  @IBOutlet weak var coverView: UIView!
  @IBOutlet weak var invalidOrderItemImageView: UIImageView!
  @IBOutlet weak var invalidOrderItemLabel: UILabel!
  
  func configureCell(orderableItemSet: OrderableItemSet, orderableItem: OrderableItem, selectedOption: ProductOptionSetList?, availableCartItemIds: [Int]) {
    super.configureCell(orderableItem, selectedOption: selectedOption)
    coverView.alpha = availableCartItemIds.contains(orderableItem.cartItemId!) ? 0 : 0.5
    invalidOrderItemImageView.configureAlpha(!availableCartItemIds.contains(orderableItem.cartItemId!))
    invalidOrderItemLabel.configureAlpha(!availableCartItemIds.contains(orderableItem.cartItemId!))
    if let deliveryTypeName = orderableItemSet.deliveryType.name {
      invalidOrderItemLabel.text = "\(deliveryTypeName)\n 불가 지역입니다."
    }
  }
  
  
}