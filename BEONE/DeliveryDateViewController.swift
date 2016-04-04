
import UIKit

class DeliveryDateViewController: BaseTableViewController {
  
  let order: Order = {
    let order = Order()
    order.isDone = false
    return order
  }()
  var selectedOrderableItemSetIndex = 0
  var selectedDates = [Int: NSDate]()
  var selectedTimeRanges = [Int: AvailableTimeRange]()
  
  lazy var deliveryTimeSelectViewController: DeliveryTimeSelectViewController = {
    let deliveryTimeSelectViewController = DeliveryTimeSelectViewController(nibName: "DeliveryTimeSelectViewController",
                                                                            bundle: nil)
    deliveryTimeSelectViewController.delegate = self
    deliveryTimeSelectViewController.modalPresentationStyle = .OverCurrentContext
    deliveryTimeSelectViewController.modalTransitionStyle = .CrossDissolve
    return deliveryTimeSelectViewController
  }()
  
  lazy var calendarViewController: CalendarViewController = {
    let calendarViewController = CalendarViewController()
    calendarViewController.delegate = self
    calendarViewController.modalPresentationStyle = .OverCurrentContext
    calendarViewController.modalTransitionStyle = .CrossDissolve
    return calendarViewController
  }()
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let orderAddressViewController = segue.destinationViewController as? OrderAddressViewController {
      orderAddressViewController.order = order
    }
  }
  
  override func setUpData() {
    super.setUpData()
    OrderHelper.fetchOrderableInfo(order) {
      if let selectedDate = BEONEManager.selectedDate {
        self.selectedDates[self.selectedOrderableItemSetIndex] =
          DateFormatterHelper.koreanCalendar.dateFromComponents(selectedDate)
      }
      
      var needReservation = false
      
      for orderableItemSet in self.order.orderableItemSets {
        if orderableItemSet.deliveryType.isReservable {
          needReservation = true
        }
      }
      
      if !needReservation {
        self.orderButtonTapped()
      }
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
}

// MARK: - Actions

extension DeliveryDateViewController {
  
  @IBAction func selectExpressButtonTapped(sender: UIButton) {
    order.orderableItemSets[sender.tag].isExpressReservation = true
    tableView.reloadData()
  }
  
  @IBAction func selectDeliveryTimeButtonTapped(sender: UIButton) {
    order.orderableItemSets[sender.tag].isExpressReservation = false
    tableView.reloadData()
  }
  
  @IBAction func showCalenderButtonTapped(sender: UIButton) {
    selectedOrderableItemSetIndex = sender.tag
    calendarViewController.selectedDate = selectedDates[selectedOrderableItemSetIndex]
    presentViewController(calendarViewController, animated: true, completion: nil)
  }
  
  @IBAction func selectTimeButtonTapped(sender: UIButton) {
    selectedOrderableItemSetIndex = sender.tag
    if selectedDates[selectedOrderableItemSetIndex] != nil {
      deliveryTimeSelectViewController.availableTimeRanges = availableTimeRanges()
      deliveryTimeSelectViewController.selectedTimeRange = selectedTimeRanges[selectedOrderableItemSetIndex]
      presentViewController(deliveryTimeSelectViewController, animated: true, completion: nil)
    } else {
      showAlertView("희망배송일을 선택해주세요.")
    }
  }
  
  @IBAction func orderButtonTapped() {
    for (index, orderableItemSet) in order.orderableItemSets.enumerate() {
      if orderableItemSet.deliveryType.isReservable {
        if (!orderableItemSet.isExpressAvailable || !orderableItemSet.isExpressReservation)
          && (selectedDates[index] == nil || selectedTimeRanges[index] == nil) {
          showAlertView(NSLocalizedString("select delivery date", comment: "alert title"))
          return
        }
      }
      if orderableItemSet.deliveryType.isReservable && !orderableItemSet.isExpressReservation {
        orderableItemSet.selectedTimeRange = selectedTimeRanges[index]
      }
    }
    performSegueWithIdentifier("From Date Seletor To Order Address", sender: nil)
  }
  
  func availableTimeRanges() -> [AvailableTimeRange] {
    if let selectedDate = selectedDates[selectedOrderableItemSetIndex] {
      let selectedOrderableItemSet = order.orderableItemSets[selectedOrderableItemSetIndex]
      return selectedOrderableItemSet.availableTimeRanges.availableDeliveryRanges(selectedDate)
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
      print(date)
      selectedDates[selectedOrderableItemSetIndex] = date
      selectedTimeRanges[selectedOrderableItemSetIndex] = nil
      tableView.reloadData()
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func dateIsAble(date: NSDate) -> Bool {
    for ableDate in order.orderableItemSets[selectedOrderableItemSetIndex].availableTimeRanges.availableDeliveryDates() {
      let dateComponent = date.dateComponent()
      if dateComponent.month == ableDate.month && dateComponent.day == ableDate.day {
        return true
      }
    }
    return false
  }
}

extension DeliveryDateViewController: TimeSelectViewDelegate {
  func selectTimeRangeButtonTapped(index: Int) {
    selectedTimeRanges[selectedOrderableItemSetIndex] = availableTimeRanges()[index]
    dismissViewControllerAnimated(true, completion: nil)
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
      if orderableItemSet.deliveryType.isReservable {
        return orderableItemSet.orderableItems.list.count + 5
      } else {
        return orderableItemSet.orderableItems.list.count + 3
      }
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension DeliveryDateViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if indexPath.section < order.orderableItemSets.count {
      let orderableItemSet = order.orderableItemSets[indexPath.section]
      if indexPath.row == 0 {
        return kDeliveryTypeCellIdentifier
      } else if indexPath.row == 1 {
        return kShopNameCellIdentifier
      } else if indexPath.row == orderableItemSet.orderableItems.list.count + 2 {
        if orderableItemSet.deliveryType.isReservable {
          if orderableItemSet.isExpressAvailable {
            return "deliveryDateTypeCell"
          } else {
            return "emptyCell"
          }
        } else {
          return "parcelLabelCell"
        }
      } else if indexPath.row == orderableItemSet.orderableItems.list.count + 3 {
        if !orderableItemSet.isExpressReservation {
          return "timeCell"
        } else {
          return "emptyCell"
        }
      } else if indexPath.row == orderableItemSet.orderableItems.list.count + 4 {
        return "alertCell"
      } else {
        return "orderOrderableItemCell"
      }
    } else {
      return "buttonCell"
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if cell is OrderOrderableItemCell {
      return 97
    } else if cell.reuseIdentifier == kDeliveryTypeCellIdentifier {
      return 60
    } else if cell.reuseIdentifier == "timeCell" {
      return 157
    } else if cell.reuseIdentifier == "alertCell" {
      return 50
    } else if cell.reuseIdentifier == "buttonCell" {
      return 97
    } else if cell.reuseIdentifier == "deliveryDateTypeCell" {
      return 60
    } else if let cell = cell as? DeliveryTypeCell {
      return cell.calculatedHeight(order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? ParcelLabelCell {
      return cell.calculatedHeight()
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
                         needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? OrderOrderableItemCell,
      orderItems = order.orderableItemSets[indexPath.section].orderableItems.list as? [OrderableItem] {
      cell.configureCell(orderItems[indexPath.row - 2])
    } else if let cell = cell as? TimeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section], index: indexPath.section,
                         selectedDate: selectedDates[indexPath.section], selectedTimeRange: selectedTimeRanges[indexPath.section])
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[indexPath.section])
    } else if let cell = cell as? DeliveryDateTypeCell {
      cell.setUpCell(order.orderableItemSets[indexPath.section].isExpressReservation, index: indexPath.section)
    }
  }
}

class DeliveryDateTypeCell: UITableViewCell {
  
  @IBOutlet weak var expressButton: UIButton!
  @IBOutlet weak var expressCheckImageView: UIImageView!
  @IBOutlet weak var timeButton: UIButton!
  @IBOutlet weak var timeCheckImageView: UIImageView!
  
  func setUpCell(isExpress: Bool, index: Int) {
    expressButton.selected = isExpress
    timeButton.selected = !isExpress
    expressCheckImageView.configureAlpha(isExpress)
    timeCheckImageView.configureAlpha(!isExpress)
    expressButton.tag = index
    timeButton.tag = index
  }
}

class OrderOrderableItemCell: UITableViewCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productCountLabel: UILabel!
  @IBOutlet weak var productOptionLabel: UILabel!
  
  func configureCell(orderableItem: OrderableItem) {
    productImageView.setLazyLoaingImage(orderableItem.product.mainImageUrl)
    productNameLabel.text = orderableItem.product.title
    productCountLabel.text = "\(orderableItem.quantity) 개"
    productOptionLabel.text = orderableItem.selectedOption?.optionString()
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

class ParcelLabelCell: UITableViewCell {
  func calculatedHeight() -> CGFloat {
    let optionLabel = UILabel()
    optionLabel.font = UIFont.systemFontOfSize(14)
    optionLabel.text = "본 상품은 택배배송 상품입니다. 출고일은 상품에 따라 다릅니다."
    optionLabel.setWidth(ViewControllerHelper.screenWidth - 30)
    
    return optionLabel.frame.height + 43
  }
}