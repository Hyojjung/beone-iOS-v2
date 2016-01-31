
import UIKit

class OrderWebViewController: BaseViewController {
  
  @IBOutlet weak var orderWebView: UIWebView!
  var paymentTypeId: Int?
  var paymentInfoId: Int?
  var order: Order?
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let orderResultViewController = segue.destinationViewController as? OrderResultViewController, order = order {
      print(sender)
      for paymentInfo in order.paymentInfos {
        if self.paymentInfoId == paymentInfo.id {
          orderResultViewController.paymentInfo = paymentInfo
          break;
        }
      }
      orderResultViewController.orderResult = sender as? [String: AnyObject]
      orderResultViewController.order = order
    }
  }
  
  override func setUpView() {
    super.setUpView()
    AuthenticationHelper.refreshToken { (result) -> Void in
      if let order = self.order, paymentTypeId = self.paymentTypeId, paymentInfoId = self.paymentInfoId {
        let url = "https://devapi.beone.kr/users/\(MyInfo.sharedMyInfo().userId!)/orders/\(order.id!)/payment-infos/\(paymentInfoId)/transactions/new?paymentTypeId=\(paymentTypeId)"
        
        let orderWebViewUrlRequest = NSMutableURLRequest(URL: url.url())
        orderWebViewUrlRequest.setValue(MyInfo.sharedMyInfo().accessToken, forHTTPHeaderField: kHeaderAuthorizationKey)
        orderWebViewUrlRequest.setValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
        self.orderWebView.loadRequest(orderWebViewUrlRequest)
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
        order!.get({ () -> Void in
          self.performSegueWithIdentifier("From Order Web To Order Result", sender: parameter)
        })
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