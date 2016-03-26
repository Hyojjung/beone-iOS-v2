
import UIKit

let darkGold = UIColor(red: 149.0 / 255.0, green: 131.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0)
let pinkishGrey = UIColor(red: 192.0 / 255.0, green: 175.0 / 255.0, blue: 157.0 / 255.0, alpha:1.0)
let gold = UIColor(red: 175.0 / 255.0, green: 152.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
let lightGold = UIColor(red: 246.0 / 255, green: 239.0 / 255, blue: 232.0 / 255, alpha: 1.0)
let grey = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
let blueGrey = UIColor(red:68.0 / 255, green:68.0 / 255, blue:68.0 / 255, alpha:1)
let bgColor = UIColor(red:241.0 / 255, green:238.0 / 255, blue:234.0 / 255, alpha:1)
let taupe = UIColor(red:186.0 / 255, green:160.0 / 255, blue:130.0 / 255, alpha:1)
let warmGrey = UIColor(red:158.0 / 255, green:158.0 / 255, blue:158.0 / 255, alpha:1)
let productPropertyValueButtonColor = UIColor(red:241.0 / 255, green:236.0 / 255, blue:230.0 / 255, alpha:1)
let selectedProductPropertyValueButtonColor = UIColor(red:208.0 / 255, green:165.0 / 255, blue:114.0 / 255, alpha:1)

let kTableViewDefaultHeight = CGFloat(44)
let kCollectionViewDefaultSize = CGSize(width: ViewControllerHelper.screenWidth, height: kTableViewDefaultHeight)

let kInputActiveImageName = "inputActive"
let kInputImageName = "input"
let kImagePaymentCancelImageName = "image_payment_cancel"
let kImagePaymentFailImageName = "image_payment_fail"
let kImagePaymentSuccessImageName = "image_payment_success"
let kimagePostThumbnail = "image_post_thumbnail"

extension UILabel {
  func setWidth(width: CGFloat) {
    var labelFrame = frame
    labelFrame.size.width = width
    numberOfLines = 0
    frame = labelFrame
    sizeToFit()
  }
}

extension UIView {
  func configureAlpha(condition: Bool) {
    alpha = condition ? 1 : 0
    if let button = self as? UIButton {
      button.enabled = condition
    }
  }
}