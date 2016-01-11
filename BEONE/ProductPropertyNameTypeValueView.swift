
import UIKit

let kValueButtonHeight = CGFloat(23)
let kValueButtonVerticalInterval = CGFloat(18)

class ProductPropertyNameTypeValueView: ProductPropertyValueView {
  
  override func configureView(productPropertyValue: ProductPropertyValue, isSelected: Bool) {
    super.configureView(productPropertyValue, isSelected: isSelected)
    addHeightLayout(kValueButtonHeight)
    selectButton.setTitle(productPropertyValue.name, forState: .Normal)
    selectButton.setTitle(productPropertyValue.name, forState: .Selected)
    selectButton.backgroundColor = isSelected ? selectedProductPropertyValueButtonColor : productPropertyValueButtonColor
  }
}
