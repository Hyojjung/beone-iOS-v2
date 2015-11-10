
import UIKit
import CSStickyHeaderFlowLayout

let kNibNameProductDetailHeaderCell = "ProductDetailHeaderCollectionViewCell"
let kIdentifierProductDetailHeaderCell = "headerCell"

let kCellHeightProductDetailHeaderCell = CGFloat(300)

class ProductDetailCollectionViewController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reloadLayout()
    collectionView?.registerNib(UINib(nibName: kNibNameProductDetailHeaderCell, bundle: nil),
      forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
      withReuseIdentifier: kIdentifierProductDetailHeaderCell)
  }
  
  func reloadLayout() {
    let layout = collectionViewLayout
    if layout.isKindOfClass(CSStickyHeaderFlowLayout) {
      let stickyLayout = layout as! CSStickyHeaderFlowLayout
      stickyLayout.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, kCellHeightProductDetailHeaderCell)
      stickyLayout.itemSize = CGSizeMake(view.frame.size.width, stickyLayout.itemSize.height)
      stickyLayout.disableStickyHeaders = true
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == CSStickyHeaderParallaxHeader {
      let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
        withReuseIdentifier: kIdentifierProductDetailHeaderCell,
        forIndexPath: indexPath)
      return cell
    } else {
      let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "nil", forIndexPath: indexPath)
      return cell
    }
  }
}
