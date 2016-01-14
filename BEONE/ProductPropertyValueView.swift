
import UIKit

class ProductPropertyValueView: UIView {

  @IBOutlet weak var selectButton: UIButton!
  var viewHeight = CGFloat(0)
  
  func configureView(searchValue: BaseModel, isSelected: Bool) {
    selectButton.selected = isSelected
  }
}