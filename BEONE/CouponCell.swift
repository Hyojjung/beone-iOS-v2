
import UIKit

class CouponCell: UITableViewCell {
  
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var expiredDateLabel: UILabel!
  @IBOutlet weak var usableDayLabel: UILabel!
  @IBOutlet weak var serialNumberLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  func configureCell(coupon: Coupon) {
    subTitleLabel.text = coupon.subTitle
    titleLabel.text = coupon.title
    serialNumberLabel.text = coupon.serialNumber
    summaryLabel.text = coupon.summary
    usableDayLabel.text = coupon.dayLeft
    if let expiredAt = coupon.expiredAt {
      expiredDateLabel.text = "~ \(expiredAt.briefDateString())"
    }
  }
  
  func calculatedHeight(coupon: Coupon) -> CGFloat {
    let subTitleLabel = UILabel()
    subTitleLabel.font = UIFont.systemFontOfSize(14)
    subTitleLabel.text = coupon.subTitle
    subTitleLabel.setWidth(ViewControllerHelper.screenWidth - 64)
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFontOfSize(25)
    titleLabel.text = coupon.title
    titleLabel.setWidth(ViewControllerHelper.screenWidth - 64)
    
    let summaryLabel = UILabel()
    summaryLabel.font = UIFont.systemFontOfSize(12)
    summaryLabel.text = coupon.summary
    summaryLabel.setWidth(ViewControllerHelper.screenWidth - 64)
    
    return CGFloat(140) + subTitleLabel.frame.height + titleLabel.frame.height + summaryLabel.frame.height
  }
}