
import UIKit

class NetworkErrorViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  var showing = false
  var networkError = true
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    label.text = networkError ? "네트워크 상태를 확인 해 주세요" : "서버 점검 중 입니다."
  }
  
  @IBAction func retryButtonTapped() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: {
      if let topMostViewController = ViewControllerHelper.topMostViewController() as? BaseViewController {
        topMostViewController.setUpData()
      }
      #if DEBUG
      if ViewControllerHelper.topMostViewController() is NetworkErrorViewController {
        ViewControllerHelper.topRootViewController()?.showAlertView("needSetUpData")
      }
      #endif
      self.showing = false
    })
  }
}
