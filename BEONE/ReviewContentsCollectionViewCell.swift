
import UIKit

protocol ReviewContentDelegate: NSObjectProtocol {
  func reviewButtonTapped(productId: Int)
}

class ReviewContentsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var reviewImageView: LazyLoadingImageView!
  @IBOutlet weak var reviewButton: UIButton!
  weak var delegate: ReviewContentDelegate?
  
  func configure(review: Review) {
    reviewImageView.image = UIImage(named: kimagePostThumbnail)
    reviewImageView.setLazyLoaingImage(review.reviewImageUrls.first)
    userNameLabel.text = review.userName
    createdAtLabel.text = review.createdAt?.briefDateString()
    contentLabel.text = review.content
    if let productId = review.productId {
      reviewButton.tag = productId
    }
  }
  
  @IBAction func reviewButtonTapped(sender: UIButton) {
    delegate?.reviewButtonTapped(sender.tag)
  }
}
