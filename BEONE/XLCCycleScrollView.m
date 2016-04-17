//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCCycleScrollView.h"

static NSInteger kBODotImageViewTag = 77;
static NSString *kBOBgSliderDot = @"bg_slider_dot";
static NSString *kBOImageSliderDotActive = @"image_slider_dot_active";
static NSString *kBOImageSliderDotInactive = @"image_slider_dot_inactive";

@interface XLCCycleScrollView ()

@property (strong, nonatomic) UIImageView *pageControlBackgoundImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation XLCCycleScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self _addScrollView];
    [self _addPageControl];
  }
  return self;
}

- (UIScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [UIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.directionalLockEnabled = YES;
    
    _scrollView.delegate = self;
    CGSize scrollViewSize = [[UIScreen mainScreen] bounds].size;
    _scrollView.contentSize = CGSizeMake(scrollViewSize.width * 3, scrollViewSize.width);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(scrollViewSize.width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
  }
  return _scrollView;
}

- (void)setCurrentPage:(NSInteger)currentPage {
  if (currentPage != _currentPage) {
    _currentPage = currentPage;
    [self _updatePageControl];
  }
}

- (UIImageView *)pageControlBackgoundImageView {
  if (!_pageControlBackgoundImageView) {
    _pageControlBackgoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBOBgSliderDot]];
    [_pageControlBackgoundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return _pageControlBackgoundImageView;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [UIPageControl new];
    _pageControl.userInteractionEnabled = NO;
    [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor clearColor];
  }
  return _pageControl;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self _updatePageControl];
  [self reloadData];
}

- (void)_addScrollView {
  [self addSubview:self.scrollView];
  NSDictionary *views = @{@"scrollView": self.scrollView};
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
}

- (void)_addPageControl {
  [self addSubview:self.pageControl];
  NSDictionary *views = @{@"pageControl": self.pageControl};
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-(5)-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1
                                                    constant:0.0f]];
}

- (void)_addPageControlBackgroudImageView {
  if (!self.pageControlBackgoundImageView.superview) {
    [self addSubview:self.pageControlBackgoundImageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pageControlBackgoundImageView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:-5.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pageControlBackgoundImageView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:5.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pageControlBackgoundImageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-13.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.pageControlBackgoundImageView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:14.0f]];
  }
}

- (void)setDataource:(id<XLCCycleScrollViewDatasource>)datasource
{
  _datasource = datasource;
  [self reloadData];
}

- (void)reloadData
{
  _totalPages = [_datasource numberOfPages];
  if (_totalPages == 0) {
    return;
  }
  _pageControl.numberOfPages = _totalPages;
  [self loadDatawithNeededAdjustContentOffset:NO];
}

- (void)loadDatawithNeededAdjustContentOffset:(BOOL)neededAdjustContentOffset
{
  NSArray *subViews = [self.scrollView subviews];
  if([subViews count] != 0) {
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  }
  
  [self getDisplayImagesWithCurpage:self.currentPage];
  
  if (_curViews.count == 0) {
    return;
  }
  
  for (int i = 0; i < 3; i++) {
    UIView *v = [_curViews objectAtIndex:i];
    v.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [v addGestureRecognizer:singleTap];
    v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
    [self.scrollView addSubview:v];
  }
  if (neededAdjustContentOffset) {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
  }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
  self.currentPage = page;
  [self _addPageControlBackgroudImageView];
  
  NSInteger pre = [self validPageValue:self.currentPage-1];
  NSInteger last = [self validPageValue:self.currentPage+1];
  
  if (!_curViews) {
    _curViews = [NSMutableArray new];
  }
  
  [_curViews removeAllObjects];
  
  if (!_datasource) {
    return;
  }
  [_curViews addObject:[_datasource pageAtIndex:pre]];
  [_curViews addObject:[_datasource pageAtIndex:page]];
  [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
  
  if(value == -1) value = _totalPages - 1;
  if(value == _totalPages) value = 0;
  
  return value;
  
}

- (void)_updatePageControl {
  [self.pageControl.subviews enumerateObjectsUsingBlock:^(UIView *dotView, NSUInteger idx, BOOL *stop) {
    [[dotView viewWithTag:kBODotImageViewTag] removeFromSuperview];
    [self _addDotImageviewWithIsCurrentPage:idx == self.currentPage dotView:dotView];
  }];
}

- (void)_addDotImageviewWithIsCurrentPage:(BOOL)isCurrentPage dotView:(UIView *)dotView {
  NSString *dotImageName = isCurrentPage ? kBOImageSliderDotActive : kBOImageSliderDotInactive;
  UIImageView *activeDotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dotImageName]];
  activeDotImageView.frame = CGRectMake(1, 1, activeDotImageView.frame.size.width, activeDotImageView.frame.size.width);
  activeDotImageView.tag = kBODotImageViewTag;
  [dotView addSubview:activeDotImageView];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
  if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
    [_delegate didClickPage:self atIndex:self.currentPage];
  }
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
  if (index == self.currentPage) {
    [_curViews replaceObjectAtIndex:1 withObject:view];
    for (int i = 0; i < 3; i++) {
      UIView *v = [_curViews objectAtIndex:i];
      v.userInteractionEnabled = YES;
      UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTap:)];
      [v addGestureRecognizer:singleTap];
      v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
      [self.scrollView addSubview:v];
    }
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
  int x = aScrollView.contentOffset.x;
  CGFloat y = aScrollView.contentOffset.y;
  
  if (y != 0) {
    [aScrollView setContentOffset:CGPointMake(x, 0)];
  }
    
  if(x >= (2*[[UIScreen mainScreen] bounds].size.width)) {
    self.currentPage = [self validPageValue:self.currentPage + 1];
    [self loadDatawithNeededAdjustContentOffset:YES];
  }
  
  if(x <= 0) {
    self.currentPage = [self validPageValue:self.currentPage-1];
    [self loadDatawithNeededAdjustContentOffset:YES];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
  
  [self.scrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
  
}

@end
