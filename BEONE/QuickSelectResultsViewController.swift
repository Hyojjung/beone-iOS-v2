
import UIKit

class QuickSelectResultsViewController: BaseViewController {
  
  @IBOutlet weak var quickSelectProductsScrollView: UIScrollView!

  var contentViews = [UIView]()
  var productList = ProductList()
  
  override func setUpData() {
    productList.get { () -> Void in
      self.setUpContentViews()
    }
  }
  
  private func setUpContentViews() {
    var beforeView: UIView?
    for (index, product) in (productList.list as! [Product]).enumerate() {
      let productView = UIView.loadFromNibName("QuickSelectProductView") as! QuickSelectProductView
      productView.layoutView(product)
      quickSelectProductsScrollView.addSubViewAndEnableAutoLayout(productView)
      quickSelectProductsScrollView.addTopLayout(productView)
      quickSelectProductsScrollView.addBottomLayout(productView)
      quickSelectProductsScrollView.addWidthLayout(view: productView)
      if index == 0 {
        quickSelectProductsScrollView.addLeadingLayout(productView)
      } else {
        quickSelectProductsScrollView.addHorizontalLayout(beforeView!, rightView: productView)
      }
      if index == productList.list.count - 1 {
        quickSelectProductsScrollView.addTrailingLayout(productView)
      }
      beforeView = productView
    }
  }
}

extension QuickSelectResultsViewController: UIScrollViewDelegate {

}
