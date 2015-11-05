
import UIKit

class AlertViewController: UIViewController {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var buttonView: UIView!
  
  var message: String?
  var hasCancel: Bool?
  var confirmAction: Action?
  var cancelAction: Action?
  
  // MARK: - Init
  
  convenience init(message: String, hasCancel: Bool?, confirmAction: Action?, cancelAction: Action?) {
    self.init()
    self.message = message
    self.confirmAction = confirmAction
    self.cancelAction = cancelAction
    self.hasCancel = hasCancel
  }
  
  // MARK: - Override Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    messageLabel.text = message
    let secondAttribute = hasCancel == nil || !hasCancel! ? NSLayoutAttribute.Leading : NSLayoutAttribute.CenterX
    buttonView.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .Leading, relatedBy: .Equal, toItem: buttonView, attribute: secondAttribute, multiplier: 1, constant: 0))
    cancelButton.enabled = hasCancel != nil && hasCancel!
  }
  
  // MARK: - Actions
  
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
