
import UIKit

protocol SearchValueProtocol {
  var name: String? { get set }
}

class ProductPropertyNameTypeValueView: SearchValueView {
  
  override func configureView(searchValue: BaseModel, isSelected: Bool) {
    super.configureView(searchValue, isSelected: isSelected)
    if let searchValue = searchValue as? SearchValueProtocol {
      addHeightLayout(ProductPropertyViewHelper.buttonViewHeight(viewDisplayType))
      selectButton.setTitle(searchValue.name, forState: .Normal)
      selectButton.setTitle(searchValue.name, forState: .Selected)
    }
  }
}