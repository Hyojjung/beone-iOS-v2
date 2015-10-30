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
  var action: Action?
  
  // MARK: - Override Methods

  override func layoutView(template: Template) {
    if let imageContents = template.contents.first {
      imageView.setLazyLoaingImage(imageContents.imageUrl)
      action = imageContents.action
    }
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    action?.action()
  }
}
