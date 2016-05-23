
import UIKit

class SpeedOrderResultsViewController: BaseViewController {
  
  @IBOutlet weak var speedOrderProductsScrollView: UIScrollView!
  @IBOutlet weak var productsScrollViewPageControl: UIPageControl!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var allShowButton: UIButton!
  @IBOutlet weak var orderButton: UIButton!
  @IBOutlet weak var reviewView: UIView!
  
  var address: Address?
  var availableDates: [String]?
  var productPropertyValueIds: [Int]?
  
  var contentViews = [UIView]()
  var products = Products()
  
  override func setUpData() {
    super.setUpData()
    address?.getLocationId({ locationId in
      self.products.isQuickOrder = true
      self.products.locationId = locationId
      self.products.availableDates = self.availableDates
      self.products.productPropertyValueIds = self.productPropertyValueIds
      self.products.get {
        self.productsScrollViewPageControl.configureAlpha(!self.products.list.isEmpty)
        self.productsScrollViewPageControl.numberOfPages = self.products.list.count + 1
        self.setUpContentViews()
        self.configureReviewLabels()
      }
      }, failure: {
        let action = Action()
        action.type = .Method
        action.content = "popView"
        ViewControllerHelper.topRootViewController()?.showAlertView("배송 가능한 지역이 아닙니다.",
          confirmAction: action,
          delegate: self)
    })
  }
  
  deinit {
    BEONEManager.speedOrderLocationId = nil
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
  
  @IBAction func showReviewViewButtonTapped() {
    if let reviewsViewController = UIViewController.viewController("ProductDetail",
                                                                   viewIdentifier: "ReviewView") as? ReviewsViewController,
      let product = products.list.objectAtIndex(productsScrollViewPageControl.currentPage) as? Product {
      reviewsViewController.isPresented = true
      reviewsViewController.reviews.list = product.reviews
      presentViewController(reviewsViewController, animated: true, completion: nil)
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
      reviewView.hidden = currentProduct.reviews.count != 0 ? false : true
      reviewCountLabel.text = "\(currentProduct.reviews.count)개의 유용한 후기가 있습니다"
      allShowButton.configureAlpha(false)
      orderButton.hidden = false
    } else {
      orderButton.hidden = true
      reviewView.hidden = true
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