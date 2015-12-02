
import UIKit

class TableContentsCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  @IBOutlet weak var textLabel: UILabel!

  func configure(content: Content) {
    backgroundImageView.setLazyLoaingImage(content.backgroundImageUrl)
    textLabel.textColor = content.textColor
    textLabel.text = content.text
    if let fontSize = content.textSize {
      textLabel.font = UIFont.systemFontOfSize(fontSize)
    }
  }
}
