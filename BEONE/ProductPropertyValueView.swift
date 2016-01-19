
import UIKit

protocol SearchValueDelegate: NSObjectProtocol {
  func searchValueTapped(id: Int, isTag: Bool)
}

class SearchValueView: UIView {
  
  @IBOutlet weak var selectButton: UIButton!
  weak var delegate: SearchValueDelegate?
  var isTag = false
  var needBackgoundColor = false
  
  func configureView(searchValue: BaseModel, isSelected: Bool) {
    if let id = searchValue.id {
      selectButton.tag = id
    }
    isTag = searchValue is Tag
    configureButton(isSelected)
  }
  
  @IBAction func selectSearchValueButtonTapped(sender: UIButton) {
    delegate?.searchValueTapped(sender.tag, isTag: isTag)
    configureButton(!sender.selected)
  }
  
  func configureButton(isSelected: Bool) {
    selectButton.selected = isSelected
    if needBackgoundColor {
      selectButton.backgroundColor = selectButton.selected ?
        selectedProductPropertyValueButtonColor : productPropertyValueButtonColor
    }
  }
}