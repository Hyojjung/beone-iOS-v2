
import UIKit

protocol MainTitleViewDelegate: NSObjectProtocol {
  func locationButtonTapped()
}

class MainTitleView: UIView {
  
  weak var delegate: MainTitleViewDelegate?
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var viewTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    locationLabel.text = MyInfo.sharedMyInfo().locationName
  }

  @IBAction func locationButtonTapped(sender: AnyObject) {
    if BEONEManager.sharedLocations.list.count != 0 {
      delegate?.locationButtonTapped()
    }
  }
}
