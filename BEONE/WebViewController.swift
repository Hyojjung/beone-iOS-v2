
import UIKit

class WebViewController: BaseViewController {
  @IBOutlet weak var webView: UIWebView!
  var url: String?
  
  // MARK: - Override Methods
  
  override func setUpView() {
    super.setUpView()
    automaticallyAdjustsScrollViewInsets = false
    view.addConstraint(NSLayoutConstraint(item: webView,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: topLayoutGuide,
      attribute: .Bottom,
      multiplier: 1,
      constant: 0))
    view.addConstraint(NSLayoutConstraint(item: webView,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: bottomLayoutGuide,
      attribute: .Top,
      multiplier: 1,
      constant: 0))
  }
  
  override func setUpData() {
    if let url = url {
      let request = NSMutableURLRequest(URL: NSURL(string:url.trimedString())!)
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
          // TODO: - handle address result
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
