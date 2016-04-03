
import UIKit

class MainTabViewController: UITabBarController {
  
  let locationList = LocationList()
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
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(setUpData),
                                                     name: kNotificationGuestAuthenticationSuccess, object: nil)
    mainTitleView.delegate = self
    navigationItem.titleView = mainTitleView
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setUpData()
  }
  
  func setUpData() {
    BEONEManager.sharedLocationList.get { () -> Void in
      self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
    }
    BEONEManager.globalViewContents.get()
  }
  
  @IBAction func cart(sender: AnyObject) {
    SchemeHelper.setUpScheme("/cart")
  }
  
  @IBAction func toggleRevealViewPositionButtonTapped(sender: UIBarButtonItem) {
    self.revealViewController().revealToggleAnimated(true)
  }
}

extension MainTabViewController: MainTitleViewDelegate {
  func locationButtonTapped() {
    showLocationPicker { (selectedIndex) -> Void in
      BEONEManager.selectedLocation = BEONEManager.sharedLocationList.list[selectedIndex] as? Location
      self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
    }
  }
}
