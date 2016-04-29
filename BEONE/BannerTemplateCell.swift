
import UIKit

class BannerTemplateCell: TemplateCell {
  
  var bannerContents = [Content]()
  var style: TemplateStyle?
  var timer: NSTimer?
  
  @IBOutlet weak var bannerView: XLCCycleScrollView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    timer = NSTimer.scheduledTimerWithTimeInterval(3,
                                                   target: self,
                                                   selector: #selector(BannerTemplateCell.setUpPage),
                                                   userInfo: nil,
                                                   repeats: true)
    bannerView.datasource = self
    bannerView.delegate = self
  }
  
  deinit {
    timer?.invalidate()
    timer = nil
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    bannerContents = template.content.items
    setUpFirstPage()
    NSTimer.scheduledTimerWithTimeInterval(0.3,
                                           target: self,
                                           selector: #selector(BannerTemplateCell.setUpFirstPage),
                                           userInfo: nil,
                                           repeats: false)
  }
  
  func setUpFirstPage() {
    self.bannerView.setViewContent(self.pageAtIndex(0), atIndex: 0)
  }
  
  func setUpPage() {
    bannerView.scrollView.setContentOffset(CGPointMake(bannerView.frame.width * 2, 0), animated: true)
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
    imageView.image = UIImage(named: kimagePostThumbnail)
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