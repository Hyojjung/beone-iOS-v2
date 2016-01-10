
import UIKit

class DeliveryDateViewController: BaseTableViewController {
  
  var order = Order()
  var orderingCartItemIds = [Int]()
  var selectedOrderableItemSetIndex = 0
  var selectedDates = [Int: NSDate]()
  var selectedTimeRanges = [Int: AvailableTimeRange]()
  var timeSelectView: TimeSelectView?
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let orderAddressViewController = segue.destinationViewController as? OrderAddressViewController {
      orderAddressViewController.order = order
    }
  }
  
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
  
  @IBAction func showCalenderButtonTapped(sender: UIButton) {
    selectedOrderableItemSetIndex = sender.tag
    calendarView.selectedDate = selectedDates[selectedOrderableItemSetIndex]
    view.addSubview(calendarView)
    calendarView.center = CGPointMake(view.center.x, view.center.y)
  }
  
  @IBAction func selectTimeButtonTapped(sender: UIButton) {
    selectedOrderableItemSetIndex = sender.tag
    if selectedDates[selectedOrderableItemSetIndex] != nil {
      let availableTimeRanges = self.availableTimeRanges()
      timeSelectView = TimeSelectView()
      timeSelectView?.delegate = self
      timeSelectView?.layoutView(availableTimeRanges, selectedTimeRange: selectedTimeRanges[selectedOrderableItemSetIndex])
      view.addSubViewAndEnableAutoLayout(timeSelectView!)
      view.addTopLayout(timeSelectView!, constant: 64)
      view.addLeadingLayout(timeSelectView!)
      view.addTrailingLayout(timeSelectView!)
    }
  }
  
  @IBAction func orderButtonTapped() {
    for (index, orderableItemSet) in order.orderableItemSets.enumerate() {
      if orderableItemSet.deliveryType.isReservable &&
        (selectedDates[index] == nil || selectedTimeRanges[index] == nil) {
          showAlertView(NSLocalizedString("select delivery date", comment: "alert title"))
          return
      } else if orderableItemSet.deliveryType.isReservable {
        orderableItemSet.selectedTimeRange = selectedTimeRanges[index]
      }
    }
    performSegueWithIdentifier("From Date Seletor To Order Address", sender: nil)
  }
  
  func availableTimeRanges() -> [AvailableTimeRange] {
    if let selectedDate = selectedDates[selectedOrderableItemSetIndex] {
      let selectedOrderableItemSet = order.orderableItemSets[selectedOrderableItemSetIndex]
      return selectedOrderableItemSet.availableTimeRangeList.availableDeliveryRanges(selectedDate)
    }
    fatalError("no time ranges at selected index")
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
    if date != nil && selectedDates[selectedOrderableItemSetIndex] != date {
      selectedDates[selectedOrderableItemSetIndex] = date
      selectedTimeRanges[selectedOrderableItemSetIndex] = nil
      tableView.reloadData()
    }
    calendarView.removeFromSuperview()
  }
  
  func dateIsAble(date: NSDate) -> Bool {
    for ableDate in order.orderableItemSets[selectedOrderableItemSetIndex].availableTimeRangeList.availableDeliveryDates() {
      let dateComponent = date.dateComponent()
      if dateComponent.0 == ableDate.0 && dateComponent.1 == ableDate.1 {
        return true
      }
    }
    return false
  }
  
  // TODO: - time zone check
}

extension DeliveryDateViewController: TimeSelectViewDelegate {
  func selectTimeRangeButtonTapped(index: Int) {
    selectedTimeRanges[selectedOrderableItemSetIndex] = availableTimeRanges()[index]
    timeSelectView?.removeFromSuperview()
    tableView.reloadData()
  }
}

extension DeliveryDateViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return order.orderableItemSets.count + 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section < order.orderableItemSets.count {
      let orderableItemSet = order.orderableItemSets[section]
      return orderableItemSet.deliveryType.isReservable ?
        orderableItemSet.orderableItems.count + 4 : orderableItemSet.orderableItems.count + 3
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension DeliveryDateViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if indexPath.section < order.orderableItemSets.count {
      let orderableItemSet = order.orderableItemSets[indexPath.section]
      if indexPath.row == 0 {
        return kDeliveryTypeCellIdentifier
      } else if indexPath.row == 1 {
        return kShopNameCellIdentifier
      } else if indexPath.row == orderableItemSet.orderableItems.count + 2 {
        return orderableItemSet.deliveryType.isReservable ? "timeCell" : "parcelLabelCell"
      } else if indexPath.row == orderableItemSet.orderableItems.count + 3 {
        return "alertCell"
      } else {
        return "itemCell"
      }
    } else {
      return "buttonCell"
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
        needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? OrderItemCell {
      cell.configureCell(order.orderableItemSets[indexPath.section].orderableItems[indexPath.row - 2])
    } else if let cell = cell as? TimeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section], index: indexPath.section,
        selectedDate: selectedDates[indexPath.section], selectedTimeRange: selectedTimeRanges[indexPath.section])
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
  
  func configureCell(orderableItemSet: OrderableItemSet, index: Int,
    selectedDate: NSDate?, selectedTimeRange: AvailableTimeRange?) {
      dateButton.tag = index
      timeButton.tag = index
      dateLabel.text = selectedDate != nil ?
        selectedDate!.rangeReservationDateString() :
        NSLocalizedString("select delivery date", comment: "button title")
      timeLabel.text = selectedTimeRange != nil ?
        selectedTimeRange!.timeRangeNotation() :
        NSLocalizedString("select time range", comment: "button title")
  }
}