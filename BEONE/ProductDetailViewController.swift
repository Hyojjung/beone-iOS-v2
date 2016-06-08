
import UIKit
import CSStickyHeaderFlowLayout
import SDWebImage

let kProductDetailHeaderCellNibName = "ProductDetailHeaderCollectionViewCell"
let kProductDetailHeaderCellIdentifier = "headerCell"

let kProductDetailHeaderCellDefaultHeight = CGFloat(450)
let kProductDetailHeaderCellMinimumHeight = CGFloat(64)
let kKaKaoLinkImageWidth = CGFloat(140)

class ProductDetailViewController: BaseViewController {
  
  // MARK: - Constant
  
  private enum ProductDetailTableViewSection: Int {
    case Rate
    case Price
    case Info
    case DetailInfo
    case HeaderDescription
    case Description
    case FooterDescription
    case ShareButton
    case Precaution
    case RefundGuide
    case Inquiry
    case Space
    case Shop
    case ReviewTitle
    case Review
    case MoreReview
    case ButtonSpace
    case Count
  }
  
  private let kProductDetailTableViewCellIdentifiers = ["rateCell",
    "priceCell",
    "infoCell",
    "detailInfoCell",
    "headerDescriptionCell",
    "descriptionCell",
    "footerDescriptionCell",
    "shareButtonCell",
    "precautionCell",
    "refundGuideCell",
    "inquiryCell",
    "spaceCell",
    "shopCell",
    "reviewTitleCell",
    "reviewSection",
    "moreReviewCell",
    "buttonSpaceCell"]
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let product = Product()
  let reviews: Reviews = Reviews()
  var imageUrls = [NSURL]()
  var selectedImageUrlIndex = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.hidden = false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let inquiriesViewController = segue.destinationViewController as? InquiriesViewController {
      inquiriesViewController.product = product
    } else if let reviewsViewController = segue.destinationViewController as? ReviewsViewController {
      reviewsViewController.productId = product.id
      if let sender = sender as? [Int] {
        reviewsViewController.showingReviewId = sender.first
        reviewsViewController.showingImageIndex = sender.last
      }
    }
  }
  
  override func setUpView() {
    super.setUpView()
    reloadLayout()
    collectionView?.registerNib(UINib(nibName: kProductDetailHeaderCellNibName, bundle: nil),
      forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
      withReuseIdentifier: kProductDetailHeaderCellIdentifier)
  }
  
  override func setUpData() {
    super.setUpData()
    if product.id != nil {
      product.get({ 
          self.title = self.product.title
          self.sendViewTitle()
          self.setUpProductData()
        }, failure: { (error) in
          if error.statusCode == .NotFound {
            let action = Action()
            action.type = .Method
            action.content = "popView"
            ViewControllerHelper.topRootViewController()?.showAlertView("구매불가한 상품입니다.", confirmAction: action, delegate: self)
          }
      })
      
      reviews.productId = product.id
      reviews.isRecentThree = true
      reviews.get {
        self.product.reviews = self.reviews.list as! [Review]
        self.collectionView.reloadData()
      }
      showingLoadingView = false
    }
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
                                                     selector: #selector(ProductDetailViewController.handleShowImageNotification(_:)),
      name: kNotificationProductDetailImageTapped, object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationProductDetailImageTapped, object: nil)
  }
  
  func reloadLayout() {
    let layout = collectionView.collectionViewLayout
    if layout.isKindOfClass(CSStickyHeaderFlowLayout) {
      if let stickyLayout = layout as? CSStickyHeaderFlowLayout {
        stickyLayout.parallaxHeaderReferenceSize =
          CGSizeMake(ViewControllerHelper.screenWidth, kProductDetailHeaderCellDefaultHeight)
        stickyLayout.parallaxHeaderMinimumReferenceSize =
          CGSizeMake(ViewControllerHelper.screenWidth, kProductDetailHeaderCellMinimumHeight)
        stickyLayout.estimatedItemSize = kCollectionViewDefaultSize
        stickyLayout.disableStickyHeaders = true
        stickyLayout.parallaxHeaderAlwaysOnTop = true
      }
    }
  }
  
  private func setUpProductData() {
    imageUrls.removeAll()
    for imageUrl in product.productDetailImageUrls() {
      imageUrls.appendObject(imageUrl.url())
    }
    collectionView.reloadData()
  }
}

extension ProductDetailViewController {
  @IBAction func backButtonTapped() {
    popView()
  }
  
  @IBAction func orderButtonTapped() {
    addCart(true)
  }
  
  @IBAction func addCartButtonTapped() {
    addCart(false)
  }
  
  @IBAction func reviewImageButtonTapped(sender: UIButton) {
    if let superview = sender.superview {
      performSegueWithIdentifier(kFromProductDetailToReviewSegueIdentifier, sender: [superview.tag, sender.tag])
    }
  }
  
