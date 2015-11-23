
import UIKit

class FirstViewController: TemplateListViewController {  
  @IBAction func signInButtonTapped() {
    showSigningView()
  }
  
  @IBAction func product(sender: AnyObject) {
    let product = Product()
    product.id = 2
    BEONEManager.selectedProduct = product
    
    let signingStoryboard = UIStoryboard(name: "ProductDetail", bundle: nil)
    let signingViewController = signingStoryboard.instantiateViewControllerWithIdentifier("productDetailView")
    navigationController?.pushViewController(signingViewController, animated: true)
  }
  
  override func setUpData() {
    super.setUpData()
    templateList.fetch()
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(templateList, selector: "fetch",
      name: kNotificationGuestAuthenticationSuccess, object: nil)
  }
}

// MARK: - UITableViewDataSource

extension FirstViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return templateList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kTemplateTableViewCellIdentifier, forIndexPath: indexPath) as! TemplateTableViewCell
    cell.configureCell(templateList.list[indexPath.row] as! Template)
    return cell
  }
}

