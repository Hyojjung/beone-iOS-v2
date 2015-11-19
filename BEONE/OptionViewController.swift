//
//  OptionViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 19..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class OptionViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum OptionTableViewSection: Int {
    case Product
    case CartItemInfo
    case Button
    case Count
  }
  
  private let kOptionTableViewCellIdentifiers = ["productCell", "cartItemInfoCell", "buttonCell"]

  // MARK: - Property

  var product = BEONEManager.selectedProduct
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationFetchProductSuccess, object: nil)
  }

  override func setUpData() {
    super.setUpData()
    product?.fetch()
  }
}

extension OptionViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OptionTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kOptionTableViewCellIdentifiers[indexPath.section],
      forIndexPath: indexPath)
    switch OptionTableViewSection(rawValue: indexPath.section)! {
    case .Product:
      configureProductCell(cell)
    case .CartItemInfo:
      print("cartItemInfo")
    case .Button:
      print("button")
    default:
      break
    }
    return cell
  }

  private func configureProductCell(cell: UITableViewCell) {
    if let cell = cell as? ProductCell, product = product {
      cell.configureCell(product)
    }
  }
}

class ProductCell: UITableViewCell {
  @IBOutlet weak var mainImageView: LazyLoadingImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  func configureCell(product: Product) {
    mainImageView.setLazyLoaingImage(product.mainImageUrl)
    titleLabel.text = product.title
    actualPriceLabel.text = product.actualPrice?.priceNotation(.English)
    priceLabel.attributedText = product.originalPriceAttributedString()
  }
}

class CartItemInfoCell: UITableViewCell {
  @IBOutlet weak var selectedDeliveryNameLabel: UILabel!
  @IBOutlet weak var selectedCountLabel: UILabel!
}