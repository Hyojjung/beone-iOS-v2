
import UIKit

class ProductPropertyColorTypeValueView: SearchValueView {
  
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    viewDisplayType = .Color
  }
  
  override func configureView(searchValue: BaseModel, isSelected: Bool) {
    super.configureView(searchValue, isSelected: isSelected)
    if let searchValue = searchValue as? ProductPropertyValue {
      addHeightLayout(ProductPropertyViewHelper.buttonViewHeight(viewDisplayType))
      colorView.backgroundColor = searchValue.color
      nameLabel.text = searchValue.name
      subTitleLabel.text = searchValue.desc
    }
  }
}
