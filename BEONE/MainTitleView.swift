
import UIKit

protocol MainTitleViewDelegate: NSObjectProtocol {
  func locationButtonTapped()
}

class MainTitleView: UIView {
  
  weak var delegate: MainTitleViewDelegate?
  @IBOutlet weak var locationLabel: UILabel!

  @IBAction func locationButtonTapped(sender: AnyObject) {
    delegate?.locationButtonTapped()
  }
}
