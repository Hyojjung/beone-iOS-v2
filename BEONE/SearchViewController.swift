
import UIKit

class SearchViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SearchTableViewSection: Int {
    case ProductcCount
    case Price
    case Tag
    case Usage
    case MoreUsageButton
    case Color
    case SearchButton
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = ["productCountCell",
    "priceCell",
    "productPropertyCell",
    "productPropertyCell",
    "moreUsageButtonCell",
    "colorCell",
    "searchButtonCell"]
  
  // MARK: - Property
  
  var productPropertyList = ProductPropertyList()
  var tagList = TagList()
  var appSetting = AppSetting()
  var selectedProductPropertyValueIds = [Int]()
  var selectedTagIds = [Int]()
  var showingMore = false
  
  override func setUpData() {
    productPropertyList.get { () -> Void in
      self.tableView.reloadData()
    }
    tagList.get { () -> Void in
      self.tableView.reloadData()
    }
    appSetting.get { () -> Void in
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
    if let cell = cell as? ProductPropertyCell {
      if indexPath.section == SearchTableViewSection.Tag.rawValue {
        cell.configureCell(tagList.name,
          subTitle: tagList.subTitle,
          searchValues: tagList.list,
          selectedSearchValueIds: selectedTagIds)
      } else if let productProperty = productProperty(indexPath) {
        cell.configureCell(productProperty.name,
          subTitle: productProperty.subTitle,
          searchValues: productProperty.values,
          selectedSearchValueIds: selectedProductPropertyValueIds,
          displayType: productProperty.displayType)
      }
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
    if let cell = cell as? ProductPropertyCell {
      if indexPath.section == SearchTableViewSection.Tag.rawValue {
        return cell.calculatedHeight(tagList.list, subTitle: tagList.subTitle)
      } else if let productProperty = productProperty(indexPath) {
        return cell.calculatedHeight(productProperty.values, subTitle: productProperty.subTitle,
          displayType: productProperty.displayType)
      }
    }
    return nil
  }
}

class ProductPropertyCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var valuesView: UIView!
  
  func configureCell(name: String?, subTitle: String?, searchValues: [BaseModel], selectedSearchValueIds: [Int],
    displayType: ProductPropertyDisplayType? = nil) {
      nameLabel.text = name
      subTitleLabel.text = subTitle
      valuesView.subviews.forEach { $0.removeFromSuperview() }
      let productPropertyNameTypeValuesView = ProductPropertyValuesView()
      productPropertyNameTypeValuesView.layoutView(searchValues,
        selectedProductPropertyValueIds: selectedSearchValueIds, displayType: displayType)
      valuesView.addSubViewAndEdgeLayout(productPropertyNameTypeValuesView)
  }
  
  func calculatedSubTitleHeight(description: String?) -> CGFloat {
    let descriptionLabel = UILabel()
    var frame = descriptionLabel.frame
    frame.size.width = ViewControllerHelper.screenWidth - 24
    descriptionLabel.numberOfLines = 0
    descriptionLabel.frame = frame
    descriptionLabel.font = UIFont.systemFontOfSize(13)
    descriptionLabel.text = description
    descriptionLabel.sizeToFit()
    
    return descriptionLabel.frame.height
  }
  
  func calculatedHeight(searchValues: [BaseModel], subTitle: String?, displayType: ProductPropertyDisplayType? = nil) -> CGFloat {
    var height = 97 + Int(calculatedSubTitleHeight(subTitle))
    let rowCount = (searchValues.count - 1) / kRowValueButtonCount + 1
    let viewHeight = displayType == .Color ? kValueColorViewHeight : kValueButtonHeight
    let verticalInterval = displayType == .Color ? kValueColorViewVerticalInterval : kValueButtonVerticalInterval
    height += rowCount * Int(viewHeight)
    height += (rowCount - 1) * Int(verticalInterval)
    return CGFloat(height)
  }
}
