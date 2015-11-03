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
    if let height = template.height {
      for constraint in imageView.constraints {
        if constraint.firstAttribute == .Height {
          constraint.constant = height
        }
      }
    }
    imageView.setTemplateImage(template)
    action = template.contents.first?.action
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    action?.action()
  }
}
