
import UIKit

class BaseViewController: UIViewController {
  
  private let backButtonOffset = UIOffsetMake(0, -60)
  
  lazy var loadingView: LoadingView = {
    let loadingView = LoadingView()
    loadingView.layout()
    self.view.addSubview(loadingView)
    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
      attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.view,
      attribute: NSLayoutAttribute.Leading,
      multiplier: 1.0,
      constant: 0.0))
    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
      attribute: NSLayoutAttribute.Trailing,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.view,
      attribute: NSLayoutAttribute.Trailing,
      multiplier: 1.0,
      constant: 0.0))
    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
      attribute: NSLayoutAttribute.Bottom,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.view,
      attribute: NSLayoutAttribute.Bottom,
      multiplier: 1.0,
      constant: 0.0))
    self.view.addConstraint(NSLayoutConstraint(item: loadingView,
      attribute: NSLayoutAttribute.Top,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self.view,
      attribute: NSLayoutAttribute.Top,
      multiplier: 1.0,
      constant: 0.0))
    return loadingView
  }()
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
    return tapRecognizer
  }()
  
  func endEditing() {
    view.endEditing(true)
  }
  
  // MARK: - View Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    ViewControllerHelper.frontViewController = self
    setUpView()
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    ViewControllerHelper.showingNavigationViewController = self.navigationController
    //    ViewControllerHelper.frontViewController = self
#if RELEASE
    let tracker = GAI.sharedInstance().defaultTracker
    tracker.set(kGAIScreenName, value: self.title)
    
    let builder = GAIDictionaryBuilder.createScreenView()
    tracker.send(builder.build() as [NSObject : AnyObject])
#endif
    addObservers()
    setUpData()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
  }
  
  // MARK: - Private Methods
  
  func setUpView() {
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(backButtonOffset,
      forBarMetrics: .Default)
  }
  
  func setUpData() {
  }
  
  func addObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "startIndicator",
      name: kNotificationNetworkStart,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "stopIndicator",
      name: kNotificationNetworkEnd,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "showAlert:",
      name: kNotificationShowAlert,
      object: nil)
    
  }
  
  func removeObservers() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func showAlert(notification: NSNotification) {
    if let userInfo = notification.userInfo as? [String: AnyObject] {
      showAlertView(userInfo[kNotificationAlertKeyMessage] as? String,
        hasCancel: userInfo[kNotificationAlertKeyHasCancel] as? Bool,
        confirmAction: userInfo[kNotificationAlertKeyConfirmationAction] as? Action,
        cancelAction: userInfo[kNotificationAlertKeyCancelAction] as? Action)
    }
  }
  
  func startIndicator() {
    loadingView.show()
  }
  
  func stopIndicator() {
    loadingView.hide()
  }
}