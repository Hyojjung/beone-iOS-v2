
import UIKit

class MainTabViewController: UITabBarController {
  
  let locationList = LocationList()
  private var isWaitingSigning = false
  private var signingShowViewController: UIViewController? = nil

  private var mainTitleView = UIView.loadFromNibName(kMainTitleViewNibName) as! MainTitleView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainTitleView.delegate = self
    navigationItem.titleView = mainTitleView
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    BEONEManager.sharedLocationList.get { () -> Void in
      self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
    }
    
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = nil
      if isWaitingSigning {
        popView()
      } else {
        isWaitingSigning = true
      }
    } else if let signingShowViewController = signingShowViewController {
      showViewController(signingShowViewController, sender: nil)
      self.signingShowViewController = nil
    }
  }
  
  func showUserViewController(storyboardName: String, viewIdentifier: String) {
    let viewController = self.viewController(storyboardName, viewIdentifier: viewIdentifier)
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = viewController
      showSigningView()
    } else {
      showViewController(viewController, sender: nil)
    }
  }
  
  @IBAction func product(sender: AnyObject) {
    showProductView(6)
  }
  
  @IBAction func cart(sender: AnyObject) {
    showUserViewController("Cart", viewIdentifier: "CartView")
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
