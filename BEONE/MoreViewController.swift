
import UIKit

class MoreViewController: BaseViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  @IBAction func showProfileViewButtonTapped() {
    showViewController(.Profile)
  }
  
  @IBAction func showNoticesViewButtonTapped() {
    showViewController(.Notice)
  }
  
  @IBAction func showHelpViewButtonTapped() {
    showViewController(.Help)
  }
  
  @IBAction func showCouponViewButtonTapped() {
    showViewController(.Coupons)
  }
  
  @IBAction func showSettingViewButtonTapped() {
    showViewController(.Setting)
  }
  @IBAction func showOrdersViewButtonTapped() {
    showViewController(.Orders)
  }
}

extension MoreViewController: SideBarPositionMoveDelegate {
  
  func handlemovePosition() {
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}
