
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
}
