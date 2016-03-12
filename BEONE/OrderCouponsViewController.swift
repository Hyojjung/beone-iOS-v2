
import UIKit

class OrderCouponsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum CouponTableViewSection: Int {
    case NoCoupon
    case Coupon
    case DeleteCouponButton
    case Count
  }
  
  private let kCouponTableViewCellIdentifiers = [
    "noUsableCouponCell",
    "couponCell",
    "deleteCouponButtonCell"]
  
  var couponList = CouponList()
  var order: Order?
  var delegate: CouponDelegate?

  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    if let order = order {
      OrderHelper.fetchAvailableCoupons(order.cartItemIds, couponList: couponList, getSuccess: { () -> Void in
        self.tableView.reloadData()
      })
    }
  }
}

extension OrderCouponsViewController: CouponDelegate {
  func selectCouponButtonTapped(coupon: Coupon) {
    delegate?.selectCouponButtonTapped(coupon)
    popView()
  }
}

extension OrderCouponsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CouponTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? CouponCell, coupon = couponList.list[indexPath.row] as? Coupon {
      cell.configureCell(coupon)
      cell.delegate = self
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if couponList.list.count != 0 && section == CouponTableViewSection.NoCoupon.rawValue {
      return 0
    } else if section == CouponTableViewSection.Coupon.rawValue {
      return couponList.list.count
    }
    return 1
  }
}

extension OrderCouponsViewController: DynamicHeightTableViewDelegate {
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let section = CouponTableViewSection(rawValue: indexPath.section) {
      switch (section) {
      case .Coupon:
        if let cell = cell as? CouponCell, coupon = couponList.list[indexPath.row] as? Coupon {
          return cell.calculatedHeight(coupon)
        }
      case .NoCoupon:
        return 59
      case .DeleteCouponButton:
        return 45
      default: break
      }
    }
    return nil
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kCouponTableViewCellIdentifiers[indexPath.section]
  }
}