
import UIKit

class CalendarViewController: UIViewController {

  private let blurEffectView: UIVisualEffectView = {
    let blurEffectView = UIVisualEffectView()
    let blurEffect = UIBlurEffect(style: .Light)
    blurEffectView.effect = blurEffect
    return blurEffectView
  }()
  private let tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGestureRecognizer = UITapGestureRecognizer()
    return tapGestureRecognizer
  }()
  weak var delegate: CKCalendarDelegate?
  var calendar: CKCalendarView?
  var selectedDate: NSDate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clearColor()
    
    blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    
    blurEffectView.frame = view.frame
    view.addSubview(blurEffectView)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tapGestureRecognizer.addTarget(self, action: "dissmissView")
    
    self.calendar = CKCalendarView(viewWidth: ViewControllerHelper.screenWidth - 20)
    calendar?.setMonthButtonColor(lightGold)
    calendar?.titleColor = lightGold
    calendar?.delegate = delegate
    calendar?.selectedDate = selectedDate
    calendar?.center = CGPointMake(view.center.x, view.center.y)
    view.addSubview(calendar!)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    calendar?.removeFromSuperview()
    calendar = nil
  }
  
  func dissmissView() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
