
import UIKit

class Review: BaseModel {

  var orderItem: OrderableItem?
  var content: String?
  var rate = 5
  var reviewImageUrls = [String]()
  
  override func postUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/reviews"
    }
    return "users/:userId/reviews"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["rate"] = rate
    parameter["content"] = content
    parameter["reviewImageUrls"] = reviewImageUrls
    parameter["orderItemId"] = orderItem?.id
    return parameter
  }
}

class ImageUploadHelper {
  
  static func uploadImages(images: [UIImage], uploadSuccess: ([String]) -> Void) {
    var contentTypes = [[String: String]]()
    for image in images {
      if let contentType = contentType(image) {
        contentTypes.appendObject(["contentType": contentType])
      }
    }
    
    NetworkHelper.requestPost("signed-urls?resourceType=image&collection=reviews",
      parameter: contentTypes, success: { (result) -> Void in
        if let data = result[kNetworkResponseKeyData] as? [[String: AnyObject]] {
          var imageCount = images.count
          var imageUrls = [String]()
          
          for (index, image) in images.enumerate() {
            let imageUrlInfo = data[index]
            NetworkHelper.uploadData(imageUrlInfo["url"] as? String, contentType: self.contentType(image)!, parameters: UIImagePNGRepresentation(image)!, success: { (result) -> Void in
              imageCount -= 1
              imageUrls.appendObject(imageUrlInfo["key"] as? String)
              if imageCount == 0 {
                uploadSuccess(imageUrls)
              }
              }, failure: nil)
          }
        }
      })
  }
  
  private static func contentType(image: UIImage) -> String? {
    let data = UIImagePNGRepresentation(image)
    if let data = data {
      var c = [UInt32](count: 1, repeatedValue: 0)
      data.getBytes(&c, length: 1)
      switch (c[0]) {
      case 0xFF:
        return "image/jpeg"
      case 0x89:
        return "image/png"
      case 0x47:
        return "image/gif"
      case 0x4D, 0x49:
        return "image/tiff"
      default:
        return nil
      }
    }
    return nil
  }
  
  // TODO : JPG 일때는?
}
