
import UIKit

class OptionSelectView: OptionTypeView {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var selectButton: UIButton!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      nameLabel.text = optionItem.name
      valueLabel.text = optionItem.value
    } else if let productOptionSet = optionItem as? ProductOptionSet {
      nameLabel.text = productOptionSet.name
      for option in productOptionSet.options {
        if option.isSelected {
          valueLabel.text = option.name
        }
      }
    }
  }
}