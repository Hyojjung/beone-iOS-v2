
import UIKit

class ProductCoupleTemplateCell: TemplateCell {
  @IBOutlet weak var firstProductView: ProductCoupleView!
  @IBOutlet weak var secondProductView: ProductCoupleView!
  
  func configureView(products: [Product]) {
    contentView.layoutMargins = UIEdgeInsetsZero
    templateContentsView.layoutMargins = UIEdgeInsetsZero
    
    firstProductView.configureView(products.first)
    secondProductView.alpha = products.count > 1 ? 1 : 0
    if products.count > 1 {
      secondProductView.configureView(products.last)
    }
  }
  
  override func configureCell(template: Template, forCalculateHeight: Bool) {
    configureDefaulStyle()
    if let products = template.content.models as? [Product] {
      if !forCalculateHeight {
        configureView(products)
      }
    }
  }
}
