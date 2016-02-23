
import UIKit

let kBundleIdentifier = "CFBundleIdentifier"
let kCFBundleShortVersionString = "CFBundleShortVersionString"

let kAppPropertyKeyResultCount = "resultCount"
let kAppPropertyKeyResults = "results"
let kAppPropertyKeyBOVersion = "version"

class Version: BaseModel {
  var needUpdate = false
  var version: String? = {
    if let infoDictionary = NSBundle.mainBundle().infoDictionary {
      return infoDictionary[kCFBundleShortVersionString] as? String
    }
    return nil
  }()
  
  override func get(getSuccess: (() -> Void)? = nil) {
    let url: String
    if let appID = NSBundle.mainBundle().infoDictionary?[kBundleIdentifier] {
      url = "http://itunes.apple.com/lookup?bundleId=\(appID)"
    } else {
      url = "noVersion"
    }
    NetworkHelper.requestGet(url, parameter: getParameter(), success: { (result) -> Void in
      if result[kAppPropertyKeyResultCount] as? Int >= 1 {
        if let results = result[kAppPropertyKeyResults] as? [[String: AnyObject]], firstResult = results.first {
          let appStoreVersion = firstResult[kAppPropertyKeyBOVersion] as? String
          if let appStoreVersionArray = appStoreVersion?.componentsSeparatedByString("."),
            currentVersionArray = self.version?.componentsSeparatedByString(".") {
              for (index, appStoreVersionComponent) in appStoreVersionArray.enumerate() {
                if currentVersionArray.count > index {
                  if Int(currentVersionArray[index]) < Int(appStoreVersionComponent) {
                    self.needUpdate = true
                    break;
                  } else if Int(currentVersionArray[index]) > Int(appStoreVersionComponent) {
                    self.needUpdate = false
                    break;
                  }
                }
              }
          }
        }
      }
      getSuccess?()
      }, failure: nil)
  }
}
