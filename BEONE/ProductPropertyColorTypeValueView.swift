
import UIKit

let kValueColorViewHeight = CGFloat(122)
let kValueColorViewVerticalInterval = CGFloat(5)

class ProductPropertyColorTypeValueView: ProductPropertyValueView {

  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!

  override func configureView(productPropertyValue: ProductPropertyValue, isSelected: Bool) {
    super.configureView(productPropertyValue, isSelected: isSelected)
    addHeightLayout(kValueColorViewHeight)
    colorView.backgroundColor = productPropertyValue.color
    nameLabel.text = productPropertyValue.name
    subTitleLabel.text = productPropertyValue.subTitle
  }
}
