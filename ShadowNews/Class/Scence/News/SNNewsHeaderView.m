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
@property (retain, nonatomic) NSNumber * SNNHHeigt; //!< 视图高度.
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
    self.SNNHHeigt = nil;
    
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
    [self SNNHSetUpSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 支持自定义页眉单元格宽度 */
    for (NSUInteger index = 0; index < self.SNNHSegmentedControl.numberOfSegments; index++) {
        [self.SNNHSegmentedControl setWidth:[self SNNHWidthOfCellAtIndex: index] forSegmentAtIndex: index];
    }
    
    /* 导航栏中,被选中的键,应该自动居中. */
    // !!!: 应该先让 segement动,再让scrollview动.即,时机不太多.或许需要layout什么的.needLayout.
    // !!!: 重要思路:建议在changeValue里面检测.或者在滚动里面检测,即让两个ScorllView直接通信.
    // !!!: segment实现条跟着动的效果的思路:设置一个条形背景图,让它跟着滚动视图动即可..
    CGFloat width = [self.SNNHSegmentedControl widthForSegmentAtIndex: 0];
    
    CGFloat x = (self.selectedIndex + 0.5) * width - [UIScreen mainScreen].bounds.size.width/2;
    
    CGPoint offset = self.SNNHScrollView.contentOffset;
    offset.x = x;
    [self.SNNHScrollView setContentOffset: offset animated: YES];
}

// ???:被选中的键,应该自动居中.
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.SNNHSegmentedControl.selectedSegmentIndex = selectedIndex;
    
    [self setNeedsLayout];
}

/**
 *  获取页眉高度.
 *
 *  @return 页眉高度.
 */
- (NSNumber *)SNNHHeigt
{
    if (nil != _SNNHHeigt) {
        return _SNNHHeigt;
    }
    
    NSNumber * height = [NSNumber numberWithDouble: 42.0]; // 默认42.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForNewsView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForNewsView: self];
    }
    self.SNNHHeigt = height;
    
    return _SNNHHeigt;
}
#pragma mark - 私有方法.
/**
 * 初始化子视图.
 */
- (void) SNNHSetUpSubviews
{
    /* 创建视图. */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    
    self.SNNHScrollView = scrollView;
    SNRelease(scrollView);
    [self addSubview: self.SNNHScrollView];
    
    
    // ???:如何去调 segmentedControl的边框,好难看! UISegmentedControlStyle 可能和这个有关.
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:self.SNNHMenu.itemsAdded];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl addTarget:self action:@selector(SNNHDidClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize: 16.0]} forState: UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize: 16.0]} forState: UIControlStateNormal];
    
    segmentedControl.tintColor = [UIColor whiteColor];
    
    self.SNNHSegmentedControl = segmentedControl;
    SNRelease(segmentedControl);
    [self.SNNHScrollView addSubview: self.SNNHSegmentedControl];
    
    /*设置视图约束*/
    NSNumber * height = self.SNNHHeigt; // 页眉高度.
    
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl(==height)]|" options:0 metrics:NSDictionaryOfVariableBindings(height) views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
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
    
}
@end
