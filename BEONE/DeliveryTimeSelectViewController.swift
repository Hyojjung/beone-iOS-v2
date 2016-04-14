
import UIKit

class DeliveryTimeSelectViewController: UIViewController {
  
  private let kTimeSelectScrollViewTopInterval: CGFloat = 80
  private let kTimeSelectScrollViewBottomInterval: CGFloat = 25
  private let kTimeViewVerticalInterval: CGFloat = 25
  
  @IBOutlet weak var timeSelectScrollView: UIScrollView!
  @IBOutlet weak var timeSelectView: TimeSelectView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
  
  var availableTimeRanges: [AvailableTimeRange]?
  var selectedTimeRange: AvailableTimeRange?
  weak var delegate: TimeSelectViewDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    timeSelectView.delegate = delegate
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    timeSelectView.layoutView(availableTimeRanges!, selectedTimeRange: selectedTimeRange)
    timeSelectView.setNeedsDisplay()
    timeSelectView.layoutIfNeeded()

    let margin = ViewControllerHelper.screenHeight - timeSelectView.frame.height -
      kTimeSelectScrollViewTopInterval - kTimeSelectScrollViewBottomInterval
    
    if margin > kTimeViewVerticalInterval * 2 {
      bottomLayoutConstraint.constant = margin / 2
      topLayoutConstraint.constant = margin / 2
    } else {
      bottomLayoutConstraint.constant = kTimeViewVerticalInterval
      bottomLayoutConstraint.constant = kTimeViewVerticalInterval
    }
  }
}
