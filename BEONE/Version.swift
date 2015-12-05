
import UIKit

let kBundleIdentifier = "CFBundleIdentifier"
let kCFBundleShortVersionString = "CFBundleShortVersionString"

let kAppPropertyKeyResultCount = "resultCount"
let kAppPropertyKeyResults = "results"
let kAppPropertyKeyBOVersion = "version"

class Version: BaseModel {
  var needUpdate = false
  var version: String?
  
  override init() {
    super.init()
    if let infoDictionary = infoDictionary() {
      version = infoDictionary[kCFBundleShortVersionString] as? String
    }
  }
  
  override func fetchUrl() -> String {
    if let appID = infoDictionary()?[kBundleIdentifier] {
      return "http://itunes.apple.com/lookup?bundleId=\(appID)"
    }
    return "noVersion"
  }
  
  override func fetchSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
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
        self.postNotification(kNotificationFetchAppStoreVersionSuccess)
      }
    }
  }
  
  func infoDictionary() -> [String : AnyObject]? {
    return NSBundle.mainBundle().infoDictionary
  }
}
