
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
  
  var billKeyList = BillKeyList()
  var order = Order()
  var selectedBillKey: BillKey?
  var paymentInfo: PaymentInfo?
  var paymentSuccess = false
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let orderResultViewController = segue.destinationViewController as? OrderResultViewController {
      orderResultViewController.paymentInfo = paymentInfo
      orderResultViewController.isSuccess = paymentSuccess
      orderResultViewController.order = order
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    billKeyList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  @IBAction func deleteCardButtonTapped(sender: UIButton) {
    billKeyList.list[sender.tag].remove { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  @IBAction func selectCardButtonTapped(sender: UIButton) {
    selectedBillKey = billKeyList.list[sender.tag] as? BillKey
    tableView.reloadData()
  }
  
  @IBAction func payButtonTapped() {
    order.post({ (result) -> Void in
      if let result = result, data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
        self.order.assignObject(data)
        
        self.order.mainPaymentInfo?.paymentType.id = PaymentTypeId.Card.rawValue
        self.order.mainPaymentInfo?.billKeyInfoId = self.selectedBillKey?.id
        self.paymentInfo = self.order.mainPaymentInfo
        self.order.mainPaymentInfo?.post({ (result) -> Void in
          self.paymentSuccess = true
          self.order.get({ () -> Void in
            self.performSegueWithIdentifier("From Bill Key List To Order Result", sender: nil)            
          })
          }, postFailure: { (_) -> Void in
            
        })
      }
      }, postFailure: { (_) -> Void in
    })
  }
}

extension BillKeysViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return BillKeyTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == BillKeyTableViewSection.Card.rawValue {
      return billKeyList.list.count
    } else if section == BillKeyTableViewSection.AddCardButton.rawValue && billKeyList.list.count >= 3 {
      return 0
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? BillKeyCell {
      cell.configureCell(billKeyList.list[indexPath.row] as! BillKey, selectedBillKey: selectedBillKey, row: indexPath.row)
    }
    return cell
  }
}

extension BillKeysViewController: DynamicHeightTableViewProtocol {
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
    cardNameLabel.text = billKey.name
    cardNumberLabel.text = billKey.cardNumber
    selectButton.selected = billKey.id == selectedBillKey?.id
    selectButton.tag = row
    cardButton.tag = row
    deleteCardButton.tag = row
  }
}
