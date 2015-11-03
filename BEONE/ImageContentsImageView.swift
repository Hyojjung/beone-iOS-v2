//
//  ImageContentsImageView.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 2..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit
import SDWebImage

class ImageContentsImageView: LazyLoadingImageView {
  var isLayouted = false
  var template: Template?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if frame.width != 600 {
      isLayouted = true
    }
    modifyHeightConstraint()
  }
  
  func setTemplateImage(template: Template) {
    self.template = template
    setLazyLoaingImage(template.contents.first?.imageUrl)
  }
  
  
  override func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    super.setImageWithAnimation(image, cacheType: cacheType)
    modifyHeightConstraint()
  }
  
  func modifyHeightConstraint() {
    if let image = image, template = template {
      if isLayouted {
        let height = image.size.height / image.size.width * frame.size.width
        for constraint in constraints {
          if constraint.firstAttribute == .Height && Int(constraint.constant) != Int(height) && constraint.isMemberOfClass(NSLayoutConstraint) {
            constraint.constant = height
            template.height = height
            NSNotificationCenter.defaultCenter().postNotificationName("imageViewLoaded", object: nil, userInfo: ["id": template.id!])
          }
        }
      }
    }
  }
}
