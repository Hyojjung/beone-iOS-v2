//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLCCycleScrollView;

@protocol XLCCycleScrollViewDelegate <NSObject>

@optional

- (void)didClickPage:(XLCCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

@interface XLCCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;

    NSInteger _totalPages;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XLCCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XLCCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end
