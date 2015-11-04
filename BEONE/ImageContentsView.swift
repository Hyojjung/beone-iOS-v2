//
//  ImageTemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ImageContentsView: TemplateContentsView {
  @IBOutlet weak var imageView: ImageContentsImageView!
  
  // MARK: - Override Methods
  
  override func layoutView(template: Template) {
    imageView.changeHeightLayoutConstant(template.height)
    imageView.setTemplateImage(template)
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationDoAction,
        object: nil,
        userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
}
