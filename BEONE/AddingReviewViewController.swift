
import UIKit
import QBImagePickerController

class AddingReviewViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum AddingReviewTableViewSection: Int {
    case Item
    case ImageTitle
    case Image
    case AddImageButton
    case SubmitButton
    case Count
  }
  
  private let kAddingReviewTableViewCellIdentifiers = [
    "itemCell",
    "imageTitleCell",
    "imageCell",
    "addButtonCell",
    "submitButtonCell"]
  
  private let kAddingReviewTableViewCellHeights: [CGFloat] = [379, 81, 200, 79, 49]
  private let kMaxTotalImageCount = 8
  
  let review = Review()
  var reviewImages = [UIImage]()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
}

// MARK: - Action

extension AddingReviewViewController {
  
  @IBAction func deleteImageButtonTapped(sender: UIButton) {
    reviewImages.removeAtIndex(sender.tag)
    tableView.reloadData()
  }
  
  @IBAction func reviewRateButtonTapped(sender: UIButton) {
    if review.rate != sender.tag {
      review.rate = sender.tag
      tableView.reloadData()
    }
  }
  
  @IBAction func addReviewButtonTapped() {
    if review.content != nil && review.content?.characters.count > 20 {
      if reviewImages.count > 0 {
        ImageUploadHelper.uploadImages(reviewImages) {(imageUrls) -> Void in
          for imageUrl in imageUrls {
            self.review.reviewImageUrls.append(imageUrl)
          }
          self.postReview()
        }
      } else {
        postReview()
      }
    } else {
      showAlertView("20자 이상 작성해 주세요")
    }
  }
  
  private func postReview() {
    review.post({ (_) -> Void in
      self.popView()
      }, postFailure: { (error) -> Void in
        
    })
  }
  
  @IBAction func pickImageButtonTapped() {
    if reviewImages.count < kMaxTotalImageCount {
      let pickImageButton = ActionSheetButton(title: "사진선택") {(_) -> Void in
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.maximumNumberOfSelection = UInt(self.kMaxTotalImageCount - self.reviewImages.count)
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      }
      
      let takePictureButton = ActionSheetButton(title: "사진촬영") {(_) -> Void in
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)
      }
      
      showActionSheet([pickImageButton, takePictureButton])
    } else {
      showAlertView(NSLocalizedString("too many image", comment: "alert title"))
    }
  }
}

extension AddingReviewViewController: QBImagePickerControllerDelegate {
  
  func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
    var isInvalidSize = false
    var isNeededReloadTableView = false
    var imageCount = 0
    
    if let assets = assets as? [PHAsset] {
      let manager = PHImageManager.defaultManager()
      let option = PHImageRequestOptions()
      option.synchronous = true
      for asset in assets {
        if asset.mediaType == .Image && asset.pixelHeight > 300 && asset.pixelWidth > 300 &&
          asset.pixelHeight <= asset.pixelWidth * 10 && asset.pixelWidth <= asset.pixelHeight * 10 {
            imageCount += 1
            manager.requestImageForAsset(asset, targetSize: CGSize(width: 1280, height: 1280),
              contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                imageCount -= 1
                if let result = result {
                  isNeededReloadTableView = true
                  // image height 저장?
                  self.reviewImages.append(self.resizedImage(with: result))
                  if imageCount == 0 {
                    if isInvalidSize {
                      self.showAlertView(NSLocalizedString("invalid images size", comment: "alert title"))
                    }
                    if isNeededReloadTableView {
                      self.tableView.reloadData()
                    }
                  }
                }
            })
        } else {
          isInvalidSize = true
        }
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func resizedImage(with image: UIImage) -> UIImage {
    var resizedImage = image
    if resizedImage.size.width > 1280 || resizedImage.size.height > 1280 {
      if resizedImage.size.height >= resizedImage.size.width {
        let rect = CGRectMake(0, 0, resizedImage.size.width * 1280 / resizedImage.size.height, 1280)
        resizedImage = self.resizedImage(image, rect: rect)
      } else {
        let rect = CGRectMake(0, 0, 1280, resizedImage.size.height * 1280 / resizedImage.size.width)
        resizedImage = self.resizedImage(image, rect: rect)
      }
    }
    return resizedImage
  }
  
  func resizedImage(image: UIImage, rect:CGRect) -> UIImage {
    UIGraphicsBeginImageContext(rect.size)
    image.drawInRect(rect)
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
}

extension AddingReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    if image.size.height <= image.size.width * 10 && image.size.width <= image.size.height * 10 {
      reviewImages.append(resizedImage(with: image))
      tableView.reloadData()
    } else {
      showAlertView(NSLocalizedString("invalid image size", comment: "alert title"))
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension AddingReviewViewController: UITextViewDelegate {
  
  func textViewDidChange(textView: UITextView) {
    review.content = textView.text
  }
}

extension AddingReviewViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kAddingReviewTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == AddingReviewTableViewSection.Image.rawValue {
      let imageSize = reviewImages[indexPath.row].size
      return imageSize.height * (ViewControllerHelper.screenWidth - 16) / imageSize.width + 12
    }
    return kAddingReviewTableViewCellHeights[indexPath.section]
  }
}

extension AddingReviewViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return AddingReviewTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == AddingReviewTableViewSection.Image.rawValue {
      return reviewImages.count
    } else if section == AddingReviewTableViewSection.AddImageButton.rawValue
      && reviewImages.count >= kMaxTotalImageCount {
      return 0
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath),
      forIndexPath: indexPath)
    if let cell = cell as? ReviewableOrderItemReviewCell {
      cell.setUpCell(review)
    } else if let cell = cell as? ReviewImageCell {
      cell.setUpCell(reviewImages[indexPath.row], index: indexPath.row)
    }
    return cell
  }
}

class ReviewableOrderItemReviewCell: UITableViewCell {
  
  private let kReviewDescriptionStrings =
  ["별로예요", "좀 아쉽네요", "좋아요", "만족합니다", "감동이에요!"]
  
  @IBOutlet weak var itemImageView: LazyLoadingImageView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var itemSubTitleLabel: UILabel!
  @IBOutlet weak var rateDescriptionLabel: UILabel!
  @IBOutlet weak var reviewContentTextView: UITextView!
  @IBOutlet weak var rate1Button: UIButton!
  @IBOutlet weak var rate2Button: UIButton!
  @IBOutlet weak var rate3Button: UIButton!
  @IBOutlet weak var rate4Button: UIButton!
  @IBOutlet weak var rate5Button: UIButton!
  
  func setUpCell(review: Review) {
    itemImageView.setLazyLoaingImage(review.orderItem?.productImageUrl)
    itemTitleLabel.text = review.orderItem?.productTitle
    itemSubTitleLabel.text = review.orderItem?.productSubtitle
    rateDescriptionLabel.text = kReviewDescriptionStrings[review.rate - 1]
    reviewContentTextView.text = review.content
    setUpRateButtons(review.rate)
  }
  
  func setUpRateButtons(rate: Int) {
    rate1Button.selected = rate >= 1
    rate2Button.selected = rate >= 2
    rate3Button.selected = rate >= 3
    rate4Button.selected = rate >= 4
    rate5Button.selected = rate >= 5
  }
}

class ReviewImageCell: UITableViewCell {
  
  @IBOutlet weak var reviewImageView: UIImageView!
  @IBOutlet weak var deleteReviewButton: UIButton!
  
  func setUpCell(image: UIImage, index: Int) {
    reviewImageView.image = image
    deleteReviewButton.tag = index
  }
}