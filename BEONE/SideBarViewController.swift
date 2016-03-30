
import UIKit

protocol SideBarPositionMoveDelegate {
  func handlemovePosition()
}

class SideBarViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SideBarTableViewSection: Int {
    case Top
    case UserInfo
    case Buttons
    case ProgressingOrderCount
    case LatestOrderDeliveryItemSet
    case Anniversary
    case RecentProductsCount
    case RecentProduct
    case NoRecentProduct
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = ["topCell",
                                                 "userInfoCell",
                                                 "buttonsCell",
                                                 "progressingOrderCountCell",
                                                 "orderItemSetCell",
                                                 "anniversaryCell",
                                                 "recentProductsCountCell",
                                                 "recentProductCell",
                                                 "noRecentProductCell"]
  
  var sideBarViewContents = SideBarViewContents()
  lazy var sideBarGestureView: UIView = {
    let sideBarGestureView = UIView()
    sideBarGestureView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    return sideBarGestureView
  }()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    revealViewController().delegate = self
  }
  
  override func setUpData() {
    super.setUpData()
    sideBarViewContents.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setUpData()
  }
}

extension SideBarViewController {
  @IBAction func recommendProductButtonTapped() {
    setUpScheme("/speed-order")
  }
  
  @IBAction func productButtonTapped(sender: UIButton) {
    setUpScheme("/product/\(sender.tag)")
  }
  
  @IBAction func orderItemButtonTapped() {
    if let orderId = sideBarViewContents.orderDeliveryItemSets.first?.order.id {
      setUpScheme("/order/\(orderId)")
    }
  }
  
  @IBAction func showRecentProductsViewButtonTapped() {
    setUpScheme("/recent-products")
  }
  
  @IBAction func kakaoInquiryButtonTapped(sender: AnyObject) {
    if let kakaoPlus = BEONEManager.globalViewContents.kakaoPlus {
      UIApplication.sharedApplication().openURL(kakaoPlus.url())
    }
  }
  
  @IBAction func topCellButtonTapped() {
    if MyInfo.sharedMyInfo().isUser() {
      setUpScheme("/profile")
    } else {
      showSigningView()
    }
  }
  
  @IBAction func deliveryTrackingButtonTapped() {
    if let url = sideBarViewContents.orderDeliveryItemSets.first?.orderDeliveryInfo.deliveryTrackingUrl {
      let webViewController = WebViewController()
      webViewController.url = url
      webViewController.isModal = true
      presentViewController(webViewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func orderDoneButtonTapped() {
    sideBarViewContents.orderDeliveryItemSets.first?.put({ (_) -> Void in
      self.sideBarViewContents.get({ () -> Void in
        self.tableView.reloadData()
      })
    })
  }
  
  private func setUpScheme(scheme: String) {
    revealViewController().revealToggleAnimated(true)
    SchemeHelper.setUpScheme(scheme)
  }
}

extension SideBarViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    if let navi = revealController.frontViewController as? UINavigationController,
      topViewController = navi.topViewController as? UITabBarController,
      selectedViewController = topViewController.selectedViewController {
      if position == .Right {
        sideBarGestureView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        selectedViewController.view.addSubViewAndEdgeLayout(sideBarGestureView)
      } else if position == .Left {
        sideBarGestureView.removeFromSuperview()
        if let selectedViewController = selectedViewController as? SideBarPositionMoveDelegate {
          selectedViewController.handlemovePosition()
        }
      }
    }
  }
}

extension SideBarViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SideBarTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? LatestOrderDeliveryItemSetCell {
      cell.configureCell(sideBarViewContents.orderDeliveryItemSets[indexPath.row])
    } else if let cell = cell as? UserInfoCell {
      cell.configureCell()
    } else if let cell = cell as? CountCell {
      if cell.reuseIdentifier == "progressingOrderCountCell" {
        cell.configureCell(sideBarViewContents.progressingOrderCount)
      } else {
        cell.configureCell(sideBarViewContents.recentProducts.list.count)
      }
    } else if let cell = cell as? SideBarProductCell {
      cell.configureCell(sideBarViewContents.recentProducts.list[indexPath.row] as! Product)
    } else if let cell = cell as? AnniveraryCell {
      cell.setUpCell(sideBarViewContents.anniversary!)
    } else if let cell = cell as? ButtonsCell {
      cell.setUpCell(sideBarViewContents)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SideBarTableViewSection.LatestOrderDeliveryItemSet.rawValue {
      return sideBarViewContents.orderDeliveryItemSets.count
    } else if section == SideBarTableViewSection.ProgressingOrderCount.rawValue &&
      sideBarViewContents.progressingOrderCount == 0 {
      return 0
    } else if section == SideBarTableViewSection.RecentProductsCount.rawValue &&
      sideBarViewContents.progressingOrderCount != 0 {
      return 0
    } else if section == SideBarTableViewSection.RecentProduct.rawValue {
      return sideBarViewContents.recentProducts.list.count
    } else if section == SideBarTableViewSection.Anniversary.rawValue && sideBarViewContents.anniversary == nil {
      return 0
    } else if section == SideBarTableViewSection.NoRecentProduct.rawValue &&
      (sideBarViewContents.progressingOrderCount != 0 || sideBarViewContents.recentProducts.list.count != 0) {
      return 0
    }
    return 1
  }
}

