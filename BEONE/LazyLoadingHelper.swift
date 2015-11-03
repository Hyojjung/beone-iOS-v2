//
//  LazyLoadingHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit
import SDWebImage

enum ImageType: Int {
  case Original
  case Thumbnail
  case Basic
}

class LazyLoadingImageView: UIImageView {
  deinit {
    image = nil
    sd_cancelCurrentImageLoad()
  }
  
  
  private func setLazyLoaingImage(urlString: String, imageType: ImageType) {
    let url = LazyLoadingHelper.imageUrl(urlString, imageType: imageType)
    sd_setImageWithURL(url, placeholderImage: image) { (image, error, cacheType, url) -> Void in
      if let image = image {
        if imageType == .Thumbnail {
          self.setLazyLoaingImage(urlString, imageType: .Basic)
        } else if imageType == .Original && !LazyLoadingHelper.originalImageUrls.contains(urlString) {
          LazyLoadingHelper.originalImageUrls.append(urlString)
        }
        self.setImageWithAnimation(image, cacheType: cacheType)
      } else {
        if imageType != .Original {
          self.setLazyLoaingImage(urlString, imageType: .Original)
        }
      }
    }
  }
  
  func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    if cacheType == .Disk || cacheType == .Memory {
      self.image = image
    } else {
      UIView.transitionWithView(self,
        duration: 0.2,
        options: [.AllowUserInteraction, .TransitionCrossDissolve],
        animations: { () -> Void in
          self.image = image
        },
        completion:nil)
    }
  }
  
  
  func setLazyLoaingImage(urlString: String?) {
    if let urlString = urlString {
      if LazyLoadingHelper.originalImageUrls.contains(urlString) {
        setLazyLoaingImage(urlString, imageType: .Original)
      } else {
        let thumbnailUrl = LazyLoadingHelper.imageUrl(urlString, imageType: .Thumbnail)
        let isThumbnailLoaded = SDWebImageManager.sharedManager().cachedImageExistsForURL(thumbnailUrl)
        setLazyLoaingImage(urlString, imageType: .Thumbnail)
        if isThumbnailLoaded {
          setLazyLoaingImage(urlString, imageType: .Basic)
        }
      }
    }
  }
}

class LazyLoadingHelper: NSObject {
  static var originalImageUrls = [String]()
  
  static func imageUrl(url: String, imageType: ImageType) -> NSURL {
    let urlString = imageType == .Original ? url : "\(url)?imageType=\(imageType.rawValue)"
    return urlString.url()
  }
}
