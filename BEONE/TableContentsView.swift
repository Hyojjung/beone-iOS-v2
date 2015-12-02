
import UIKit

let kSpaceWidthCell = CGFloat(10)
let kNoSpaceWidthCell = CGFloat(0)
let kTableContentsCollectionViewCellNibName = "TableContentsCollectionViewCell"
let kTableContentsCellIdentifier = "tableContentsCell"

class TableContentsView: TemplateContentsView {
  @IBOutlet weak var collectionView: UICollectionView!
  private var lastWidth: CGFloat?
  private var content: Content?
  private var column: Int?
  private var row: Int?
  private var hasSpace: Bool?
  
  var isRe = false
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
      isLayouted = true
      setUpCollectionViewFlowLayout(collectionViewLayout)
      collectionView.reloadData()
    }
  }
  
  override func className() -> String {
    return "Table"
  }
  
  override func layoutView(template: Template) {
    collectionView.changeHeightLayoutConstant(template.height)
    templateId = template.id
    content = template.content
    hasSpace = template.content.hasSpace
    row = template.content.row
    column = template.content.column
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
    return content?.items.count != nil ? content!.items.count : 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if !isRe {
      isRe = true
      collectionView.registerNib(UINib(nibName: kTableContentsCollectionViewCellNibName, bundle: nil),
        forCellWithReuseIdentifier: kTableContentsCellIdentifier)
    }
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kTableContentsCellIdentifier,
      forIndexPath: indexPath) as! TableContentsCollectionViewCell
    if let content = content {
      cell.configure(content.items[indexPath.row])
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension TableContentsView: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let templateId = templateId, content = content, contentsId = content.id {
      postNotification(kNotificationDoAction,
        userInfo: [kNotificationKeyTemplateId: templateId, kNotificationKeyContentsId: contentsId])
    }
  }
}