extension SideBarViewController: DynamicHeightTableViewDelegate {
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    switch (SideBarTableViewSection(rawValue: indexPath.section)!) {
    case .Top:
      return 64
    case .UserInfo:
      return 64
    case .Buttons:
      return 158
    case .ProgressingOrderCount, .RecentProductsCount:
      return 40
    case .LatestOrderDeliveryItemSet:
      if sideBarViewContents.orderDeliveryItemSets.first?.isCompletable == true {
        return 221
      } else {
        return 168
      }
    case .RecentProduct:
      return 84
    case .Anniversary:
      return 130
    case .NoRecentProduct:
      if sideBarViewContents.anniversary == nil {
        return ViewControllerHelper.screenHeight - 64 - 64 - 158 - 40
      } else {
        return ViewControllerHelper.screenHeight - 64 - 64 - 158 - 40 - 130
      }
    default:
      return nil
    }
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
}

class UserInfoCell: UITableViewCell {
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var myInfoLabel: UILabel!
  
  func configureCell() {
    emailLabel.text = MyInfo.sharedMyInfo().email
    pointLabel.text = nil
    if MyInfo.sharedMyInfo().isUser() {
      myInfoLabel.text = "수정"
      if let pointNumber = MyInfo.sharedMyInfo().point {
        pointLabel.text = "\(Int(pointNumber).priceNotation(.None)) point"
      }
    } else {
      myInfoLabel.text = "로그인"
    }
  }
}

class LatestOrderDeliveryItemSetCell: UITableViewCell {
  
  @IBOutlet weak var orderCodeLabel: UILabel!
  @IBOutlet weak var receiverNameLabel: UILabel!
  @IBOutlet weak var orderNameLabel: UILabel!
  
  @IBOutlet weak var itemPreparingStatusImageView: UIImageView!
  @IBOutlet weak var firstLineImageView: UIImageView!
  @IBOutlet weak var deliveringStatusImageView: UIImageView!
  @IBOutlet weak var secondLineImageView: UIImageView!
  @IBOutlet weak var deliveryDoneStatusImageView: UIImageView!
  
