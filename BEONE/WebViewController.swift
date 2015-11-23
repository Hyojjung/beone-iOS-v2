
import UIKit

let kPrivacyPolicyUrlString = "policies/privacy"
let kServicePolicyUrlString = "policies/service"

class WebViewController: BaseViewController {
  
  // MARK: - Property
  
  @IBOutlet weak var webView: UIWebView!
  var url: String?
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    automaticallyAdjustsScrollViewInsets = false
    addVerticalLayoutGuideLayout(webView)
  }
  
  override func setUpData() {
    super.setUpData()
    if let url = url {
      let request = NSMutableURLRequest(URL: url.url())
      request.addValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
      loadingView.show()
      webView.loadRequest(request)
    }
  }
}

// MARK: - UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {
  func webViewDidFinishLoad(_: UIWebView) {
    loadingView.hide()
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
    navigationType: UIWebViewNavigationType) -> Bool {
      if let url = request.URL?.absoluteString {
        if url.hasPrefix("beone://postcode.result") {
          let addressComponents = url.componentsSeparatedByString("&")
          NSNotificationCenter.defaultCenter().postNotificationName(kNotificationAddressSelected,
            object: nil,
            userInfo: [kNotificationKeyAddress: addressComponents])
          popView()
          return false
        }
      }
      return true
  }
  
  func webView(_: UIWebView, didFailLoadWithError error: NSError?) {
    // TODO: add network failure view
    print(error)
  }
}
