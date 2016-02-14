
import UIKit

class SpeedOrderResultsViewController: BaseViewController {
  
  @IBOutlet weak var speedOrderProductsScrollView: UIScrollView!
  @IBOutlet weak var productsScrollViewPageControl: UIPageControl!
  @IBOutlet weak var reviewShowLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var reviewButton: UIButton!
  @IBOutlet weak var allShowButton: UIButton!
  
  var contentViews = [UIView]()
  var productList = ProductList()
  
  override func setUpData() {
    productList.get { () -> Void in
      self.productsScrollViewPageControl.numberOfPages = self.productList.list.count + 1
      self.setUpContentViews()
    }
  }
  
  private func setUpContentViews() {
    var beforeView: UIView?
    for (index, product) in (productList.list as! [Product]).enumerate() {
      let productView = UIView.loadFromNibName("SpeedOrderProductView") as! SpeedOrderProductView
      productView.delegate = self
      productView.layoutView(product)
      
      addCommonLayout(to: productView)
      if index == 0 {
        speedOrderProductsScrollView.addLeadingLayout(productView)
      } else {
        speedOrderProductsScrollView.addHorizontalLayout(beforeView!, rightView: productView)
      }
      beforeView = productView
    }
    
    if let speedOrderNoProductView = UIView.loadFromNibName("SpeedOrderNoProductView") {
      addCommonLayout(to: speedOrderNoProductView)
      speedOrderProductsScrollView.addTrailingLayout(speedOrderNoProductView)
      if productList.list.count == 0 {
        speedOrderProductsScrollView.addLeadingLayout(speedOrderNoProductView)
      } else {
        speedOrderProductsScrollView.addHorizontalLayout(beforeView!, rightView: speedOrderNoProductView)
      }
    }
  }
  
  private func addCommonLayout(to speedOrderProductsScrollViewSubview: UIView) {
    speedOrderProductsScrollView.addSubViewAndEnableAutoLayout(speedOrderProductsScrollViewSubview)
    speedOrderProductsScrollView.addTopLayout(speedOrderProductsScrollViewSubview)
    speedOrderProductsScrollView.addBottomLayout(speedOrderProductsScrollViewSubview)
    speedOrderProductsScrollView.addWidthLayout(view: speedOrderProductsScrollViewSubview)
    speedOrderProductsScrollView.addEqualHeightLayout(speedOrderProductsScrollView,
      view2: speedOrderProductsScrollViewSubview)
  }
}

extension SpeedOrderResultsViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(scrollView: UIScrollView) {
    let beforePage = productsScrollViewPageControl.currentPage
    productsScrollViewPageControl.currentPage = Int(scrollView.contentOffset.x / ViewControllerHelper.screenWidth)
    if beforePage != productsScrollViewPageControl.currentPage {
      configureReviewLabels()
    }
  }
  
  private func configureReviewLabels() {
    if productList.list.count > productsScrollViewPageControl.currentPage {
      if let currentProduct = productList.list[productsScrollViewPageControl.currentPage] as? Product {
        reviewShowLabel.configureAlpha(currentProduct.reviewCount != 0)
        reviewCountLabel.configureAlpha(currentProduct.reviewCount != 0)
        reviewButton.configureAlpha(currentProduct.reviewCount != 0)
        reviewCountLabel.text = "\(currentProduct.reviewCount)개의 유용한 후기가 있습니다"
        allShowButton.configureAlpha(false)
      }
    } else {
      reviewShowLabel.alpha = 0
      reviewCountLabel.alpha = 0
      reviewButton.configureAlpha(false)
      allShowButton.configureAlpha(true)
    }
  }
}

extension SpeedOrderResultsViewController: ProductDelegate {
  func productOrderButtonTapped(productId: Int) {
    showOptionView(productId, rightOrdering: true)
  }
  
  func productButtonTapped(productId: Int) {
    showProductView(productId)
  }
}