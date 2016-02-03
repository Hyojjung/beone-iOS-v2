
class ProductCell: UITableViewCell {
  @IBOutlet weak var mainImageView: LazyLoadingImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  func configureCell(product: Product) {
    mainImageView.setLazyLoaingImage(product.mainImageUrl)
    titleLabel.text = product.title
    actualPriceLabel.text = product.actualPrice.priceNotation(.English)
    priceLabel.attributedText = product.priceAttributedString()
  }
}

class DeliveryInfoCell: UITableViewCell {
  @IBOutlet weak var selectedDeliveryNameLabel: UILabel!
  @IBOutlet weak var availableDeliveryDatesLabel: UILabel!
  
  func configureCell(productOrderableInfo: ProductOrderableInfo?) {
    selectedDeliveryNameLabel.text = productOrderableInfo == nil ?
      NSLocalizedString("select delivery type", comment: "picker title") : productOrderableInfo?.deliveryType.name
    if let productOrderableInfo = productOrderableInfo {
      availableDeliveryDatesLabel.text = productOrderableInfo.availableDatesString()
    } else {
      availableDeliveryDatesLabel.text = NSLocalizedString("select delivery type", comment: "picker title")
    }
  }
  
  func calculatedHeight(productOrderableInfo: ProductOrderableInfo?) -> CGFloat {
    if let productOrderableInfo = productOrderableInfo {
      var height = CGFloat(99)
      let label = UILabel()
      label.font = UIFont.systemFontOfSize(15)
      label.text = productOrderableInfo.availableDatesString()
      label.setWidth(ViewControllerHelper.screenWidth - 112)
      
      height += label.frame.height
      return height
    }
    return 113
  }
}

class CartItemCountCell: UITableViewCell {
  @IBOutlet weak var selectedQuantityLabel: UILabel!
  @IBOutlet weak var quantitySelectButton: UIButton!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var optionLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
  func configureCell(cartItem: CartItem, indexPath: NSIndexPath) {
    selectedQuantityLabel.text = "\(cartItem.quantity)개"
    productNameLabel.text = cartItem.product.title
    optionLabel.text = cartItem.selectedOption?.optionString()
    quantitySelectButton.tag = indexPath.row
    deleteButton.tag = indexPath.row
  }
  
  func calculatedHeight(cartItem: CartItem) -> CGFloat {
    var height = CGFloat(149)
    let label = UILabel()
    label.font = UIFont.systemFontOfSize(15)
    label.text = cartItem.selectedOption?.optionString()
    label.setWidth(ViewControllerHelper.screenWidth - 30)

    height += label.frame.height
    return height
  }
}

class ButtonCell: UITableViewCell {
  @IBOutlet weak var addCartItemButton: UIButton!
  
  func configureCell(isOrdering: Bool) {
    let buttonTitle = isOrdering ?
      NSLocalizedString("order right now", comment: "button title") :
      NSLocalizedString("add to cart", comment: "button title")
    addCartItemButton.setTitle(buttonTitle, forState: .Normal)
    addCartItemButton.setTitle(buttonTitle, forState: .Highlighted)
  }
}


class OptionCell: UITableViewCell {
  
  weak var delegate: AnyObject?
  
  @IBOutlet weak var optionView: OptionView!
  @IBOutlet weak var addCarItemButton: UIButton!
  @IBOutlet weak var optionViewBottomMarginLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(productOptionSetList: ProductOptionSetList?, needButton: Bool) {
    if let productOptionSetList = productOptionSetList {
      optionView.delegate = delegate
      optionView.layoutView(productOptionSetList)
    }
    addCarItemButton.enabled = needButton
    addCarItemButton.configureAlpha(needButton)
    optionViewBottomMarginLayoutConstraint.constant = needButton ? 89 : 20
  }
  
  func calculatedHeight(productOptionSetList: ProductOptionSetList?, needButton: Bool) -> CGFloat {
    var height = needButton ? CGFloat(115) : CGFloat(46)
    if let productOptionSetList = productOptionSetList {
      for (index, productOptionSet) in productOptionSetList.list.enumerate() {
        if let productOptionSet = productOptionSet as? ProductOptionSet {
          height += 40
          if index != 0 {
            height += 10
          }
          for option in productOptionSet.options {
            if option.isSelected {
              for optionItem in option.optionItems {
                if let type = optionItem.type {
                  switch type {
                  case .Text:
                    height += 108
                  case .String:
                    height += 59
                  case .Select:
                    height += 40
                  }
                  height += 10
                }
              }
            }
          }
        }
        if index != productOptionSetList.list.count - 1 {
          height += 11
        }
      }
    }
    return height
  }
}