
import UIKit

class MainTabViewController: UITabBarController {
  
  let locationList = LocationList()
  
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
  }
  
  @IBAction func product(sender: AnyObject) {
    showProductView(6)
  }
  
  @IBAction func cart(sender: AnyObject) {
    showViewController("Cart", viewIdentifier: "CartView")
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
