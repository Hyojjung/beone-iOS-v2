
import UIKit

class MainTabViewController: UITabBarController {
  
  let locations = Locations()
  var selectingIndex = 0
  private var isWaitingSigning = false
  private var signingShowViewController: UIViewController? = nil
  private var mainTitleView = UIView.loadFromNibName(kMainTitleViewNibName) as! MainTitleView

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self,
                                                        name: kNotificationGuestAuthenticationSuccess,
                                                        object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(setUpData),
                                                     name: kNotificationGuestAuthenticationSuccess, object: nil)
    if NSUserDefaults.standardUserDefaults().objectForKey(kVisited)?.boolValue != true {
      presentViewController(WelcomeViewController(), animated: true, completion: nil)
    }
    mainTitleView.delegate = self
    navigationItem.titleView = mainTitleView
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setUpData()
  }
  
  func setUpData() {
    BEONEManager.sharedLocations.get { 
      self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
    }
    BEONEManager.globalViewContents.get()
  }
  
  @IBAction func cart(sender: AnyObject) {
    SchemeHelper.setUpScheme("current/cart")
  }
  
  @IBAction func toggleRevealViewPositionButtonTapped(sender: UIBarButtonItem) {
    self.revealViewController().revealToggleAnimated(true)
  }
}

extension MainTabViewController: UITabBarControllerDelegate {
  func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    mainTitleView.viewTitleLabel.text = viewController.title
  }
  
  func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    for (index, viewControllerss) in viewControllers!.enumerate() {
      if viewControllerss == viewController {
        selectingIndex = index
      }
    }
    return true
  }
}

extension MainTabViewController: MainTitleViewDelegate {
  func locationButtonTapped() {
    showLocationPicker { (selectedIndex) -> Void in
      BEONEManager.selectedLocation = BEONEManager.sharedLocations.list[selectedIndex] as? Location
      self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
      if let selectedViewController = self.selectedViewController as? BaseViewController {
        selectedViewController.setUpData()
      }
    }
  }
}
