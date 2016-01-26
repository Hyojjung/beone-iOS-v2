
import UIKit

class AddingCouponViewController: BaseViewController {
  
  @IBOutlet weak var couponNumberTextField: UITextField!
  @IBOutlet weak var couponTextFieldBackgroundImageView: UIImageView!
  
  let coupon = Coupon()
  
  @IBAction func postCouponButtonTapped() {
    if couponNumberTextField.text != nil && !(couponNumberTextField.text!.isEmpty) {
      coupon.serialNumber = couponNumberTextField.text
      coupon.post({ (_) -> Void in
        self.popView()
        }) { (error) -> Void in
          var message: String?
          if error.statusCode == NetworkResponseCode.Duplicated.rawValue {
            message = NSLocalizedString("coupon conflict", comment: "alert title")
          } else if error.statusCode == NetworkResponseCode.Invalid.rawValue ||
            error.statusCode == NetworkResponseCode.NotFound.rawValue {
              message = NSLocalizedString("check coupon number", comment: "alert title")
          }
          if let message = message {
            self.showAlertView(message)
          }
      }
    } else {
      showAlertView(NSLocalizedString("input coupon number", comment: "alert title"))
    }
  }
}

extension AddingCouponViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    couponTextFieldBackgroundImageView.image = UIImage(named: kInputActiveImageName)
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    couponTextFieldBackgroundImageView.image = UIImage(named: kInputImageName)
  }
}