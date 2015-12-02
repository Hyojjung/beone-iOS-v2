
import UIKit

class TemplateView: TemplateContentsView {
  private var templateContentsView = UIView()
  private lazy var backgroundImageView: LazyLoadingImageView = {
    let imageView = LazyLoadingImageView()
    imageView.contentMode = .ScaleAspectFill
    imageView.clipsToBounds = true
    imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
    return imageView
  }()
  
  var contentView: TemplateContentsView?
  
  override func layoutView(template: Template) {
    configureViewHierarchy()
    configureStyle(template.style)
    
    if let type = template.type,
      contentView = UIView.loadFromNibName(TemplateHelper.viewNibName(type)) as? TemplateContentsView {
        if self.contentView?.className() != contentView.className() {
          self.contentView?.removeFromSuperview()
          self.contentView = contentView
          templateContentsView.addSubViewAndEdgeMarginLayout(self.contentView!)
        }
        self.contentView?.layoutView(template)
    }
  }
  
  private func configureViewHierarchy() {
    if templateContentsView.superview == nil {
      addSubViewAndEdgeMarginLayout(templateContentsView)
      templateContentsView.addSubViewAndEdgeLayout(backgroundImageView)
    }
  }
  
  private func configureStyle(style: TemplateStyle?) {
    backgroundImageView.image = nil
    templateContentsView.backgroundColor = nil
    templateContentsView.layoutMargins = UIEdgeInsetsZero
    if let style = style {
      layoutMargins = style.margin
      templateContentsView.layoutMargins = style.padding
      templateContentsView.backgroundColor = style.backgroundColor
      backgroundImageView.setLazyLoaingImage(style.backgroundImageUrl)
    }
  }
}