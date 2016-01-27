
import UIKit

class MoreViewController: BaseViewController {

  @IBAction func showProfileViewButtonTapped() {
    showViewController(kProfileStoryboardName, viewIdentifier: kProfileViewViewIdentifier)
  }
  
  @IBAction func showNoticeViewButtonTapped() {
    showViewController("Notice", viewIdentifier: "NoticeView")
  }
  
  @IBAction func showHelpViewButtonTapped() {
    showViewController("Help", viewIdentifier: "HelpView")
  }
  
  @IBAction func showCouponViewButtonTapped() {
    showViewController("Coupon", viewIdentifier: "CouponView")
  }
  
  @IBAction func showSettingViewButtonTapped() {
    showViewController("Setting", viewIdentifier: "SettingView")
  }
  @IBAction func showOrdersViewButtonTapped() {
    showViewController("OrderList", viewIdentifier: "OrdersView")
  }
}
