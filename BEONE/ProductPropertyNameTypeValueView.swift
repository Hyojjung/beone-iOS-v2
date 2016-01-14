
import UIKit

protocol SearchValueProtocol {
  var name: String? { get set }
}

let kValueButtonHeight = CGFloat(23)
let kValueButtonVerticalInterval = CGFloat(18)

class ProductPropertyNameTypeValueView: ProductPropertyValueView {
  
  override func configureView(searchValue: BaseModel, isSelected: Bool) {
    super.configureView(searchValue, isSelected: isSelected)
    if let searchValue = searchValue as? SearchValueProtocol {
      addHeightLayout(kValueButtonHeight)
      selectButton.setTitle(searchValue.name, forState: .Normal)
      selectButton.setTitle(searchValue.name, forState: .Selected)
      selectButton.backgroundColor = isSelected ? selectedProductPropertyValueButtonColor : productPropertyValueButtonColor
    }
  }
}