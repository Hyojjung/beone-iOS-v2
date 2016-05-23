
import UIKit

class OrderWebViewController: BaseViewController {
  
  @IBOutlet weak var orderWebView: UIWebView!

  var paymentTypeId: Int?
  var paymentInfoId: Int?
  var order: Order?

  override func setUpData() {
    super.setUpData()
    loadingView.show()
    AuthenticationHelper.refreshToken { (result) -> Void in
      self.configureWebView()
    }
  }
  
  func configureWebView() {
    if let order = order, paymentTypeId = paymentTypeId, paymentInfoId = paymentInfoId {
      var url = kBaseApiUrl + "users/\(MyInfo.sharedMyInfo().userId!)"
      url += "/orders/\(order.id!)/payment-infos/\(paymentInfoId)/transactions/new?paymentTypeId=\(paymentTypeId)"
      
      let orderWebViewUrlRequest = NSMutableURLRequest(URL: url.url())
      orderWebViewUrlRequest.setValue(MyInfo.sharedMyInfo().accessToken, forHTTPHeaderField: kHeaderAuthorizationKey)
      orderWebViewUrlRequest.setValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
      orderWebView.loadRequest(orderWebViewUrlRequest)
    }
  }
}

extension OrderWebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if let url = request.URL?.absoluteString {
      if url.hasPrefix(kPaymentScheme) {
        handleUrl(url)
      }
    }
    return true
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    print(error)
  }
  
  func handleUrl(url: String) {
    if url.hasPrefix("cmbeone://payment.cancelled") {
      showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderResultType.Canceled.rawValue])
    } else if let order = order, paymentInfoId = paymentInfoId {
      showOrderResultView(order, paymentInfoId: paymentInfoId, orderResult: url.jsonObject())
    }
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    loadingView.hide()
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    loadingView.show()
  }
}