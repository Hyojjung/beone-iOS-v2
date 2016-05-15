
import UIKit

class AddingCouponViewController: BaseViewController {
  
  @IBOutlet weak var couponNumberTextField: UITextField!
  
  let coupon = Coupon()
  
  @IBAction func postCouponButtonTapped() {
    endEditing()
    if couponNumberTextField.text != nil && !(couponNumberTextField.text!.isEmpty) {
      coupon.serialNumber = couponNumberTextField.text
      coupon.post({ (_) -> Void in
        self.popView()
        }) { (error) -> Void in
          var message: String?
          if error.statusCode == NetworkResponseCode.Duplicated {
            message = NSLocalizedString("coupon conflict", comment: "alert title")
          } else if error.statusCode == NetworkResponseCode.Invalid ||
            error.statusCode == NetworkResponseCode.NotFound {
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
    textField.background = UIImage(named: kInputActiveImageName)
    return true
  }
}