//
//  TemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TemplateView: UIView {
  
  private lazy var templateContentsView: UIView = {
    let contentsView = UIView()
    contentsView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(contentsView)
    self.addConstraint(NSLayoutConstraint(item: contentsView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .TopMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: contentsView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .BottomMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: contentsView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .LeftMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: contentsView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .RightMargin, multiplier: 1, constant: 0))
    return contentsView
  }()
  
  private lazy var backgroundImageView: UIImageView = {
    let backgroundImageView = UIImageView()
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    self.templateContentsView.addSubview(backgroundImageView)
    self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Top, relatedBy: .Equal, toItem: self.templateContentsView, attribute: .Top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.templateContentsView, attribute: .Bottom, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Left, relatedBy: .Equal, toItem: self.templateContentsView, attribute: .Left, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Right, relatedBy: .Equal, toItem: self.templateContentsView, attribute: .Right, multiplier: 1, constant: 0))
    return backgroundImageView
  }()
  
  func layoutView(template: Template) {
    if let margin = template.style?.margin {
      layoutMargins = margin
    }
    if let padding = template.style?.padding {
      templateContentsView.layoutMargins = padding
    }
    templateContentsView.backgroundColor = template.style?.backgroundColor
    // TODO: - backgroudImage
    // TODO: - alignment????
    
    if template.isGroup != nil && template.isGroup! {
      var beforeView: UIView?
      for (index, item) in template.templateItems.enumerate() {
        let templateView = TemplateView()
        templateView.translatesAutoresizingMaskIntoConstraints = false
        templateView.layoutView(item)
        templateContentsView.addSubview(templateView)
        
        if index == 0 {
          templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: templateContentsView, attribute: .TopMargin, multiplier: 1, constant: 0))
        } else if let beforeView = beforeView {
          templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: beforeView, attribute: .Bottom, multiplier: 1, constant: 0))
        }
        if index == template.templateItems.count - 1 {
          templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Bottom, relatedBy: .Equal, toItem: templateContentsView, attribute: .BottomMargin, multiplier: 1, constant: 0))
        }
        templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Left, relatedBy: .Equal, toItem: templateContentsView, attribute: .LeftMargin, multiplier: 1, constant: 0))
        templateContentsView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Right, relatedBy: .Equal, toItem: templateContentsView, attribute: .RightMargin, multiplier: 1, constant: 0))
        beforeView = templateView
      }
    } else if let type = template.type, viewNibName = self.viewNibName(type),
      contentView = UINib(nibName:viewNibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? TextTemplateView {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        templateContentsView.addSubview(contentView)
        contentView.layoutView(template.contents.first!)
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: templateContentsView, attribute: .TopMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: templateContentsView, attribute: .BottomMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: templateContentsView, attribute: .LeftMargin, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: templateContentsView, attribute: .RightMargin, multiplier: 1, constant: 0))
    }
  }
  
  func viewNibName(type: TemplateType) -> String? {
    switch type {
    case .Text:
      return "TextTemplateView"
    case .Image:
      return "ImageTemplateView"
    case .Button:
      return "ButtonTemplateView"
    case .Gap:
      return "GapTemplateView"
    case .Shop:
      return "ShopTemplateView"
    case .Product:
      return "ProductTemplateView"
    case .Review:
      return "ReviewTemplateView"
    case .Banner:
      return "BannerTemplateView"
    case .Table:
      return "TableTemplateView"
    }
  }
}