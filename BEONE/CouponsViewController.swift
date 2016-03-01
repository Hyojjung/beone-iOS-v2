
import UIKit

class CouponsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum CouponTableViewSection: Int {
    case CouponRegistration
    case UsableTitle
    case NoUsableCoupon
    case UsableCoupon
    case UnusableTitle
    case NoUnusableCoupon
    case UnusableCoupon
    case More
    case Count
  }
  
  private let kCouponTableViewCellIdentifiers = [
    "couponRegistrationCell",
    "usableTitleCell",
    "noUsableCouponCell",
    "couponCell",
    "unusableTitleCell",
    "noUnusableCouponCell",
    "couponCell",
    "moreCell"]
  
  var isMoreShow = false
  
  lazy var usableCouponList: CouponList = {
    let couponList = CouponList()
    couponList.isUsableCouponList = true
    return couponList
  }()
  var unusableCouponList = CouponList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    usableCouponList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  @IBAction func moreShowButtonTapped() {
    isMoreShow = true
    unusableCouponList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
}

extension CouponsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CouponTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? CouponCell, coupon = self.coupon(indexPath) {
      cell.configureCell(coupon)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !isMoreShow {
      if section == CouponTableViewSection.UnusableTitle.rawValue ||
        section == CouponTableViewSection.NoUnusableCoupon.rawValue ||
        section == CouponTableViewSection.UnusableCoupon.rawValue {
          return 0
      }
    } else if section == CouponTableViewSection.More.rawValue {
      return 0
    }
    if (usableCouponList.list.count != 0 && section == CouponTableViewSection.NoUsableCoupon.rawValue) ||
      (unusableCouponList.list.count != 0 && section == CouponTableViewSection.NoUnusableCoupon.rawValue) {
        return 0
    } else if section == CouponTableViewSection.UsableCoupon.rawValue {
      return usableCouponList.list.count
    } else if section == CouponTableViewSection.UnusableCoupon.rawValue {
      return unusableCouponList.list.count
    }
    return 1
  }
  
  func coupon(indexPath: NSIndexPath) -> Coupon? {
    if indexPath.section == CouponTableViewSection.UsableCoupon.rawValue {
      return usableCouponList.list[indexPath.row] as? Coupon
    } else if indexPath.section == CouponTableViewSection.UnusableCoupon.rawValue {
      return unusableCouponList.list[indexPath.row] as? Coupon
    }
    return nil
  }
}

extension CouponsViewController: DynamicHeightTableViewDelegate {
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let section = CouponTableViewSection(rawValue: indexPath.section) {
      switch (section) {
      case .UsableCoupon, .UnusableCoupon:
        if let cell = cell as? CouponCell, coupon = self.coupon(indexPath) {
          return cell.calculatedHeight(coupon)
        }
      case .CouponRegistration:
        return 145
      case .UsableTitle, .UnusableTitle, .NoUnusableCoupon, .NoUsableCoupon:
        return 59
      case .More:
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