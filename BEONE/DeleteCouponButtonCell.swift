
import UIKit

class DeleteCouponButtonCell: UITableViewCell {

  weak var delegate: CouponDelegate?
  
  @IBAction func deleteButtonTapped() {
    delegate?.deleteCouponButtonTapped()
  }
}
