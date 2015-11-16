
import UIKit

class AlertViewController: UIViewController {
  
  // MARK: - Property
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var buttonView: UIView!
  
  var message: String?
  var hasCancel: Bool?
  var confirmAction: Action?
  var cancelAction: Action?
  var actionDelegate: AnyObject?
}

// MARK: - Init

extension AlertViewController {
  convenience init(message: String) {
    self.init(message: message, hasCancel: false, confirmAction: nil, cancelAction: nil, actionDelegate: nil)
  }
  
  convenience init(message: String, hasCancel: Bool?, confirmAction: Action?, cancelAction: Action?, actionDelegate: AnyObject?) {
    self.init()
    self.message = message
    self.confirmAction = confirmAction
    self.confirmAction?.actionDelegate = actionDelegate
    self.cancelAction = cancelAction
    self.cancelAction?.actionDelegate = actionDelegate
    self.hasCancel = hasCancel
  }
}

// MARK: - View Cycles

extension AlertViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    messageLabel.text = message
    let secondAttribute = hasCancel == nil || !hasCancel! ? NSLayoutAttribute.Leading : NSLayoutAttribute.CenterX
    buttonView.addConstraint(NSLayoutConstraint(item: confirmButton,
      attribute: .Leading,
      relatedBy: .Equal,
      toItem: buttonView,
      attribute: secondAttribute,
      multiplier: 1,
      constant: 0))
    cancelButton.enabled = hasCancel != nil && hasCancel!
  }
}

// MARK: - Actions

extension AlertViewController {
  @IBAction func backgroundViewTapped() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func cancelButtonTapped() {
    dismissViewControllerAnimated(true) { () -> Void in
      self.cancelAction?.action()
    }
  }
  
  @IBAction func confirmButtonTapped() {
    dismissViewControllerAnimated(true) { () -> Void in
      self.confirmAction?.action()
    }
  }
}
