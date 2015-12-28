
import UIKit

class OptionSelectView: OptionTypeView {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var selectButton: UIButton!
  var optionId: Int?
  var isProductOptionSet = true
  
  override func layoutView(optionItem: BaseModel) {
    optionId = optionItem.id
    if let optionItem = optionItem as? OptionItem {
      nameLabel.text = optionItem.name
      valueLabel.text = optionItem.value
      isProductOptionSet = false
    } else if let productOptionSet = optionItem as? ProductOptionSet {
      nameLabel.text = productOptionSet.name
      for option in productOptionSet.options {
        if option.isSelected {
          valueLabel.text = option.name
        }
      }
      isProductOptionSet = true
    }
  }
  
  @IBAction func optionSelectButtonTapped(sender: UIButton) {
    if let optionId = optionId {
      (delegate as! OptionDelegate).optionSelectButtonTapped(optionId, isProductOptionSet: isProductOptionSet)
    }
  }
}