
import UIKit
import SWRevealViewController

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
    BEONEManager.sharedLocationList.fetch()
  }
  
  @IBAction func signInButtonTapped() {
    showSigningView()
  }
  
  @IBAction func product(sender: AnyObject) {
    let product = Product()
    product.id = 6
    BEONEManager.selectedProduct = product
    
    showProductView()
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
