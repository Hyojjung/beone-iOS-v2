
import UIKit

class OrderWebViewController: BaseViewController {
  
  @IBOutlet weak var orderWebView: UIWebView!
  var paymentTypeId: Int?
  var paymentInfoId: Int?
  var order: Order?
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let orderResultViewController = segue.destinationViewController as? OrderResultViewController {
      print(sender)
      orderResultViewController.orderingCartItemIds = order?.cartItemIds
      orderResultViewController.orderResult = sender as? [String: AnyObject]
    }
  }
  
  override func setUpView() {
    super.setUpView()
    AuthenticationHelper.refreshToken { (result) -> Void in
      if let order = self.order, paymentTypeId = self.paymentTypeId {
        var mainPaymentInfo: PaymentInfo?
        for paymentInfo in order.paymentInfos {
          if paymentInfo.isMainPayment {
            mainPaymentInfo = paymentInfo
            break
          }
        }
        let selectedPaymentInfoId = self.paymentInfoId != nil ? self.paymentInfoId : mainPaymentInfo?.id
        if let selectedPaymentInfoId = selectedPaymentInfoId {
          let url = "https://devapi.beone.kr/users/\(MyInfo.sharedMyInfo().userId!)/orders/\(order.id!)/payment-infos/\(selectedPaymentInfoId)/transactions/new?paymentTypeId=\(paymentTypeId)"
          
          let orderWebViewUrlRequest = NSMutableURLRequest(URL: url.url())
          orderWebViewUrlRequest.setValue(MyInfo.sharedMyInfo().accessToken, forHTTPHeaderField: kHeaderAuthorizationKey)
          orderWebViewUrlRequest.setValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
          self.orderWebView.loadRequest(orderWebViewUrlRequest)
        }
      }
    }
  }
}

extension OrderWebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let url = request.URL?.absoluteString
    let urlProtocol = url?.componentsSeparatedByString("://").first
    print(url)
    if urlProtocol == "cmbeone" {
      if let orderResultQuery = url?.componentsSeparatedByString("?").last {
        let orderResultComponents = orderResultQuery.componentsSeparatedByString("&")
        var parameter = [String: AnyObject]()
        for orderResultComponent in orderResultComponents {
          if let orderResultKey = orderResultComponent.componentsSeparatedByString("=").first {
            parameter[orderResultKey] = orderResultComponent.componentsSeparatedByString("=").last
          }
        }
        parameter["orderId"] = order?.id
        performSegueWithIdentifier("From Order Web To Order Result", sender: parameter)
      }
    }
    return true
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    loadingView.hide()
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    loadingView.show()
  }
}