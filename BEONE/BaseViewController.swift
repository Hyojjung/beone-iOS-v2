
import UIKit

class BaseViewController: UIViewController {
  
  // MARK: - Property
  
  private let backButtonOffset = UIOffsetMake(0, -60)
  private var isWaitingSigning = false
  private var signingShowViewController: UIViewController? = nil
  
  lazy var loadingView: LoadingView = {
    let loadingView = LoadingView()
    loadingView.layout()
    self.view.addSubViewAndEdgeLayout(loadingView)
    return loadingView
  }()
  
  // MARK: - View Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    #if RELEASE
      let tracker = GAI.sharedInstance().defaultTracker
      tracker.set(kGAIScreenName, value: self.title)
      
      let builder = GAIDictionaryBuilder.createScreenView()
      tracker.send(builder.build() as [NSObject : AnyObject])
    #endif
    
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = nil
      if !isWaitingSigning {
        isWaitingSigning = true
      }
    } else if let signingShowViewController = signingShowViewController {
      showViewController(signingShowViewController, sender: nil)
      self.signingShowViewController = nil
    }
    
    addObservers()
    setUpData()
  }
  
  func showUserViewController(storyboardName: String, viewIdentifier: String) {
    let viewController = self.viewController(storyboardName, viewIdentifier: viewIdentifier)
    showUserViewController(viewController)
  }
  
  func showUserViewController(viewController: UIViewController) {
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = viewController
      showSigningView()
    } else {
      showViewController(viewController, sender: nil)
    }
  }
  
  func showOptionView(selectedProduct: Product, selectedCartItem: CartItem? = nil,
    rightOrdering: Bool = false, isModifing: Bool = false) {
      let optionViewController = viewController(kProductDetailStoryboardName, viewIdentifier: kProductOptionViewIdentifier)
      if let optionViewController = optionViewController as? OptionViewController {
        optionViewController.product = selectedProduct
        optionViewController.isModifing = isModifing
        if let selectedCartItem = selectedCartItem {
          optionViewController.cartItems.append(selectedCartItem)
        }
        showUserViewController(optionViewController)
      }
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
    loadingView.hide()
  }
  
  // MARK: - Private Methods
  
  func setUpView() {
    view.backgroundColor = bgColor
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
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "showWebView:",
      name: kNotificationShowWebView,
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
        cancelAction: userInfo[kNotificationAlertKeyCancelAction] as? Action,
        delegate: self)
    }
  }
  
  func showWebView(notification: NSNotification) {
    if let userInfo = notification.userInfo as? [String: AnyObject] {
      showWebView(userInfo[kNotificationAlertKeyMessage] as? String, title: nil)
    }
  }
  
  func startIndicator() {
    loadingView.show()
  }
  
  func stopIndicator() {
    loadingView.hide()
  }
  
  func endEditing() {
    view.endEditing(true)
  }
}