  @IBOutlet weak var itemPreparingLabel: UILabel!
  @IBOutlet weak var itemPreparingTimeLabel: UILabel!
  @IBOutlet weak var deliveringLabel: UILabel!
  @IBOutlet weak var deliveringTimeLabel: UILabel!
  @IBOutlet weak var deliveryDoneLabel: UILabel!
  @IBOutlet weak var deliveryDoneTimeLabel: UILabel!
  @IBOutlet weak var buttonViewHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var orderDoneButtonLeadingLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(orderItemSet: OrderableItemSet) {
    orderCodeLabel.text = orderItemSet.order.orderCode
    orderNameLabel.text = orderItemSet.title
    if let receiverName = orderItemSet.order.address.receiverName {
      receiverNameLabel.text = "\(receiverName)님"
    } else {
      receiverNameLabel.text = nil
    }
    
    if let firstProgress = orderItemSet.progresses.first {
      configureViews(firstProgress,
                     statusImageView: itemPreparingStatusImageView,
                     lineImageView: nil,
                     statusNameLabel: itemPreparingLabel,
                     statusTimeLabel: itemPreparingTimeLabel)
    }
    if orderItemSet.progresses.count > 2 {
      configureViews(orderItemSet.progresses[1],
                     statusImageView: deliveringStatusImageView,
                     lineImageView: firstLineImageView,
                     statusNameLabel: deliveringLabel,
                     statusTimeLabel: deliveringTimeLabel)
    }
    if let lastProgress = orderItemSet.progresses.last {
      configureViews(lastProgress,
                     statusImageView: deliveryDoneStatusImageView,
                     lineImageView: secondLineImageView,
                     statusNameLabel: deliveryDoneLabel,
                     statusTimeLabel: deliveryDoneTimeLabel)
    }
    
    if orderItemSet.orderDeliveryInfo.traceDisplayType == .WebView {
      orderDoneButtonLeadingLayoutConstraint.constant = (ViewControllerHelper.screenWidth - 55) / 2 + 2
    } else {
      orderDoneButtonLeadingLayoutConstraint.constant = 0
    }
    if orderItemSet.isCompletable {
      buttonViewHeightLayoutConstraint.constant = 53
    } else {
      buttonViewHeightLayoutConstraint.constant = 0
    }
  }
  
  private func configureViews(progress: OrderItemSetProgress,
                              statusImageView: UIImageView, lineImageView: UIImageView?, statusNameLabel: UILabel, statusTimeLabel: UILabel) {
    configureLineImageView(lineImageView, progressStatus: progress.progressStatus)
    configureStatusImageView(statusImageView, progressStatus: progress.progressStatus)
    configureStatusNameLabel(statusNameLabel, progress: progress)
    configureStatusTimeLabel(statusTimeLabel, progress: progress)
  }
  
  private func configureStatusTimeLabel(statusTimeLabel: UILabel, progress: OrderItemSetProgress) {
    if let progressedAt = progress.progressedAt {
      statusTimeLabel.text = progressedAt
    } else {
      statusTimeLabel.text = "-"
    }
  }
  
  private func configureStatusNameLabel(statusNameLabel: UILabel, progress: OrderItemSetProgress) {
    statusNameLabel.text = progress.name
    
    let labelColor = progress.progressStatus != .Waiting ? taupe: warmGrey
    statusNameLabel.textColor = labelColor
  }
  
  private func configureStatusImageView(statusImageView: UIImageView, progressStatus: ProgressType) {
    switch progressStatus {
    case .Waiting:
      statusImageView.image = UIImage(named: "imageSidebarStateUndo")
    case .Progressing:
      statusImageView.image = UIImage(named: "imageSidebarStateIng")
    case .Done:
      statusImageView.image = UIImage(named: "imageSidebarStateDone")
    }
  }
  
  private func configureLineImageView(lineImageView: UIImageView?, progressStatus: ProgressType) {
    lineImageView?.image = progressStatus != .Waiting ?
      UIImage(named: "imageSidebarLineOn") :
      UIImage(named: "imageSidebarLineOff")
  }
}

class CountCell: UITableViewCell {
  
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var moreButton: UIButton?
  
  func configureCell(count: Int) {
    countLabel.text = "\(count)"
    moreButton?.configureAlpha(count != 0)
  }
}

class SideBarProductCell: UITableViewCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productActualPriceLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productButton: UIButton!
  
  func configureCell(product: Product) {
    productImageView.setLazyLoaingImage(product.mainImageUrl)
    productNameLabel.text = product.title
    productActualPriceLabel.text = product.actualPrice.priceNotation(.English)
    productPriceLabel.attributedText = product.priceAttributedString()
    if let productId = product.id {
      productButton.tag = productId
    }
  }
}

class AnniveraryCell: UITableViewCell {
  
  @IBOutlet weak var leftDayLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  func setUpCell(anniversary: Anniversary) {
    leftDayLabel.text = anniversary.leftDayString()
    nameLabel.text = anniversary.name
    descriptionLabel.text = anniversary.desc
  }
}

class ButtonsCell: UITableViewCell {
  
  @IBOutlet weak var anniversariesCountLabel: UILabel!
  
  func setUpCell(sideBarViewContents: SideBarViewContents) {
    anniversariesCountLabel.text = "\(sideBarViewContents.userAnniversariesCount)"
  }
}