
import UIKit
import ActionSheetPicker_3_0

class FirstViewController: TemplateListViewController {
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var viewnavigationItem: UINavigationItem!
  
  private var mainTitleView = UIView.loadFromNibName(kMainTitleViewNibName) as! MainTitleView
  
  @IBAction func signInButtonTapped() {
    showSigningView()
  }
  
  @IBAction func product(sender: AnyObject) {
    let product = Product()
    product.id = 2
    BEONEManager.selectedProduct = product
    
    showViewController("ProductDetail", viewIdentifier: "productDetailView")
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBarHidden = false
  }
  
  // MARK: - BaseViewController
  
  override func setUpData() {
    super.setUpData()
    BEONEManager.sharedLocationList.fetch()
    navigationController?.navigationBarHidden = true
    templateList.fetch()
    LocationList().fetch()
  }
  
  override func setUpView() {
    super.setUpView()
    self.viewnavigationItem.titleView = mainTitleView
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(templateList, selector: "fetch",
      name: kNotificationGuestAuthenticationSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLocationPicker",
      name: kNotificationLocationButtonTapped, object: nil)
  }
}

// MARK: - Private Methods 

extension FirstViewController {
  func addTitleViewConstraints() {
    navigationBar.addCenterXLayout(view)
    navigationBar.addBottomLayout(view)
  }
}

// MARK: - Observer Actions

extension FirstViewController {
  func showLocationPicker() {
    var initialSelection = 0
    for (index, location) in (BEONEManager.sharedLocationList.list as! [Location]).enumerate() {
      if location == BEONEManager.selectedLocation {
        initialSelection = index
      }
    }
    
    let locationActionSheet =
    ActionSheetStringPicker(title: NSLocalizedString("select quantity", comment: "picker title"),
      rows: BEONEManager.sharedLocationList.locationNames(),
      initialSelection: initialSelection,
      doneBlock: { (_, selectedIndex, _) -> Void in
        if initialSelection != selectedIndex {
          BEONEManager.selectedLocation = BEONEManager.sharedLocationList.list[selectedIndex] as? Location
          self.mainTitleView.locationLabel.text = BEONEManager.selectedLocation?.name
        }
      }, cancelBlock: nil,
      origin: view)
    locationActionSheet.showActionSheetPicker()
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

