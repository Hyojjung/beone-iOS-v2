
import UIKit

class TemplateCell: UITableViewCell, TemplateContentsViewProtocol {
  var templateId: NSNumber?
  
  @IBOutlet weak var templateContentsView: UIView!
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundImageView.contentMode = .ScaleAspectFill
    backgroundImageView.clipsToBounds = true
    backgroundImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
  }
  
  func configureCell(template: Template, forCalculateHeight: Bool) {
    configureStyle(template.style, forCalculateHeight: forCalculateHeight)
  }
  
  private func configureStyle(style: TemplateStyle?, forCalculateHeight: Bool) {
    configureDefaulStyle()
    if let style = style {
      if !forCalculateHeight {
        templateContentsView.backgroundColor = style.backgroundColor
        backgroundImageView.setLazyLoaingImage(style.backgroundImageUrl)
      }
      contentView.layoutMargins = style.margin
      templateContentsView.layoutMargins = style.padding
    }
  }
  
  func configureDefaulStyle() {
    templateContentsView.backgroundColor = UIColor.clearColor()
    backgroundImageView.image = nil
    contentView.layoutMargins = UIEdgeInsetsZero
    templateContentsView.layoutMargins = UIEdgeInsetsZero
  }
}

protocol TemplateContentsViewProtocol {
  var templateId: NSNumber? { get set }
}

extension UIView {
  func layoutContentsView(templateId: NSNumber?, height: CGFloat, contentsView: UIView) {
    if templateId != nil {
      for constraint in contentsView.constraints {
        if constraint.firstAttribute == .Height &&
          Int(constraint.constant) != Int(height) &&
          constraint.isMemberOfClass(NSLayoutConstraint) {
            //            print("constant: \(constraint.constant)")
            //            print("height: \(height)")
            constraint.constant = height
            postNotification(kNotificationContentsViewLayouted,
              userInfo: [kNotificationKeyTemplateId: templateId!])
            break;
        }
      }
    }
  }
}
