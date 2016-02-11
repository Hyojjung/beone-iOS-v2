
import UIKit

let kPrivacyPolicyUrlString = "policies/privacy"
let kServicePolicyUrlString = "policies/service"

protocol AddressDelegate: NSObjectProtocol {
  func handleAddress(address: Address)
}

class WebViewController: BaseViewController {
  
  // MARK: - Property
  
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var webView: UIWebView!
  var url: String?
  weak var addressDelegate: AddressDelegate?
  var isModal = false
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    closeButton.configureAlpha(isModal)
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
  
  @IBAction func closeButtonTapped() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
          postNotification(kNotificationAddressSelected, userInfo: [kNotificationKeyAddress: url])
          var addressObject = url.componentsSeparatedByString("?").last
          addressObject = addressObject?.stringByRemovingPercentEncoding
          addressObject = addressObject?.stringByReplacingOccurrencesOfString("+", withString: " ")
          var addressComponentsDictionary = [String: String]()
          if let addressComponents = addressObject?.componentsSeparatedByString("&") {
            for addressComponent in addressComponents {
              let component = addressComponent.componentsSeparatedByString("=")
              if let first = component.first {
                addressComponentsDictionary[first] = component.last
              }
            }
            let address = Address()
            address.assign(addressComponentsDictionary)
            addressDelegate?.handleAddress(address)
          }
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
