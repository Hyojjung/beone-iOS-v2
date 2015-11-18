//
//  SimpleProductsContentsView.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 18..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class SimpleProductsContentsView: TemplateContentsView {
  @IBOutlet weak var firstProductView: UIView!
  @IBOutlet weak var secondProductView: UIView!
    
  lazy var firstProductsContentsView: SimpleProductView = {
    let simpleProductView = UIView.loadFromNibName(kSimpleProductViewNibName) as! SimpleProductView
    return simpleProductView
  }()
  
  lazy var secondProductsContentsView: SimpleProductView = {
    let simpleProductView = UIView.loadFromNibName(kSimpleProductViewNibName) as! SimpleProductView
    return simpleProductView
  }()
  
  func configureView(products: [Product]) {
    if firstProductsContentsView.superview == nil {
      firstProductView.addSubViewAndEdgeLayout(firstProductsContentsView)
    }
    firstProductsContentsView.configureView(products.first)
    
    if products.count >= kSimpleProductColumn {
      if secondProductsContentsView.superview == nil {
        secondProductView.addSubViewAndEdgeLayout(secondProductsContentsView)
      }
      secondProductsContentsView.configureView(products.last)
    } else {
      secondProductsContentsView.removeFromSuperview()
    }
  }
}
