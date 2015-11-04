//
//  TemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateView: TemplateContentsView {
  private var templateContentsView = UIView()
  private var backgroundImageView = LazyLoadingImageView()
  
  override func layoutView(template: Template) {
    configureViewHierarchy()
    configureStyle(template.style)
    
    if let type = template.type,
      contentView = UIView.loadFromNibName(TemplateHelper.viewNibName(type)) as? TemplateContentsView {
        templateContentsView.addSubViewAndMarginLayout(contentView)
        contentView.layoutView(template)
    }
  }
  
  private func configureViewHierarchy() {
    if templateContentsView.superview == nil {
      addSubViewAndMarginLayout(templateContentsView)
    } else {
      templateContentsView.subviews.forEach{ $0.removeFromSuperview() }
    }
    templateContentsView.addSubViewAndLayout(backgroundImageView)
  }
  
  private func configureStyle(style: TemplateStyle?) {
    if let style = style {
      if let margin = style.margin {
        layoutMargins = margin
      }
      if let padding = style.padding {
        templateContentsView.layoutMargins = padding
      }
      templateContentsView.backgroundColor = style.backgroundColor
      backgroundImageView.setLazyLoaingImage(style.backgroundImageUrl)
    }
  }
}