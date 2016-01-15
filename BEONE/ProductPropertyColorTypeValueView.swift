
import UIKit

let kValueColorViewHeight = CGFloat(122)
let kValueColorViewVerticalInterval = CGFloat(5)

class ProductPropertyColorTypeValueView: SearchValueView {
  
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  
  override func configureView(searchValue: BaseModel, isSelected: Bool) {
    super.configureView(searchValue, isSelected: isSelected)
    if let searchValue = searchValue as? ProductPropertyValue {
      addHeightLayout(kValueColorViewHeight)
      colorView.backgroundColor = searchValue.color
      nameLabel.text = searchValue.name
      subTitleLabel.text = searchValue.subTitle
    }
  }
}
