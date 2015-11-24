
import UIKit
import CSStickyHeaderFlowLayout
import IDMPhotoBrowser

let kProductDetailHeaderCellNibName = "ProductDetailHeaderCollectionViewCell"
let kProductDetailHeaderCellIdentifier = "headerCell"

let kCellHeightProductDetailHeaderCell = CGFloat(300)

class ProductDetailViewController: BaseViewController {
  
  // MARK: - Constant
  
  private enum ProductDetailTableViewSection: Int {
    case Rate
    case Price
    case Info
    case DetailInfo
    case Description
    case ShareButton
    case Precaution
    case RefundGuide
    case Inquiry
    case Space
    case Shop
    case ReviewTitle
    case Review
    case ButtonSpace
    case Count
  }
  
  private let kProductDetailTableViewCellIdentifiers = ["rateCell",
    "priceCell",
    "infoCell",
    "detailInfoCell",
    "descriptionCell",
    "shareButtonCell",
    "precautionCell",
    "refundGuideCell",
    "inquiryCell",
    "spaceCell",
    "shopCell",
    "reviewTitleCell",
    "reviewSection",
    "buttonSpaceCell"]
  
  @IBOutlet weak var collectionView: UICollectionView!
  let product = BEONEManager.selectedProduct
  let reviewList = ReviewList()
  var imageUrls = [NSURL]()
  var selectedImageUrlIndex = 0
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.hidden = false
  }
  
  override func setUpView() {
    super.setUpView()
    reloadLayout()
    collectionView?.registerNib(UINib(nibName: kProductDetailHeaderCellNibName, bundle: nil),
      forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
      withReuseIdentifier: kProductDetailHeaderCellIdentifier)
    product?.fetch()
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpProductData",
      name: kNotificationFetchProductSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleShowImageNotification:",
      name: kNotificationProductDetailImageTapped, object: nil)
  }
  
  func reloadLayout() {
    let layout = collectionView.collectionViewLayout
    if layout.isKindOfClass(CSStickyHeaderFlowLayout) {
      if let stickyLayout = layout as? CSStickyHeaderFlowLayout {
        stickyLayout.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, kCellHeightProductDetailHeaderCell)
        stickyLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(view.frame.size.width, 60)
        stickyLayout.estimatedItemSize = CGSize(width: 150, height: 75)
        stickyLayout.disableStickyHeaders = true
        stickyLayout.parallaxHeaderAlwaysOnTop = true
      }
    }
  }
  
  func setUpProductData() {
    if let imageUrls = product?.productDetailImageUrls() {
      self.imageUrls.removeAll()
      for imageUrl in imageUrls {
        self.imageUrls.append(imageUrl.url())
      }
    }
    collectionView.reloadData()
  }
  
  @IBAction func backButtonTapped() {
    popView()
  }
  
  @IBAction func orderButtonTapped() {
    performSegueWithIdentifier("From Product Detail To Option", sender: nil)
  }
  
  @IBAction func addCartButtonTapped() {
    performSegueWithIdentifier("From Product Detail To Option", sender: nil)
  }
  
  @IBAction func imageButtonTapped(sender: UIButton) {
    let selectedImageUrl = product?.productDetails[sender.tag].content
    for (index, imageUrl) in imageUrls.enumerate() {
      if selectedImageUrl != nil && imageUrl.absoluteString.containsString(selectedImageUrl!) {
        showImage(index, view: sender)
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

// MARK: UICollectionViewDataSource

extension ProductDetailViewController {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return ProductDetailTableViewSection.Count.rawValue
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if ProductDetailTableViewSection(rawValue: section) == .Review {
      return reviewList.list.count == 0 ? 1 : reviewList.list.count
    } else if ProductDetailTableViewSection(rawValue: section) == .Description {
      return product?.productDetails.count != nil ? (product?.productDetails.count)! : 0
    } else {
      return 1
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier(indexPath),
      forIndexPath: indexPath)
    if let product = product {
      (cell as? ProductDetailCell)?.configureCell(product, indexPath: indexPath)
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
      withReuseIdentifier: kProductDetailHeaderCellIdentifier,
      forIndexPath: indexPath)
    if let product = product {
      (cell as? ProductDetailHeaderCollectionViewCell)?.configureCell(product)
    }
    return cell
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if ProductDetailTableViewSection(rawValue: indexPath.section) == .Review {
      if reviewList.list.count == 0 {
        return "noReviewCell"
      }
      return "reviewCell"
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
      //    case .Inquiry:
      //      performSegueWithIdentifier("From Product Detail To Inquiry", sender: nil)
      //    case .Review:
      //      performSegueWithIdentifier("From Product Detail To Review", sender: nil)
    case .Shop:
      BEONEManager.selectedShop = product?.shop
      showViewController("Shop", viewIdentifier: "ShopView")
    default:
      break
    }
  }
  
}