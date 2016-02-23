
import UIKit

class MoreViewController: BaseViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
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
    showUserViewController("Coupon", viewIdentifier: "CouponView")
  }
  
  @IBAction func showSettingViewButtonTapped() {
    showViewController("Setting", viewIdentifier: "SettingView")
  }
  @IBAction func showOrdersViewButtonTapped() {
    showUserViewController(kOrderListStoryboardName, viewIdentifier: kOrdersViewNibName)
  }
}

extension MoreViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    view.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}
