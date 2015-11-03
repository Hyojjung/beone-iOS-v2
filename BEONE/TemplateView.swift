//
//  TemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateView: TemplateContentsView {
  private lazy var templateContentsView: UIView = {
    let contentsView = UIView()
    self.addSubViewAndMarginLayout(contentsView)
    return contentsView
  }()
  
  private lazy var backgroundImageView: LazyLoadingImageView = {
    let backgroundImageView = LazyLoadingImageView()
    self.templateContentsView.addSubViewAndLayout(backgroundImageView)
    return backgroundImageView
  }()
  
  override func layoutView(template: Template) {
    if let margin = template.style?.margin {
      layoutMargins = margin
    }
    if let padding = template.style?.padding {
      templateContentsView.layoutMargins = padding
    }
    templateContentsView.backgroundColor = template.style?.backgroundColor
    backgroundImageView.setLazyLoaingImage(template.style?.backgroundImageUrl)

    if template.isGroup != nil && template.isGroup! {
      var beforeView: UIView?
      for (index, item) in template.templateItems.enumerate() {
        let templateView = TemplateView()
        templateContentsView.addSubViewAndEnableAutoLayout(templateView)
        templateView.layoutView(item)
        
        if index == 0 {
          templateContentsView.addTopMarginLayout(templateView)
        } else if let beforeView = beforeView {
          templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: beforeView, attribute: .Bottom, multiplier: 1, constant: 0))
        }
        if index == template.templateItems.count - 1 {
          templateContentsView.addBottomMarginLayout(templateView)
        }
        
        templateContentsView.addHorizontalMarginLayout(templateView)
        beforeView = templateView
      }
    } else if let type = template.type, viewNibName = TemplateHelper.viewNibName(type),
      contentView = UINib(nibName:viewNibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? TemplateContentsView {
        templateContentsView.addSubViewAndMarginLayout(contentView)
        contentView.layoutView(template)
    }
  }

}