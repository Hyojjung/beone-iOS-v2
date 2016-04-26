
import UIKit

class ReviewsTemplateCell: TemplateCell {

  @IBOutlet weak var reviewsCollectionView: UICollectionView!
  
  var reviews = [Review]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    reviewsCollectionView.registerNib(UINib(nibName: "ReviewContentsCollectionViewCell", bundle: nil),
                               forCellWithReuseIdentifier: "reviewCell")
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let reviews = template.content.models as? [Review] {
      self.reviews = reviews
    }
    setUpCollectionViewFlowLayout()
    reviewsCollectionView.reloadData()
  }
  
  override func calculatedHeight(template: Template) -> CGFloat? {
    return 269 + template.style.margin.top + template.style.margin.bottom + template.style.padding.top + template.style.padding.bottom
  }
  
  private func setUpCollectionViewFlowLayout() {
    if let collectionViewLayout = reviewsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      collectionViewLayout.minimumInteritemSpacing = 8
      collectionViewLayout.minimumLineSpacing = 8
      collectionViewLayout.scrollDirection = .Horizontal
      collectionViewLayout.itemSize = CGSize(width: 236, height: 269)
    }
  }
}

// MARK: - UICollectionViewDataSource

extension ReviewsTemplateCell {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reviewCell",
                                                                     forIndexPath: indexPath)
    if let cell = cell as? ReviewContentsCollectionViewCell {
      cell.configure(reviews[indexPath.row])
      cell.delegate = self
    }
    return cell
  }
}

extension ReviewsTemplateCell: ReviewContentDelegate {
  func reviewButtonTapped(productId: Int) {
    ViewControllerHelper.topRootViewController()?.showProductView(productId)
  }
}
