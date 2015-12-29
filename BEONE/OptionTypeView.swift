
import UIKit

protocol OptionDelegate: NSObjectProtocol {
  func optionSelectButtonTapped(optionId: Int, isProductOptionSet: Bool, sender: UIButton)
}

class OptionTypeView: UIView {

  weak var delegate: AnyObject?

  func layoutView(optionItem: BaseModel) {
    
  }
}
