
import UIKit

let kProductCoupleTemplateCellHeight: CGFloat = 328

class ProductCoupleTemplateCell: TemplateCell {
  
  @IBOutlet weak var firstProductView: ProductCoupleView!
  @IBOutlet weak var secondProductView: ProductCoupleView!
  weak var favoriteProductDelegate: FavoriteProductDelegate?

  func configureView(products: [Product]) {
    secondProductView.configureAlpha(products.count > 1)

    firstProductView.configureView(products.first)
    if products.count > 1 {
      secondProductView.configureView(products.last)
    }
    firstProductView.favoriteProductDelegate = favoriteProductDelegate
    secondProductView.favoriteProductDelegate = favoriteProductDelegate
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let products = template.content.models as? [Product] {
      configureView(products)
    }
  }
}
