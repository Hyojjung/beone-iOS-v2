
import UIKit

class DeliveryDateViewController: BaseTableViewController {
  var order = Order()
  var orderingCartItemIds = [Int]()
  var selectedOrderableItemSetIndex: Int?
  var selectedDates = [Int: NSDate]()
  var selectedTimeRange = [Int: NSDate]()
  
  override func setUpData() {
    super.setUpData()
    OrderHelper.fetchOrderableInfo(orderingCartItemIds, order: order) { self.tableView.reloadData() }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  lazy var calendarView: CKCalendarView = {
    let calendarView = CKCalendarView(viewWidth: ViewControllerHelper.screenWidth - 20)
    calendarView.delegate = self
    calendarView.setMonthButtonColor(lightGold)
    calendarView.titleColor = lightGold
    return calendarView
  }()
  
  @IBAction func showCalenderButtonTapped(sender: AnyObject) {
    selectedOrderableItemSetIndex = sender.tag
    calendarView.selectedDate = selectedDates[selectedOrderableItemSetIndex!]
    view.addSubview(calendarView)
    calendarView.center = CGPointMake(view.center.x, view.center.y)
  }
}

extension DeliveryDateViewController: CKCalendarDelegate {
  func calendar(calendar: CKCalendarView!, configureDateItem dateItem: CKDateItem!, forDate date: NSDate!) {
    if dateIsAble(date) {
      dateItem.backgroundColor = gold
      dateItem.textColor = lightGold
    } else {
      dateItem.backgroundColor = lightGold
      dateItem.textColor = blueGrey
    }
  }
  
  func calendar(calendar: CKCalendarView!, willSelectDate date: NSDate!) -> Bool {
    return dateIsAble(date)
  }
  
  func calendar(calendar: CKCalendarView!, didSelectDate date: NSDate!) {
    if let index = selectedOrderableItemSetIndex {
      if selectedDates[index] != date {
        selectedDates[index] = date
        selectedTimeRange[index] = nil
        tableView.reloadSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
      }
    }
    calendarView.removeFromSuperview()
  }
  
  func dateIsAble(date: NSDate) -> Bool {
    if let index = selectedOrderableItemSetIndex, dateComponent = date.dateComponent() {
      for ableDate in order.orderableItemSets[index].availableTimeRangeList.availableDeliveryDates() {
        if dateComponent.0 == ableDate.0 && dateComponent.1 == ableDate.1 {
          return true
        }
      }
    }
    return false
  }
  
  // TODO: - time zone check
}

extension DeliveryDateViewController: UITableViewDataSource {
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
    configure(cell, indexPath: indexPath)
    return cell
  }
  

}

extension DeliveryDateViewController: DynamicHeightTableViewProtocol {
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
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeImageCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
        needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? OrderItemCell {
      cell.configureCell(order.orderableItemSets[indexPath.section].orderableItems[indexPath.row - 2])
    } else if let cell = cell as? TimeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section], index: indexPath.section, selectedDate: selectedDates[indexPath.section])
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[indexPath.section])
    }
  }
}

class OrderItemCell: UITableViewCell {
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productCountLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  func configureCell(orderableItem: OrderableItem) {
    productImageView.setLazyLoaingImage(orderableItem.product.mainImageUrl)
    productNameLabel.text = orderableItem.product.title
    if let quantity = orderableItem.quantity {
      productCountLabel.text = "\(quantity) 개"
    }
    productPriceLabel.text = orderableItem.price?.priceNotation(.Korean)
  }
}

class TimeCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var dateButton: UIButton!
  @IBOutlet weak var timeButton: UIButton!
  
  func configureCell(orderableItemSet: OrderableItemSet, index: Int, selectedDate: NSDate?) {
    dateButton.tag = index
    timeButton.tag = index
    dateLabel.text = selectedDate?.rangeReservationDateString()
  }
}
