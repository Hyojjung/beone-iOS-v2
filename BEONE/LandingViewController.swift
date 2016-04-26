
import UIKit

class LandingViewController: TemplatesViewController {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needSetTitle = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  // MARK: - BaseViewController
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.setUpData),
      name: kNotificationGuestAuthenticationSuccess, object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationGuestAuthenticationSuccess, object: nil)
  }
  
  @IBAction func showSpeedOrder() {
    showViewController(.SpeedOrder)
  }
}

extension LandingViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}