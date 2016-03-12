
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
    setUpData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    checkNeedToShowUserViewController()
    addObservers()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    handleScheme()
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
}

// MARK: - Private Methods

extension BaseViewController {

  private func checkNeedToShowUserViewController() {
    if !MyInfo.sharedMyInfo().isUser() {
      SchemeHelper.schemeStrings = nil
      isWaitingSigning = true
    } else if let signingShowViewController = signingShowViewController {
      showViewController(signingShowViewController, sender: nil)
    }
    signingShowViewController = nil
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
    loadingView.show()
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
  
  private func showUserViewController(viewController: UIViewController) {
    if !MyInfo.sharedMyInfo().isUser() {
      signingShowViewController = viewController
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