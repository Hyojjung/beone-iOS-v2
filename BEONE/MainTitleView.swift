
import UIKit

class MainTitleView: UIView {
  @IBOutlet weak var locationLabel: UILabel!

  @IBAction func locationButtonTapped(sender: AnyObject) {
    postNotification(kNotificationLocationButtonTapped)
  }
}
