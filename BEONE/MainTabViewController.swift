
import UIKit

class MainTabViewController: BaseTableViewController {

  let locationList = LocationList()
  
  private var mainTitleView = UIView.loadFromNibName(kMainTitleViewNibName) as! MainTitleView

  override func setUpView() {
    super.setUpView()
    mainTitleView.delegate = self
    navigationItem.titleView = mainTitleView
  }
  
  override func setUpData() {
    super.setUpData()
    BEONEManager.sharedLocationList.fetch()
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
