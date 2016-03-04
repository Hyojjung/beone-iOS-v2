
import UIKit

class MoreViewController: BaseViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  @IBAction func showProfileViewButtonTapped() {
    showViewController(kProfileStoryboardName, viewIdentifier: kProfileViewViewIdentifier)
  }
  
  @IBAction func showNoticesViewButtonTapped() {
    showViewController(.Notice)
  }
  
  @IBAction func showHelpViewButtonTapped() {
    showViewController(.Help)
  }
  
  @IBAction func showCouponViewButtonTapped() {
    showUserViewController("Coupon", viewIdentifier: "CouponView")
  }
  
  @IBAction func showSettingViewButtonTapped() {
    showViewController("Setting", viewIdentifier: "SettingView")
  }
  @IBAction func showOrdersViewButtonTapped() {
    showUserViewController(kOrdersStoryboardName, viewIdentifier: kOrdersViewNibName)
  }
}

extension MoreViewController: SideBarPositionMoveDelegate {
  
  func handlemovePosition() {
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}
