
import UIKit

class TemplatesViewController: BaseTableViewController {
  
  let templates = Templates()
  let favoriteProducts: Products = {
    let products = Products()
    products.type = .Favorite
    return products
  }()
  
  // MARK: - BaseViewController
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    
    tableView.registerNib(UINib(nibName: kProductCoupleTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kProductCoupleTemplateCellIdentifier)
    tableView.registerNib(UINib(nibName: kProductSingleTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kProductSingleTemplateCellIdentifier)
    tableView.registerNib(UINib(nibName: kButtonTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kButtonTemplateCellIdentifier)
    tableView.registerNib(UINib(nibName: kBannerTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kBannerTemplateCellIdentifier)
    tableView.registerNib(UINib(nibName: kShopTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kShopTemplateCellIdentifier)
    tableView.registerNib(UINib(nibName: kImageTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kImageTemplateCellIdentifier)
  }
  
  override func setUpData() {
    if templates.type != .AppView || templates.id != nil {
      super.setUpData()
      templates.get {
        if self.title?.isEmpty != false {
          self.title = self.templates.title
          self.sendViewTitle()
        }
        self.tableView.reloadData()
      }
      favoriteProducts.get {
        self.tableView.reloadData()
      }
    }
  }
}

extension TemplatesViewController: SchemeDelegate {
  func handleScheme(with id: Int) {
    templates.id = id
    setUpData()
    SchemeHelper.schemeStrings.removeAtIndex(0)
    handleScheme()
  }
}

// MARK: - UITableViewDataSource

extension TemplatesViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return templates.filterdTemplates.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension TemplatesViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if let cellIdentifier = templates.filterdTemplates[indexPath.row].type?.cellIdentifier() {
      return cellIdentifier
    }
    fatalError("invalid template type")
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? TemplateCell {
      if let cell = cell as? ProductCoupleTemplateCell {
        cell.favoriteProductDelegate = self
      } else if let cell = cell as? ProductSingleTemplateCell {
        cell.favoriteProductDelegate = self
      }
      cell.configureCell(templates.filterdTemplates[indexPath.row])
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? TemplateCell {
      return cell.calculatedHeight(templates.filterdTemplates[indexPath.row])
    }
    return nil
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let template = templates.filterdTemplates[indexPath.row]
    let cellIdentifier = template.type?.cellIdentifier()
    if cellIdentifier == kProductCoupleTemplateCellIdentifier {
      return kProductCoupleTemplateCellHeight + template.verticalMargin()
    } else if cellIdentifier == kProductSingleTemplateCellIdentifier {
      return 297 + template.verticalMargin()
    } else if cellIdentifier == kShopTemplateCellIdentifier {
      return 271 + template.verticalMargin()
    } else if cellIdentifier == kButtonTemplateCellIdentifier && template.content.imageUrl == nil {
      if let textSize = template.content.textSize {
        return textSize + template.verticalMargin() + template.content.padding.top + template.content.padding.bottom
      } else if template.content.imageUrl != nil {
        return template.content.ratio * ViewControllerHelper.screenWidth + template.verticalMargin()
      }
    } else if cellIdentifier == kBannerTemplateCellIdentifier {
      return template.content.ratio * ViewControllerHelper.screenWidth + template.verticalMargin()
    } else if cellIdentifier == kImageTemplateCellIdentifier {
      return template.content.ratio * ViewControllerHelper.screenWidth + template.verticalMargin()
    }
    if let tableView = tableView as? DynamicHeightTableView {
      return tableView.heightForBasicCell(indexPath)
    }
    return 0
  }
}

extension TemplatesViewController: FavoriteProductDelegate {
  func toggleFavoriteProduct(sender: UIView, productId: Int, isFavorite: Bool) {
    tableView.reloadData()
  }
}
