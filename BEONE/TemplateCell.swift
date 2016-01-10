
import UIKit

class TemplateCell: UITableViewCell {
  var templateId: NSNumber?
  
  @IBOutlet weak var templateContentsView: UIView!
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundImageView.contentMode = .ScaleAspectFill
    backgroundImageView.clipsToBounds = true
    backgroundImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
  }
  
  func calculatedHeight(template: Template) -> CGFloat? {
    return nil
  }
  
  func configureCell(template: Template) {
    configureStyle(template.style)
  }
  
  func configureDefaulStyle() {
    templateContentsView.backgroundColor = UIColor.clearColor()
    backgroundImageView.image = nil
    contentView.layoutMargins = UIEdgeInsetsZero
    templateContentsView.layoutMargins = UIEdgeInsetsZero
  }
  
  // MARK: - Private Methods
  
  private func configureStyle(style: TemplateStyle?) {
    configureDefaulStyle()
    if let style = style {
      templateContentsView.backgroundColor = style.backgroundColor
      backgroundImageView.setLazyLoaingImage(style.backgroundImageUrl)
      contentView.layoutMargins = style.margin
      templateContentsView.layoutMargins = style.padding
    }
  }
}
