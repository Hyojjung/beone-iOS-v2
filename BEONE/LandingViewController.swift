
import UIKit

class LandingViewController: TemplatesViewController {
  
  lazy var advertisementViewController: AdvertisementViewController = {
    let deliveryTimeSelectViewController = AdvertisementViewController(nibName: "AdvertisementViewController",
                                                                            bundle: nil)
    deliveryTimeSelectViewController.modalPresentationStyle = .OverCurrentContext
    deliveryTimeSelectViewController.modalTransitionStyle = .CrossDissolve
    return deliveryTimeSelectViewController
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  // MARK: - BaseViewController
  
  override func setUpView() {
    super.setUpView()
    let advertisement = Advertisement()
    advertisement.get {
      if NSUserDefaults.standardUserDefaults().integerForKey(kNotShowingAdvertisementIdUserDefaultKey) != advertisement.id {
        self.advertisementViewController.advertisement = advertisement
        self.presentViewController(self.advertisementViewController, animated: true, completion: nil)
      }
    }
  }
  
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