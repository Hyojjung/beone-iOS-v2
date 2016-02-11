
import UIKit

class InquiryEditViewController: BaseViewController {
  
  @IBOutlet weak var inquiryTextView: UITextView!
  @IBOutlet weak var inquiryAddButton: UIButton!
  @IBOutlet weak var inquiryScrollview: KeyboardScrollView!
  
  var productId: Int?
  var inquiry = Inquiry()
  
  override func setUpView() {
    super.setUpView()

    addTopLayoutGuideLayout(inquiryScrollview)
    automaticallyAdjustsScrollViewInsets = false
    
    let title = inquiry.id != nil ?
      NSLocalizedString("modify inquiry", comment: "titl") : NSLocalizedString("add inquiry", comment: "title")
    self.title = title
    inquiryAddButton.setTitle(title, forState: .Normal)
    inquiryAddButton.setTitle(title, forState: .Highlighted)
    inquiryTextView.text = inquiry.content
  }
  
  @IBAction func addInquiryButtonTapped() {
    endEditing()
    if inquiryTextView.text == nil || inquiryTextView.text.isEmpty {
      showAlertView(NSLocalizedString("enter inquiry", comment: "alert title"))
    } else {
      inquiry.content = inquiryTextView.text
      if inquiry.id == nil {
        inquiry.productId = productId
        inquiry.post({ (_) -> Void in
          self.popView()
        })
      } else {
        inquiry.put({ (_) -> Void in
          self.popView()
        })
      }
    }
  }
}
