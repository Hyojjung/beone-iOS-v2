
import UIKit
import IDMPhotoBrowser

class ReviewListViewController: BaseTableViewController {
  
  lazy var reviewList: ReviewList = {
    let reviewList = ReviewList()
    return reviewList
  }()
  
  var showingReviewId: Int?
  var showingImageIndex: Int?
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    reviewList.get {
      self.tableView.reloadData()
    }
    if let showingReviewId = showingReviewId, showingImageIndex = showingImageIndex {
      showReviewImage(showingReviewId, showingImageIndex: showingImageIndex)
      self.showingReviewId = nil
      self.showingImageIndex = nil
    }
  }

  @IBAction func reviewImageButtonTapped(sender: UIButton) {
    if let reviewId = sender.superview?.tag {
      showReviewImage(reviewId, showingImageIndex: sender.tag)
    }
  }
  
  func showReviewImage(reviewId: Int, showingImageIndex: Int) {
    if let reivew = reviewList.model(reviewId) as? Review {
      var imageUrls = [NSURL]()
      for imageUrl in reivew.reviewImageUrls {
        imageUrls.append(imageUrl.url())
      }
      let browser = IDMPhotoBrowser(photoURLs: imageUrls, animatedFromView: view)
      browser.setInitialPageIndex(UInt(showingImageIndex))
      browser.usePopAnimation = true
      browser.displayArrowButton = true
      browser.displayCounterLabel = true
      presentViewController(browser, animated: true, completion: nil)
    }
  }
}

extension ReviewListViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension ReviewListViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return "reviewCell"
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    super.configure(cell, indexPath: indexPath)
    if let cell = cell as? ReviewCell {
      cell.setUpCell(reviewList.list[indexPath.row] as! Review)
    }
  }
}

class ReviewCell: UITableViewCell {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  @IBOutlet var rateImageViews: [UIImageView]!
  @IBOutlet var imageViews: [LazyLoadingImageView]!
  @IBOutlet var imageButtons: [UIButton]!
  
  @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var reviewContentBottomLayoutConstraint: NSLayoutConstraint!
  
  func setUpCell(review: Review) {
    if let reviewId = review.id {
      contentView.tag = reviewId
    }
    
    userNameLabel.text = review.userName
    createdAtLabel.text = review.createdAt?.briefDateString()
    createdAtLabel.preferredMaxLayoutWidth = ViewControllerHelper.screenWidth - 30
    contentLabel.text = review.content
    
    for imageButton in imageButtons {
      imageButton.configureAlpha(review.reviewImageUrls.isInRange(imageButton.tag))
    }
    for imageView in imageViews {
      imageView.image = nil
      imageView.setLazyLoaingImage(review.reviewImageUrls.objectAtIndex(imageView.tag))
    }
    for imageView in rateImageViews {
      imageView.highlighted = review.rate >= imageView.tag
    }
    
    let imageViewHeight = (ViewControllerHelper.screenWidth - 46) / 4
    imageViewHeightLayoutConstraint.constant = imageViewHeight
    
    reviewContentBottomLayoutConstraint.constant = 20
    if review.reviewImageUrls.count > 0 {
      reviewContentBottomLayoutConstraint.constant += imageViewHeight + 8
    }
    if review.reviewImageUrls.count > 4 {
      reviewContentBottomLayoutConstraint.constant += imageViewHeight + 8
    }
  }
}