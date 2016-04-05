//
//  CricularImage.m
//  cricularImage
//
//  Created by 诸超杰 on 16/4/5.
//  Copyright © 2016年 诸超杰. All rights reserved.
//

#import "CricularImage.h"

@interface CricularImage ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *ContentArray;//总的数据
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger nowIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation CricularImage


- (instancetype)initWithFrame:(CGRect)frame withContentArray:(NSMutableArray *)array {
    self.ContentArray = array;
    return  [self initWithFrame:frame];
}
- (NSMutableArray *)picArray {
    if (_picArray == nil) {
        self.picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createScrollView];
        [self createPageControl];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
  //必须把scrollView自带的两个UIImageVIew删掉,不然就刚开始就会出现错误。如果不删掉自带的两个UIImageView，那么subviews[i]中的图片赋值就要从第3个元素(下标为2开始)

    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        [self.scrollView addSubview:imageView];
    }
    [self addSubview:self.scrollView];
    _nowIndex = 0;
    [self createScrollViewSubView];
}

- (void)createPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 6 * 5);
    self.pageControl.numberOfPages = self.ContentArray.count;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:self.pageControl];
}



- (void)createScrollViewSubView {
    //把以前的图片置空
    for (UIView *view in self.scrollView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.image = nil;
        }
    }
    //获取数据
    [self setScrollViewData];
    for (int i = 0; i < self.picArray.count; i ++) {
        UIView *view = self.scrollView.subviews[i];
        UIImageView *imageView = (UIImageView *)view;
        imageView.image = self.picArray[i];
    }
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

//获取数据中元素对应的位置
- (NSInteger)getNextIndex:(NSInteger)index {
    if (index == -1) {
        return self.ContentArray.count - 1;
    } else if (index == self.ContentArray.count) {
        return 0;
    } else {
        return index;
    }
}

- (void)setScrollViewData {
    //清空数据源
    [self.picArray removeAllObjects];
    //获取前一个和后一个数据的位置
    NSInteger preIndex = [self getNextIndex:_nowIndex - 1];
    NSInteger aftIndex = [self getNextIndex:_nowIndex + 1];
    //picArray只用于存放三个数据，当前，前面，后面
    [self.picArray addObject:_ContentArray[preIndex]];
    [self.picArray addObject:_ContentArray[_nowIndex]];
    [self.picArray addObject:_ContentArray[aftIndex]];
    
}

- (void)timer:(id)sender {
    self.nowIndex = [self getNextIndex:_nowIndex];
    [self.scrollView setContentOffset:CGPointMake(2 * self.frame.size.width, 0) animated:YES];
}

#pragma mark ---scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= self.bounds.size.width * 2) {
        //当移动到后面一张的时候，从self.bounds.size.width到self.bounds.size.width * 2，
        _nowIndex = [self getNextIndex:_nowIndex + 1];
        [self createScrollViewSubView];
    } else if(offsetX <= 0){
        _nowIndex = [self getNextIndex:_nowIndex - 1];
        [self createScrollViewSubView];
    }

    self.pageControl.currentPage = _nowIndex;
}


//将要拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //让计时器在未来开启
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

@end
