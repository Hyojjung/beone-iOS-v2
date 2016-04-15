
import UIKit

class OrderResultView: UIView {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel!
  @IBOutlet weak var usedPointLabel: UILabel!
  @IBOutlet weak var usedCouponLabel: UILabel!
  
  func layoutView(order: Order, paymentInfo: PaymentInfo) {
    priceLabel.text = paymentInfo.actualPrice.priceNotation(.Korean)
    deliveryDateLabel.text = order.deliveryDateString()
    usedPointLabel.text = order.usedPoint?.priceNotation(.Korean)
    if let coupon = order.usedCoupon, couponName = coupon.title {
      if order.discountPrice != 0 && order.discountPrice != order.usedPoint {
        usedCouponLabel.text = "\(couponName) - \(order.discountPrice.priceNotation(.Korean))"
      }
    } else {
      usedCouponLabel.text = "0 원"
    }
  }
}