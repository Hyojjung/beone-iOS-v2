
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
  
  override func layoutView(template: Template) {
    configureViewHierarchy()
    configureStyle(template.style)
    
    if let type = template.type,
      contentView = UIView.loadFromNibName(TemplateHelper.viewNibName(type)) as? TemplateContentsView {
        templateContentsView.addSubViewAndEdgeMarginLayout(contentView)
        contentView.layoutView(template)
    }
  }
  
  private func configureViewHierarchy() {
    if templateContentsView.superview == nil {
      addSubViewAndEdgeMarginLayout(templateContentsView)
      templateContentsView.addSubViewAndEdgeLayout(backgroundImageView)
    }
  }
  
  private func configureStyle(style: TemplateStyle?) {
    if let style = style {
      layoutMargins = style.margin
      templateContentsView.layoutMargins = style.padding
      templateContentsView.backgroundColor = style.backgroundColor
      backgroundImageView.setLazyLoaingImage(style.backgroundImageUrl)
    }
  }
}