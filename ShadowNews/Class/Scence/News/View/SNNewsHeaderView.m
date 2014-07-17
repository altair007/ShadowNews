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
@property (retain, nonatomic) UIScrollView * SNNHVScrollView; //!< 底部滚动视图.
@property (retain, nonatomic) UISegmentedControl * SNNHVSegmentedControl; //!< 用于显示菜单.
@property (retain, nonatomic) SNNewsMenu * SNNHVMenu; //!< 菜单对象.
@property (retain, nonatomic) NSNumber * SNNHVHeigt; //!< 视图高度.
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
    
    self.SNNHVScrollView = nil;
    self.SNNHVSegmentedControl = nil;
    self.SNNHVHeigt = nil;
    
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

- (void) didMoveToSuperview
{
    [self SNNHVSetUpSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 支持自定义页眉单元格宽度 */
    for (NSUInteger index = 0; index < self.SNNHVSegmentedControl.numberOfSegments; index++) {
        [self.SNNHVSegmentedControl setWidth:[self SNNHVWidthOfCellAtIndex: index] forSegmentAtIndex: index];
    }
    
    [self SNNHVCenterSelectedSegment: self.selectedIndex];}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.SNNHVSegmentedControl.selectedSegmentIndex = self.selectedIndex;
    
    // !!!: 优化方向.
    /*重要思路:建议在changeValue里面检测.或者在滚动里面检测,即让两个ScorllView直接通信.
     *segment实现条跟着动的效果的思路:设置一个条形背景图,让它跟着滚动视图动即可..
     *观察到: 红形条,其实是随着底部大视图一起滚动的.
     */
    [self SNNHVCenterSelectedSegment: self.selectedIndex];
}

/**
 *  居中显示分段控件某个位置的分段.
 */
- (void) SNNHVCenterSelectedSegment: (NSUInteger) index
{
    //!!!: 此处的逻辑依赖于分段控件宽度为屏幕宽度的1/5.请解耦.
    if (index < 2) {
        index = 2;
    }
    
    if (index > self.SNNHVSegmentedControl.numberOfSegments - 3) {
        index = self.SNNHVSegmentedControl.numberOfSegments - 3;
    }
    
    /* 根据轮转视图和分段控件的总个数来计算每个分段控件的实际宽度.
     * 原因:widthForSegmentAtIndex:方法并不能得到某个分段的真是宽度,因为各分段之间有1像素用于边框条.
     */
    CGFloat width = self.SNNHVScrollView.contentSize.width / self.SNNHVSegmentedControl.numberOfSegments;
    
    CGFloat x = (index - 2) * width;
    
    CGPoint offset = self.SNNHVScrollView.contentOffset;
    offset.x = x;
    [self.SNNHVScrollView setContentOffset: offset animated: NO];
}

/**
 *  获取页眉高度.
 *
 *  @return 页眉高度.
 */
- (NSNumber *)SNNHVHeigt
{
    if (nil != _SNNHVHeigt) {
        return _SNNHVHeigt;
    }
    
    NSNumber * height = [NSNumber numberWithDouble: 42.0]; // 默认42.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForNewsView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForNewsView: self];
    }
    self.SNNHVHeigt = height;
    
    return _SNNHVHeigt;
}
#pragma mark - 私有方法.
/**
 * 初始化子视图.
 */
- (void) SNNHVSetUpSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    /* 创建视图. */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    self.SNNHVScrollView = scrollView;
    SNRelease(scrollView);
    [self addSubview: self.SNNHVScrollView];
    
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:self.SNNHVMenu.itemsAdded];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl addTarget:self action:@selector(SNNHVDidClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize: 16.0]} forState: UIControlStateSelected];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName: [UIFont systemFontOfSize: 16.0]} forState: UIControlStateNormal];
    
    segmentedControl.tintColor = [UIColor clearColor];
    
    self.SNNHVSegmentedControl = segmentedControl;
    SNRelease(segmentedControl);
    [self.SNNHVScrollView addSubview: self.SNNHVSegmentedControl];
    
    /*设置视图约束*/
    NSNumber * height = self.SNNHVHeigt; // 页眉高度.
    
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl(==height)]|" options:0 metrics:NSDictionaryOfVariableBindings(height) views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [self addConstraints: constraints];
}

- (void)SNNHVDidClickSegmentedControlAction:(UISegmentedControl *) segmentedControl
{
    [self.delegate newsHeaderView:self didClickSegmentActionAtIndex: segmentedControl.selectedSegmentIndex];
}

/**
 *  单个单元格宽度.默认为屏幕宽度的1/5.可通过代理设置.
 *
 *  @return 单个单元格宽度.
 */
- (CGFloat) SNNHVWidthOfCellAtIndex: (NSUInteger) index
{
    CGFloat width = self.frame.size.width / 5;
    if ([self.delegate respondsToSelector: @selector(newsHeaderView:widthForCellAtIndex:)]) {
        width = [self.delegate newsHeaderView: self widthForCellAtIndex: index];
    }
    return width;
}

- (SNNewsMenu *)SNNHVMenu
{
    if (nil == _SNNHVMenu) {
        self.SNNHVMenu = [self.dataSource menuInNewsHeaderView: self];
    }
    
    return _SNNHVMenu;
}
#pragma mark - UIScrollViewDelegate协议方法.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}
@end