  func addCart(isOrdering: Bool) {
    if !product.soldOut {
      showOptionView(product.id, rightOrdering: isOrdering)
    } else {
      showAlertView(NSLocalizedString("sold out product", comment: "alert title"))
    }
  }
  
  @IBAction func imageButtonTapped(sender: UIButton) {
    let selectedImageUrl = product.productDetails[sender.tag].content
    for (index, imageUrl) in imageUrls.enumerate() {
      if selectedImageUrl != nil && imageUrl.absoluteString.containsString(selectedImageUrl!) {
        showImage(index, view: sender)
      }
    }
  }
  
  @IBAction func shareButtonTapped() {
    if let productId = product.id, mainImageUrl = product.mainImageUrl, summary = product.summary, title = product.title {
      loadingView.show()
      SDWebImageDownloader.sharedDownloader().downloadImageWithURL(mainImageUrl.url(),
        options: .ContinueInBackground, progress: nil) { (image, data, error, finished) -> Void in
          self.loadingView.hide()
          if error == nil {
            let image = KakaoTalkLinkObject.createImage(mainImageUrl.url().absoluteString,
              width: Int32(kKaKaoLinkImageWidth),
              height: Int32(image.size.heightFromRatio(kKaKaoLinkImageWidth)))
            let label = KakaoTalkLinkObject.createLabel("[\(title)]\n\(summary)")
            let appExecparam = ["productId": productId]
            let androidAppAction = KakaoTalkLinkAction.createAppAction(.Android,
              devicetype: .Phone,
              execparam: appExecparam)
            let iPhoneAppAction = KakaoTalkLinkAction.createAppAction(.IOS,
              devicetype: .Phone,
              execparam: appExecparam)
            let button = KakaoTalkLinkObject.createAppButton(NSLocalizedString("kakao button title", comment: "kakao button"),
              actions: [androidAppAction, iPhoneAppAction])
            
            KOAppCall.openKakaoTalkAppLink([label, image, button])
          }
      }
    }
  }
  
  func handleShowImageNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      index = userInfo[kNotificationKeyIndex] as? Int,
      view = userInfo[kNotificationKeyView] as? UIView {
        showImage(index, view: view)
    }
  }
  
  func showImage(index: Int, view: UIView) {
    let browser = IDMPhotoBrowser(photoURLs: imageUrls, animatedFromView: view)
    browser.setInitialPageIndex(UInt(index))
    browser.usePopAnimation = true
    browser.displayArrowButton = true
    browser.displayCounterLabel = true
    presentViewController(browser, animated: true, completion: nil)
  }
}

extension ProductDetailViewController: SchemeDelegate {
  func handleScheme(with id: Int) {
    product.id = id
    setUpData()
    SchemeHelper.schemeStrings.removeAtIndex(0)
    handleScheme()
  }
}

// MARK: UICollectionViewDataSource

extension ProductDetailViewController {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return ProductDetailTableViewSection.Count.rawValue
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if ProductDetailTableViewSection(rawValue: section) == .Review {
      return product.reviews.count == 0 ? 1 : product.reviews.count
    } else if ProductDetailTableViewSection(rawValue: section) == .Description {
      return product.productDetails.count
    } else if ProductDetailTableViewSection(rawValue: section) == .HeaderDescription {
      return product.productDetailHeaders.count
    } else if ProductDetailTableViewSection(rawValue: section) == .FooterDescription {
      return product.productDetailFooters.count
    } else if ProductDetailTableViewSection(rawValue: section) == .MoreReview {
      return reviews.total > 3 ? 1 : 0
    } else {
      return 1
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier(indexPath),
      forIndexPath: indexPath)
    if let cell = cell as? ProductDetailCell {
      cell.configureCell(product, indexPath: indexPath)
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
      withReuseIdentifier: kProductDetailHeaderCellIdentifier,
      forIndexPath: indexPath)
    if let cell = cell as? ProductDetailHeaderCollectionViewCell {
      cell.configureCell(product)
    }
    return cell
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if ProductDetailTableViewSection(rawValue: indexPath.section) == .Review {
      if product.reviews.count == 0 {
        return "noReviewCell"
      } else {
        if product.reviews[indexPath.row].reviewImageUrls.count > 0 {
          return "imageReviewCell"
        } else {
          return "reviewCell"
        }
      }
    } else {
      return kProductDetailTableViewCellIdentifiers[indexPath.section]
    }
  }
}


extension ProductDetailViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    switch ProductDetailTableViewSection(rawValue: indexPath.section)! {
    case .RefundGuide:
      showWebView("policies/delivery", title: "배송/교환/환불안내")
    case .Inquiry:
      performSegueWithIdentifier("From Product Detail To Inquiry", sender: nil)
    case .Review, .MoreReview:
      performSegueWithIdentifier(kFromProductDetailToReviewSegueIdentifier, sender: nil)
    case .Shop:
      if let shopId = product.shop.id {
        SchemeHelper.setUpScheme("current/shop/\(shopId)")
      }
    default:
      break
    }
  }
}