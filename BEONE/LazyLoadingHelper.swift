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
    sd_setImageWithURL(LazyLoadingHelper.imageUrl(urlString, imageType: imageType), placeholderImage: image)
      { (image, error, cachType, url) -> Void in
        if let image = image {
          if imageType == .Thumbnail {
            self.setLazyLoaingImage(urlString, imageType: .Basic)
          } else if imageType == .Original && !LazyLoadingHelper.originalImageUrls.contains(urlString) {
            LazyLoadingHelper.originalImageUrls.append(urlString)
          }
          self.setImageWithAnimation(image)
        } else {
          if imageType != .Original {
            self.setLazyLoaingImage(urlString, imageType: .Original)
          }
        }
    }
  }
  
  private func setImageWithAnimation(image: UIImage) {
    UIView.transitionWithView(self,
      duration: 0.2,
      options: [.AllowUserInteraction, .TransitionCrossDissolve],
      animations: { () -> Void in
        self.image = image
      },
      completion:nil)
    print(constraints)
    for constraint in constraints {
      if constraint.firstAttribute == .Height {
        constraint.constant = image.size.height / image.size.width * frame.size.width
      }
    }
  }
  
  func setLazyLoaingImage(urlString: String) {
    if LazyLoadingHelper.originalImageUrls.contains(urlString) {
      setLazyLoaingImage(urlString, imageType: .Original)
    } else {
      let thumbnailUrl = LazyLoadingHelper.imageUrl(urlString, imageType: .Thumbnail)
      let isThumbnailLoaded = SDWebImageManager.sharedManager().cachedImageExistsForURL(thumbnailUrl)
      self.image = UIImage(named: "image_post_thumbnail")
      setLazyLoaingImage(urlString, imageType: .Thumbnail)
      if isThumbnailLoaded {
        setLazyLoaingImage(urlString, imageType: .Basic)
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
