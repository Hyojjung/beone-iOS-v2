//
//  TableContentsView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kSpaceWidthCell = CGFloat(10)
let kNoSpaceWidthCell = CGFloat(0)

class TableContentsView: TemplateContentsView {
  @IBOutlet weak var collectionView: UICollectionView!
  private var lastWidth: CGFloat?
  private var contents: [Contents]?
  private var column: Int?
  private var row: Int?
  private var hasSpace: Bool?
  
  private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    self.setUpCollectionViewFlowLayout(layout)
    self.collectionView.collectionViewLayout = layout
    return layout
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if lastWidth != frame.size.width {
      lastWidth = frame.size.width
      setUpCollectionViewFlowLayout(collectionViewLayout)
      collectionView.reloadData()
    }
  }
  
  override func layoutView(template: Template) {
    contents = template.contents
    hasSpace = template.hasSpace
    row = template.row
    column = template.column
    layoutSubviews()
  }
  
  private func setUpCollectionViewFlowLayout(collectionViewLayout: UICollectionViewFlowLayout) {
    let space = self.hasSpace != nil && self.hasSpace! ? kSpaceWidthCell : kNoSpaceWidthCell
    collectionViewLayout.minimumInteritemSpacing = space
    collectionViewLayout.minimumLineSpacing = space
    
    if let lastWidth = self.lastWidth, column = self.column, row = self.row {
      let itemWidth = (lastWidth - space * CGFloat(column - 1)) / CGFloat(column)
      collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
      
      for constraint in collectionView.constraints {
        if constraint.firstAttribute == .Height {
          constraint.constant = itemWidth * CGFloat(row) + space * CGFloat(row - 1)
        }
      }
    }
  }
  
}

// MARK: - UICollectionViewDataSource

extension TableContentsView: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contents?.count != nil ? (contents?.count)! : 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    collectionView.registerNib(UINib(nibName: "TableContentsCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "tableContentsCell")
    let cell =
    collectionView.dequeueReusableCellWithReuseIdentifier("tableContentsCell", forIndexPath: indexPath) as? TableContentsCollectionViewCell
    if let contents = contents {
      cell?.configure(contents[indexPath.row])
    }
    return cell!
  }
  
}