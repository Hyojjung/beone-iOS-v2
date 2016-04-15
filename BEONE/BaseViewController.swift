
import UIKit

class BaseViewController: UIViewController {
  
  // MARK: - Property
  
  private let backButtonOffset = UIOffsetMake(0, -60)
  private var isWaitingSigning = false
  private var signingShowViewController: UIViewController? = nil
  var needOftenUpdate = true
  var dataLoaded = false
  var needHandleScheme = true
  
  lazy var loadingView: LoadingView = {
    let loadingView = LoadingView()
    loadingView.layout()
    self.view.addSubViewAndEdgeLayout(loadingView)
    return loadingView
  }()
  
  // MARK: - View Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(BaseViewController.startIndicator),
                                                     name: kNotificationNetworkStart,
                                                     object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(BaseViewController.stopIndicator),
                                                     name: kNotificationNetworkEnd,
                                                     object: nil)
    setUpView()
    if !needOftenUpdate {
      setUpData()
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationNetworkStart, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationNetworkEnd, object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    checkNeedToShowUserViewController()
    if needOftenUpdate {
      setUpData()
    }
    addObservers()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if !(self is SigningViewController) {
      needHandleScheme = false
      handleScheme()
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
    loadingView.hide()
  }
}

// MARK: - BaseViewController Methods

extension BaseViewController {
  
  func setUpView() {
    view.backgroundColor = bgColor
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(backButtonOffset,
                                                                      forBarMetrics: .Default)
  }
  
  func setUpData() {
  }
  
  func addObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(BaseViewController.showAlert(_:)),
                                                     name: kNotificationShowAlert,
                                                     object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(BaseViewController.showWebView(_:)),
                                                     name: kNotificationShowWebView,
                                                     object: nil)
  }
  
  func removeObservers() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationShowAlert, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationShowWebView, object: nil)
  }
}

// MARK: - Private Methods

extension BaseViewController {
  
  private func checkNeedToShowUserViewController() {
    if let signingShowViewController = signingShowViewController {
      if isWaitingSigning {
        if !MyInfo.sharedMyInfo().isUser() {
          SchemeHelper.schemeStrings.removeAll()
        } else {
          showViewController(signingShowViewController, sender: nil)
        }
        isWaitingSigning = false
      }
      self.signingShowViewController = nil
    }
  }
}

// MARK: - BaseViewController Action Methods

extension BaseViewController {
  
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
  
  func endEditing() {
    view.endEditing(true)
  }
  
  func startIndicator() {
    if !dataLoaded {
      loadingView.show()
    }
  }
  
  func stopIndicator() {
    loadingView.hide()
  }
}

extension BaseViewController {
  
  func showViewController(schemeIdentifier: SchemeIdentifier) {
    let viewIdentifiers = schemeIdentifier.viewIdentifiers()
    if viewIdentifiers.isForUser {
      showUserViewController(viewIdentifiers.storyboardName, viewIdentifier: viewIdentifiers.viewIdentifier)
    } else {
      showViewController(viewIdentifiers.storyboardName, viewIdentifier: viewIdentifiers.viewIdentifier)
    }
  }
  
  private func showViewController(storyboardName: String, viewIdentifier: String) {
    showViewController(UIViewController.viewController(storyboardName, viewIdentifier: viewIdentifier), sender: nil)
  }
  
  private func showUserViewController(storyboardName: String, viewIdentifier: String) {
    let viewController = UIViewController.viewController(storyboardName, viewIdentifier: viewIdentifier)
    showUserViewController(viewController)
  }
  
  func showUserViewController(viewController: UIViewController) {
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = viewController
      isWaitingSigning = true
      showSigningView()
    } else {
      showViewController(viewController, sender: nil)
    }
  }
  
  func showOptionView(selectedProductId: Int?, selectedCartItem: CartItem? = nil,
                      rightOrdering: Bool = false, isModifing: Bool = false) {
    if let optionViewController = UIViewController.viewController(.Option) as? OptionViewController {
      optionViewController.product.id = selectedProductId
      optionViewController.isModifing = isModifing
      optionViewController.isOrdering = rightOrdering
      optionViewController.cartItems.appendObject(selectedCartItem)
      showUserViewController(optionViewController)
    }
  }
}