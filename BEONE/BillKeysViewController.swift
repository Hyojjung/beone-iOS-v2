
import UIKit

class BillKeysViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum BillKeyTableViewSection: Int {
    case Card
    case AddCardButton
    case Info
    case Count
  }
  
  private let kBillKeyTableViewCellIdentifiers = [
    "cardCell",
    "addCardCell",
    "infoCell"]
  
  // MARK: - Variable
  
  var order = Order()
  private var billKeys = BillKeys()
  private var selectedBillKey: BillKey?
  private var paymentInfo: PaymentInfo?
  var paymentInfoId: Int?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = true
  }
  
  override func setUpView() {
    super.setUpView()
    title = "카드선택"
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    paymentInfo = order.paymentInfos.model(paymentInfoId) as? PaymentInfo
    billKeys.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  @IBAction func deleteCardButtonTapped(sender: UIButton) {
    billKeys.list[sender.tag].remove({() -> Void in
      self.billKeys.get { () -> Void in
        self.tableView.reloadData()
      }
    })
  }
  
  @IBAction func selectCardButtonTapped(sender: UIButton) {
    selectedBillKey = billKeys.list[sender.tag] as? BillKey
    tableView.reloadData()
  }
  
  @IBAction func payButtonTapped() {
    if let paymentInfo = paymentInfo {
      paymentInfo.paymentType.id = PaymentTypeId.Card.rawValue
      paymentInfo.billKeyInfoId = self.selectedBillKey?.id
      paymentInfo.post({ (_) -> Void in
        self.showOrderResultView(self.order, paymentInfoId: paymentInfo.id!)
        }, postFailure: { (_) -> Void in
          self.showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderStatus.Failure.rawValue])
      })
    }
  }
}

extension BillKeysViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return BillKeyTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == BillKeyTableViewSection.Card.rawValue {
      return billKeys.list.count
    } else if section == BillKeyTableViewSection.AddCardButton.rawValue && billKeys.list.count >= 3 {
      return 0
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? BillKeyCell {
      cell.configureCell(billKeys.list[indexPath.row] as! BillKey, selectedBillKey: selectedBillKey, row: indexPath.row)
    }
    return cell
  }
}

extension BillKeysViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kBillKeyTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
}

class BillKeyCell: UITableViewCell {
  
  @IBOutlet weak var billKeyImageView: UIImageView!
  @IBOutlet weak var cardNumberLabel: UILabel!
  @IBOutlet weak var cardNameLabel: UILabel!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var cardButton: UIButton!
  @IBOutlet weak var deleteCardButton: UIButton!
  
  func configureCell(billKey: BillKey, selectedBillKey: BillKey?, row: Int) {
    let imageName = billKey.type == .Personal ? "image_card_white" : "image_card_dark"
    billKeyImageView.image = UIImage(imageLiteral: imageName)
    cardNameLabel.text = billKey.desc
    cardNumberLabel.text = billKey.cardNumber
    selectButton.selected = billKey.id == selectedBillKey?.id
    selectButton.tag = row
    cardButton.tag = row
    deleteCardButton.tag = row
  }
}
