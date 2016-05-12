
import UIKit

class AdvertisementViewController: UIViewController {

  @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageView: LazyLoadingImageView!
  var advertisement: Advertisement?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    imageView.setLazyLoaingImage(advertisement?.imageUrl)
    imageViewHeightLayoutConstraint.constant = 2.0 / 3.0 * ViewControllerHelper.screenHeight
  }
  
  @IBAction func reshowAdvertisementButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    if sender.selected {
      NSUserDefaults.standardUserDefaults().setObject(advertisement?.id,
                                                      forKey: kNotShowingAdvertisementIdUserDefaultKey)
    } else {
      NSUserDefaults.standardUserDefaults().removeObjectForKey(kNotShowingAdvertisementIdUserDefaultKey)
    }
  }
  
  @IBAction func closeButtonTapped() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func popupActionButtonTapped() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: { 
      self.advertisement?.action.action()
    })
  }
}
