
import UIKit

class DeliveryTimeSelectViewController: UIViewController {
  
  @IBOutlet weak var timeSelectScrollView: UIScrollView!
  let timeSelectView = TimeSelectView()
  var availableTimeRanges: [AvailableTimeRange]?
  var selectedTimeRange: AvailableTimeRange?
  weak var delegate: TimeSelectViewDelegate? {
    didSet {
      timeSelectView.delegate = delegate
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timeSelectScrollView.addSubViewAndEdgeLayout(timeSelectView)
    timeSelectScrollView.addEqualWidthLayout(timeSelectScrollView, view2: timeSelectView)
    timeSelectScrollView.addEqualHeightLayout(timeSelectScrollView, view2: timeSelectView)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    timeSelectView.layoutView(availableTimeRanges!, selectedTimeRange: selectedTimeRange)
  }
}
