
import UIKit

class SearchViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SearchTableViewSection: Int {
    case ProductcCount
    case Price
    case Usage
    case MoreUsageButton
    case Color
    case SearchButton
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = ["productCountCell",
    "priceCell",
    "usageCell",
    "moreUsageButtonCell",
    "colorCell",
    "searchButtonCell"]
  
  // MARK: - Property
  
  var productPropertyList = ProductPropertyList()
  var selectedProductPropertyValueIds = [Int]()
  var showingMore = false
  
  override func setUpData() {
    productPropertyList.get { (productPropertyList) -> Void in
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    self.tableView.dynamicHeightDelgate = self
  }
}

// MARK: - Actions

extension SearchViewController {
  
  @IBAction func moreButtonTapped() {
    showingMore = true
    tableView.reloadData()
  }
}

extension SearchViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SearchTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SearchTableViewSection.MoreUsageButton.rawValue {
      if let productProperty = productPropertyList.list.first as? ProductProperty {
        if productProperty.values.count < kPartialValuesCount || showingMore {
          return 0
        }
      }
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? ProductPropertyCell, productProperty = productProperty(indexPath) {
      cell.configureCell(productProperty, selectedProductPropertyValueIds: selectedProductPropertyValueIds)
    }
    return cell
  }
  
  private func productProperty(indexPath: NSIndexPath) -> ProductProperty? {
    if indexPath.section == SearchTableViewSection.Usage.rawValue {
      if let productProperty = productPropertyList.list.first as? ProductProperty {
        if !showingMore && productProperty.values.count > kPartialValuesCount {
          return productProperty.productPropertyWithPartValues()
        } else {
          return productProperty
        }
      }
    } else if indexPath.section == SearchTableViewSection.Color.rawValue {
      if let productProperty = productPropertyList.list.last as? ProductProperty {
        return productProperty
      }
    }
    return nil
  }
}

extension SearchViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? ProductPropertyCell, productProperty = productProperty(indexPath) {
      return cell.calculatedHeight(productProperty)
    }
    return nil
  }
}

class UsageCell: ProductPropertyCell {

  override func calculatedHeight(productProperty: ProductProperty) -> CGFloat {
    var height = 83 + Int(super.calculatedHeight(productProperty))
    let rowCount = (productProperty.values.count - 1) / kRowValueButtonCount + 1
    height += rowCount * Int(kValueButtonHeight)
    height += (rowCount - 1) * Int(kValueButtonVerticalInterval)
    return CGFloat(height)
  }
}

class ColorCell: ProductPropertyCell {
  
  override func calculatedHeight(productProperty: ProductProperty) -> CGFloat {
    var height = 97 + Int(super.calculatedHeight(productProperty))
    let rowCount = (productProperty.values.count - 1) / kRowValueButtonCount + 1
    height += rowCount * Int(kValueColorViewHeight)
    height += (rowCount - 1) * Int(kValueColorViewVerticalInterval)
    return CGFloat(height)
  }
}

class ProductPropertyCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var valuesView: UIView!
  
  func configureCell(productProperty: ProductProperty, selectedProductPropertyValueIds: [Int]) {
    nameLabel.text = productProperty.name
    subTitleLabel.text = productProperty.subTitle
    valuesView.subviews.forEach { $0.removeFromSuperview() }
    let productPropertyNameTypeValuesView = ProductPropertyNameTypeValuesView()
    productPropertyNameTypeValuesView.layoutView(productProperty,
      selectedProductPropertyValueIds: selectedProductPropertyValueIds)
    valuesView.addSubViewAndEdgeLayout(productPropertyNameTypeValuesView)
  }
  
  func calculatedHeight(productProperty: ProductProperty) -> CGFloat {
    let descriptionLabel = UILabel()
    var frame = descriptionLabel.frame
    frame.size.width = ViewControllerHelper.screenWidth - 24
    descriptionLabel.numberOfLines = 0
    descriptionLabel.frame = frame
    descriptionLabel.font = UIFont.systemFontOfSize(13)
    descriptionLabel.text = productProperty.subTitle
    descriptionLabel.sizeToFit()
    
    return descriptionLabel.frame.height
  }
}
