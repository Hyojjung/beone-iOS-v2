//
//  ImageTemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ImageContentsView: TemplateContentsView {
  @IBOutlet weak var imageView: LazyLoadingImageView!
  
  override func layoutView(contents: Contents) {
    if let imageUrl = contents.imageUrl {
      imageView.setLazyLoaingImage(imageUrl)
    }
  }
}
