
import UIKit

class ProductPropertyValueView: UIView {

  @IBOutlet weak var selectButton: UIButton!

  func configureView(productPropertyValue: ProductPropertyValue, isSelected: Bool) {
    selectButton.selected = isSelected
  }
}
