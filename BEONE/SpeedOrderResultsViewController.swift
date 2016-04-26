
import UIKit

class SpeedOrderResultsViewController: BaseViewController {
  
  @IBOutlet weak var speedOrderProductsScrollView: UIScrollView!
  @IBOutlet weak var productsScrollViewPageControl: UIPageControl!
  @IBOutlet weak var reviewShowLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var reviewButton: UIButton!
  @IBOutlet weak var allShowButton: UIButton!
  @IBOutlet weak var orderButton: UIButton!
  
  var address: Address?
  var availableDates: [String]?
  var productPropertyValueIds: [Int]?

  var contentViews = [UIView]()
  var products = Products()
  
  override func setUpData() {
    super.setUpData()
    products.isQuickOrder = true
    products.address = address
    products.availableDates = availableDates
    products.productPropertyValueIds = productPropertyValueIds
    products.get {
      self.productsScrollViewPageControl.configureAlpha(!self.products.list.isEmpty)
      self.productsScrollViewPageControl.numberOfPages = self.products.list.count + 1
      self.setUpContentViews()
      self.configureReviewLabels()
    }
  }
  
  private func setUpContentViews() {
    var previousView: UIView?
    for (index, product) in (products.list as! [Product]).enumerate() {
      let productView = UIView.loadFromNibName("SpeedOrderProductView") as! SpeedOrderProductView
      productView.delegate = self
      productView.layoutView(product)
      
      addCommonLayout(to: productView)
      if index == 0 {
        speedOrderProductsScrollView.addLeadingLayout(productView)
      } else {
        speedOrderProductsScrollView.addHorizontalLayout(previousView!, rightView: productView)
      }
      previousView = productView
    }
    
    if let speedOrderNoProductView = UIView.loadFromNibName("SpeedOrderNoProductView") {
      addCommonLayout(to: speedOrderNoProductView)
      speedOrderProductsScrollView.addTrailingLayout(speedOrderNoProductView)
      if products.list.count == 0 {
        speedOrderProductsScrollView.addLeadingLayout(speedOrderNoProductView)
      } else {
        speedOrderProductsScrollView.addHorizontalLayout(previousView!, rightView: speedOrderNoProductView)
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

extension SpeedOrderResultsViewController {
  @IBAction func showAllProductsViewButtonTapped() {
    if let productsViewController = UIViewController.viewController(.Products) as? ProductsViewController {
      productsViewController.products = products
      productsViewController.products.isQuickOrder = false
      productsViewController.products.address = nil
      productsViewController.products.availableDates = nil
      productsViewController.products.productPropertyValueIds = nil
      
      productsViewController.forSearchResult = true
      productsViewController.isSpeedOrder = true
      
      if let productPropertyValueIds = products.productPropertyValueIds {
        productsViewController.selectedProductPropertyValueIds = productPropertyValueIds
      }
      if let tagIds = products.tagIds {
        productsViewController.selectedTagIds = tagIds
      }
      if let minPrice = products.minPrice {
        productsViewController.minPrice = minPrice
      }
      if let maxPrice = products.maxPrice {
        productsViewController.maxPrice = maxPrice
      }
      showViewController(productsViewController, sender: nil)
    }
  }
}

extension SpeedOrderResultsViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let previousPage = productsScrollViewPageControl.currentPage
    productsScrollViewPageControl.currentPage = Int(scrollView.contentOffset.x / ViewControllerHelper.screenWidth)
    if previousPage != productsScrollViewPageControl.currentPage {
      configureReviewLabels()
    }
  }
  
  private func configureReviewLabels() {
    if let currentProduct = products.list.objectAtIndex(productsScrollViewPageControl.currentPage) as? Product {
      reviewShowLabel.configureAlpha(currentProduct.reviewCount != 0)
      reviewCountLabel.configureAlpha(currentProduct.reviewCount != 0)
      reviewButton.configureAlpha(currentProduct.reviewCount != 0)
      reviewCountLabel.text = "\(currentProduct.reviewCount)개의 유용한 후기가 있습니다"
      allShowButton.configureAlpha(false)
      orderButton.alpha = 1
    } else {
      orderButton.alpha = 0
      reviewShowLabel.alpha = 0
      reviewCountLabel.alpha = 0
      reviewButton.configureAlpha(false)
      allShowButton.configureAlpha(true)
    }
  }
}

extension SpeedOrderResultsViewController: ProductDelegate {
  @IBAction func productOrderButtonTapped() {
    showOptionView(products.list.objectAtIndex(productsScrollViewPageControl.currentPage)?.id,
                   rightOrdering: true)
  }
  
  func productButtonTapped(productId: Int) {
    showProductView(productId)
  }
}