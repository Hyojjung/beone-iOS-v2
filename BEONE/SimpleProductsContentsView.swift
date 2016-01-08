
import UIKit

class SimpleProductsContentsView: TemplateCell {
  @IBOutlet weak var firstProductView: UIView!
  @IBOutlet weak var secondProductView: UIView!
    
  lazy var firstProductsContentsView: ProductSingleTemplateCell = {
    let simpleProductView = UIView.loadFromNibName(kSimpleProductViewNibName) as! SimpleProductView
    return simpleProductView
  }()
  
  lazy var secondProductsContentsView: ProductSingleTemplateCell = {
    let simpleProductView = UIView.loadFromNibName(kSimpleProductViewNibName) as! SimpleProductView
    return simpleProductView
  }()
  
  func configureView(products: [Product]) {
    if firstProductsContentsView.superview == nil {
      firstProductView.addSubViewAndEdgeLayout(firstProductsContentsView)
    }
    firstProductsContentsView.configureView(products.first)
    
    if products.count >= kSimpleProductColumn {
      if secondProductsContentsView.superview == nil {
        secondProductView.addSubViewAndEdgeLayout(secondProductsContentsView)
      }
      secondProductsContentsView.configureView(products.last)
    } else {
      secondProductsContentsView.removeFromSuperview()
    }
  }
}
