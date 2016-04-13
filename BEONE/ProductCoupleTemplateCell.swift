
import UIKit

class ProductCoupleTemplateCell: TemplateCell {
  
  @IBOutlet weak var firstProductView: ProductCoupleView!
  @IBOutlet weak var secondProductView: ProductCoupleView!

  func configureView(products: [Product]) {
    configureDefaulStyle()
    firstProductView.configureView(products.first)
    secondProductView.configureAlpha(products.count > 1)
    if products.count > 1 {
      secondProductView.configureView(products.last)
    }
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let products = template.content.models as? [Product] {
      configureView(products)
    }
  }
}
