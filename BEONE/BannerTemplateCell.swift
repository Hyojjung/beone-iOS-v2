
import UIKit

class BannerTemplateCell: TemplateCell {
  
  var bannerContents = [Content]()
  var style: TemplateStyle?
  @IBOutlet weak var bannerView: XLCCycleScrollView!

  override func awakeFromNib() {
    super.awakeFromNib()
    bannerView.datasource = self
    bannerView.delegate = self
  }
  
  override func calculatedHeight(template: Template) -> CGFloat? {
    return 300 + template.style.margin.top + template.style.margin.bottom + template.style.padding.top + template.style.padding.bottom

  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    bannerContents = template.content.items
    bannerView.reloadData()
  }
}

// MARK: - XLCCycleScrollViewDatasource

extension BannerTemplateCell: XLCCycleScrollViewDatasource {
  func numberOfPages() -> Int {
    return bannerContents.count
  }
  
  func pageAtIndex(index: Int) -> UIView! {
    var verticalmargin: CGFloat = 0
    var horizontalmargin: CGFloat = 0
    if let style = style {
      verticalmargin = style.margin.top + style.margin.bottom + style.padding.top + style.padding.bottom
      horizontalmargin = style.margin.left + style.margin.right + style.padding.left + style.padding.right
    }
    let viewFrame = CGRectMake(0, 0, frame.width - horizontalmargin, frame.height - verticalmargin)
    let bannerContent = bannerContents[index]
    let view = UIView(frame: viewFrame)
    let imageView = LazyLoadingImageView()
    imageView.frame = viewFrame
    imageView.contentMode = .ScaleAspectFill
    imageView.clipsToBounds = true
    imageView.setLazyLoaingImage(bannerContent.imageUrl)
    view.addSubview(imageView)
    return view
  }
}

extension BannerTemplateCell: XLCCycleScrollViewDelegate {
  func didClickPage(csView: XLCCycleScrollView!, atIndex index: Int) {
    bannerContents[index].action.action()
  }
}