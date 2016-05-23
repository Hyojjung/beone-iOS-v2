
import UIKit

class InquiriesViewController: BaseTableViewController {
  
  @IBOutlet weak var noInquiryLabel: UILabel!
  
  let inquiries: Inquiries = {
    let inquiries = Inquiries()
    return inquiries
  }()
  var product: Product?
  
  override func setUpData() {
    super.setUpData()
    inquiries.productId = product?.id
    inquiries.get {
      self.noInquiryLabel.configureAlpha(self.inquiries.total == 0)
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    super.setUpView()
    title = "상품문의"
    tableView.dynamicHeightDelgate = self
  }
  
  @IBAction func editInquiryButtonTapped(sender: UIButton) {
    if let inquiry = inquiries.model(sender.tag) as? Inquiry {
      let inquiryEditViewController = InquiryEditViewController(nibName: "InquiryEditViewController", bundle: nil)
      inquiryEditViewController.inquiry = inquiry
      showViewController(inquiryEditViewController, sender: nil)
    }
  }
  
  @IBAction func deleteInquiryButtonTapped(sender: UIButton) {
    if let inquiry = inquiries.model(sender.tag) as? Inquiry {
      inquiry.remove({
        self.inquiries.get({
          self.tableView.reloadData()
        })
      })
    }
  }
  
  @IBAction func addInquiryButtonTapped() {
    let inquiryEditViewController = InquiryEditViewController(nibName: "InquiryEditViewController", bundle: nil)
    inquiryEditViewController.productId = product?.id
    showUserViewController(inquiryEditViewController)
  }
}

extension InquiriesViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inquiries.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    if let cell = cell as? InquiryCell {
      cell.configureCell(inquiries.list[indexPath.row] as! Inquiry, shop: product?.shop)
    }
    return cell
  }
}

extension InquiriesViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return "myInquiryCell"
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? InquiryCell {
      return cell.calculatedHeight(inquiries.list[indexPath.row] as! Inquiry)
    }
    return nil
  }
}

class InquiryCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var replyView: UIView!
  @IBOutlet var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var shopLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var reviewViewHeightLayoutConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.makeCircleView()
  }
  
  func calculatedHeight(inquiry: Inquiry) -> CGFloat {
    return contentViewHeight(inquiry) + answerViewHeight(inquiry)
  }
  
  func contentLabelHeight(inquiry: Inquiry) -> CGFloat {
    let contentLabel = UILabel()
    contentLabel.font = UIFont.systemFontOfSize(15)
    contentLabel.text = inquiry.content
    contentLabel.setWidth(ViewControllerHelper.screenWidth - 66)
    return  contentLabel.frame.height
  }
  
  func contentViewHeight(inquiry: Inquiry) -> CGFloat {
    var height = CGFloat(50)
    height += contentLabelHeight(inquiry)
    if inquiry.userId == MyInfo.sharedMyInfo().userId?.integerValue ||
      !(inquiry.status == .Answered || inquiry.status == .BlindRequesting) {
      return height + 54
      
    }
    return height
  }
  
  func answerViewHeight(inquiry: Inquiry) -> CGFloat {
    if inquiry.status == .Answered || inquiry.status == .BlindRequesting {
      let answerLabel = UILabel()
      answerLabel.font = UIFont.systemFontOfSize(15)
      answerLabel.text = inquiry.answer
      answerLabel.setWidth(ViewControllerHelper.screenWidth - 66)
      return answerLabel.frame.height + 66
    }
    return 0
  }
  
  func configureCell(inquiry: Inquiry, shop: Shop?) {
    if inquiry.status == .Answered || inquiry.status == .BlindRequesting {
      replyView.removeConstraint(heightConstraint)
    } else {
      replyView.addConstraint(heightConstraint)
    }
    reviewViewHeightLayoutConstraint.constant = contentViewHeight(inquiry)
    emailLabel.text = inquiry.userEmail
    contentLabel.text = inquiry.content
    shopLabel.text = shop?.name
    answerLabel.text = inquiry.answer
    configureButton(inquiry)
  }
  
  private func configureButton(inquiry: Inquiry) {
    editButton.tag = inquiry.id!
    deleteButton.tag = inquiry.id!
    deleteButton.configureAlpha(inquiry.userId == MyInfo.sharedMyInfo().userId?.integerValue)
    editButton.configureAlpha(inquiry.userId == MyInfo.sharedMyInfo().userId?.integerValue && inquiry.status == .Waiting)
  }
}