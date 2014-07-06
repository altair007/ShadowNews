//
//  YFRotateHeaderView.m
//  Rotate
//
//  Created by 颜风 on 14-7-4.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsHeaderView.h"
#import "SNNewsMenu.h"

@interface SNNewsHeaderView ()
@property (retain, nonatomic) UIScrollView * SNNHScrollView; //!< 底部滚动视图.
@property (retain, nonatomic) UISegmentedControl * SNNHSegmentedControl; //!< 用于显示菜单.
@property (retain, nonatomic) SNNewsMenu * SNNHMenu; //!< 菜单对象.
@end
@implementation SNNewsHeaderView
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    
    self.SNNHScrollView = nil;
    self.SNNHSegmentedControl = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self SNNHSetupSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 支持自定义页眉单元格宽度 */
    for (NSUInteger index = 0; index < self.SNNHSegmentedControl.numberOfSegments; index++) {
        [self.SNNHSegmentedControl setWidth:[self SNNHWidthOfCellAtIndex: index] forSegmentAtIndex: index];
    }
}

// ???:被选中的键,应该自动居中.
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.SNNHSegmentedControl.selectedSegmentIndex = selectedIndex;
    
    // ???:应该可以删掉.
//    if ([self.delegate respondsToSelector:@selector(newsHeaderView:didClickSegmentActionAtIndex:)]) {
//        [self.delegate newsHeaderView:self didClickSegmentActionAtIndex:selectedIndex];
//    }
}

#pragma mark - 私有方法.
/**
 * 初始化子视图.
 */
- (void) SNNHSetupSubviews
{
    /* 创建视图. */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    
    self.SNNHScrollView = scrollView;
    SNRelease(scrollView);
    [self addSubview: self.SNNHScrollView];
    
    
    // ???:如何去调 segmentedControl的边框,好难看! UISegmentedControlStyle 可能和这个有关.
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:self.SNNHMenu.itemsAdded];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl addTarget:self action:@selector(SNNHDidClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    self.SNNHSegmentedControl = segmentedControl;
    SNRelease(segmentedControl);
    [self.SNNHScrollView addSubview: self.SNNHSegmentedControl];
    
    /*设置视图约束*/
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [self addConstraints: constraints];
}

- (void)SNNHDidClickSegmentedControlAction:(UISegmentedControl *) segmentedControl
{
    [self.delegate newsHeaderView:self didClickSegmentActionAtIndex: segmentedControl.selectedSegmentIndex];
}

/**
 *  单个单元格宽度.默认为屏幕宽度的1/5.可通过代理设置.
 *
 *  @return 单个单元格宽度.
 */
- (CGFloat) SNNHWidthOfCellAtIndex: (NSUInteger) index
{
    CGFloat width = self.frame.size.width / 5;
    if ([self.delegate respondsToSelector: @selector(newsHeaderView:widthForCellAtIndex:)]) {
        width = [self.delegate newsHeaderView: self widthForCellAtIndex: index];
    }
    
    return width;
}

- (SNNewsMenu *)SNNHMenu
{
    if (nil == _SNNHMenu) {
        self.SNNHMenu = [self.dataSource menuInNewsHeaderView: self];
    }
    
    return _SNNHMenu;
}
#pragma mark - UIScrollViewDelegate协议方法.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}
@end
