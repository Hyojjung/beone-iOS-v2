
import UIKit

class TableContentsCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  @IBOutlet weak var textLabel: UILabel!
  var action: Action?
  
  func configure(content: Content?) {
    backgroundImageView.setLazyLoaingImage(content?.backgroundImageUrl)
    textLabel.textColor = content?.textColor
    textLabel.text = content?.text
    if let fontSize = content?.textSize {
      textLabel.font = UIFont.systemFontOfSize(fontSize)
    }
    action = content?.action
  }
  
  @IBAction func actionButtonTapped() {
    action?.action()
  }
}
