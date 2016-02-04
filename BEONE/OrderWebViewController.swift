
import UIKit

class OrderWebViewController: BaseViewController {
  
  @IBOutlet weak var orderWebView: UIWebView!

  var paymentTypeId: Int?
  var paymentInfoId: Int?
  var order: Order?

  override func setUpView() {
    super.setUpView()
    loadingView.show()
    AuthenticationHelper.refreshToken { (result) -> Void in
      self.configureWebView()
    }
  }
  
  func configureWebView() {
    if let order = self.order, paymentTypeId = self.paymentTypeId, paymentInfoId = self.paymentInfoId {
      var url = "https://devapi.beone.kr/users/\(MyInfo.sharedMyInfo().userId!)"
      url += "/orders/\(order.id!)/payment-infos/\(paymentInfoId)/transactions/new?paymentTypeId=\(paymentTypeId)"
      
      let orderWebViewUrlRequest = NSMutableURLRequest(URL: url.url())
      orderWebViewUrlRequest.setValue(MyInfo.sharedMyInfo().accessToken, forHTTPHeaderField: kHeaderAuthorizationKey)
      orderWebViewUrlRequest.setValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
      self.orderWebView.loadRequest(orderWebViewUrlRequest)
    }
  }
}

extension OrderWebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let url = request.URL?.absoluteString
    let urlProtocol = url?.componentsSeparatedByString("://").first
    print(url)
    if urlProtocol == "cmbeone" {
      if url == "cmbeone://payment.cancelled" {
        showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderStatus.Canceled.rawValue])
      } else if let order = order, paymentInfoId = paymentInfoId {
        showOrderResultView(order, paymentInfoId: paymentInfoId, orderResult: url?.jsonObject())
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