
import UIKit

class NetworkErrorViewController: UIViewController {
  
  var showing = false
  
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
