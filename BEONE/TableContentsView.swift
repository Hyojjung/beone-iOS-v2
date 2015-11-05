
import UIKit

let kSpaceWidthCell = CGFloat(10)
let kNoSpaceWidthCell = CGFloat(0)
let kNibNameTableContentsCollectionViewCell = "TableContentsCollectionViewCell"
let kCellIdentifierTableContentsCollectionViewCell = "tableContentsCell"

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
  
  override func setNeedsLayout() {
    super.setNeedsLayout()
    collectionView.registerNib(UINib(nibName: kNibNameTableContentsCollectionViewCell, bundle: nil),
      forCellWithReuseIdentifier: kCellIdentifierTableContentsCollectionViewCell)
  }
  
  override func setNeedsDisplay() {
    super.setNeedsDisplay()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if lastWidth != frame.size.width {
      lastWidth = frame.size.width
      isLayouted = true
      setUpCollectionViewFlowLayout(collectionViewLayout)
      collectionView.reloadData()
    }
  }
  
  override func layoutView(template: Template) {
    collectionView.changeHeightLayoutConstant(template.height)
    templateId = template.id
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
      
      let height = itemWidth * CGFloat(row) + space * CGFloat(row - 1)
      layoutContentsView(isLayouted, templateId: templateId, height: height, contentsView: collectionView)
    }
  }
  
}

// MARK: - UICollectionViewDataSource

extension TableContentsView {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contents?.count != nil ? (contents?.count)! : 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifierTableContentsCollectionViewCell,
      forIndexPath: indexPath) as! TableContentsCollectionViewCell
    if let contents = contents {
      cell.configure(contents[indexPath.row])
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension TableContentsView: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let templateId = templateId, contents = contents, contentsId = contents[indexPath.row].id {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationDoAction,
        object: nil,
        userInfo: [kNotificationKeyTemplateId: templateId, kNotificationKeyContentsId: contentsId])
    }
  }
}