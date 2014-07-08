//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

/**
 *  视图容器的内容插入类型.
 */
typedef enum{
    SNNVViewContanierContentInsertTypeNone, //!< 没有往视图容器插入容器.
    SNNVViewContanierContentInsertTypeHead, //!< 从位置0往视图容器插入数据.
    SNNVViewContanierContentInsertTypeTail, //!< 从最后位置往视图容器插入数据.
    SNNVViewContanierContentInsertTypeMiddle //!< 从中间位置往视图容器插入数据.
}SNNVViewContanierContentInsertType;

#import "SNNewsView.h"
#import "SNNewsMenu.h"
#import "SNNewsPageView.h"

@interface SNNewsView ()
#pragma mark - 私有属性.

@property (retain, nonatomic) UIScrollView * SNNVViewContainer; //!< 用于放置视图.
@property (retain, nonatomic) SNNewsHeaderView * SNNVHeaderView; //!< 页眉用于导航.
@property (assign, nonatomic) NSUInteger  SNNVIndexOfCurrentPage; //!< 当前页面的位置.
@property (assign, nonatomic) SNNVViewContanierContentInsertType SNNVInsertType; //!< 用于实时记录往容器视图插入视图的方式.
@property (retain, nonatomic) SNNewsMenu * SNNVMenu; //!< 新闻菜单.
@property (retain, nonatomic) NSNumber * SNNVheightOfHeaderView; //!< 页眉高度.
@end

@implementation SNNewsView
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    
    self.SNNVViewContainer = nil;
    self.SNNVHeaderView = nil;
    self.SNNVheightOfHeaderView = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.SNNVIndexOfCurrentPage = NSUIntegerMax;
        self.SNNVInsertType = UIDataDetectorTypeNone;
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (nil == self.window) {
        [self SNNVSetUpSubviews];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 正确布局视图容器上视图的相对位置. */
    CGRect bouds = self.SNNVViewContainer.bounds;
    if (SNNVViewContanierContentInsertTypeMiddle == self.SNNVInsertType ||
        SNNVViewContanierContentInsertTypeTail == self.SNNVInsertType) {
        bouds.origin.x = self.frame.size.width;
    }
    self.SNNVViewContainer.bounds = bouds;
    
}


#pragma mark - 私有方法
/**
 *  初始化子视图.
 */
- (void) SNNVSetUpSubviews;
{
    /* 使用"约束"进行界面布局. */
    NSNumber *  navHeight = self.SNNVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.SNNVheightOfHeaderView; //!< 页眉高度.
    
    /* 设置页眉. */
    SNNewsHeaderView * headerView = [[SNNewsHeaderView alloc] init];
    headerView.dataSource = self;
    headerView.delegate = self;
    [headerView setTranslatesAutoresizingMaskIntoConstraints: ! [[headerView class] requiresConstraintBasedLayout]];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.SNNVHeaderView = headerView;
    [self addSubview: self.SNNVHeaderView];
    SNRelease(headerView);
    
    
    // 设置视图容器.
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.showsVerticalScrollIndicator = NO;
    viewContainer.showsHorizontalScrollIndicator = NO;
    viewContainer.pagingEnabled = YES;
    viewContainer.bounces = NO;
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    viewContainer.delegate = self;
    
    self.SNNVViewContainer = viewContainer;
    SNRelease(viewContainer);
    [self addSubview: self.SNNVViewContainer];
    
    // 设置视图间的约束.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];

    [self addConstraints: constraintsArray];
    
    /* 设置页面上初始显示的视图. */
    NSUInteger indexOfSetUpCell = 0;
    if ([self.dataSource respondsToSelector: @selector(indexForSetUpCellInNewsView:)]) {
        // !!!:这个值,应该通过 NewsMenu传入!
        indexOfSetUpCell = [self.dataSource indexForSetUpCellInNewsView: self];
        
        if (indexOfSetUpCell > self.SNNVMenu.itemsAdded.count) {
            indexOfSetUpCell = 0;
        }
    }
    
    [self SNNVShowCellAtIndex: indexOfSetUpCell];
}

/**
 *  获取页眉高度.
 *
 *  @return 页眉高度.
 */
- (NSNumber *)SNNVheightOfHeaderView
{
    if (nil != _SNNVheightOfHeaderView) {
        return _SNNVheightOfHeaderView;
    }
    
    CGFloat height = 42.0; // 默认42.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForHeaderInNewsView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForHeaderInNewsView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    self.SNNVheightOfHeaderView = heightValue;
    
    return _SNNVheightOfHeaderView;
}

// !!!:应该把下面两个方法变成属性,以免重复向代理请求数据.
/**
 *  获取导航栏高度.
 *
 *  @return 导航栏高度.
 */
- (NSNumber *) SNNVheightOfNavigation
{
    CGFloat height = 64.0; // 默认64.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForNavigationInNewsView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForNavigationInNewsView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    return heightValue;
}

- (void)setSNNVIndexOfCurrentPage:(NSUInteger)SNNVIndexOfCurrentPage
{
    _SNNVIndexOfCurrentPage = SNNVIndexOfCurrentPage;
    
    if (NSUIntegerMax == self.SNNVIndexOfCurrentPage) {
        return;
    }
    
    self.SNNVHeaderView.selectedIndex = SNNVIndexOfCurrentPage;
}

/**
 *  显示第几个位置的视图.
 *
 *  @param index 要显示的视图的位置.
 */
- (void) SNNVShowCellAtIndex: (NSUInteger) index
{
    // 更新当前视图.
    self.SNNVIndexOfCurrentPage = index;
    
    // 移除已有的子视图及其"约束",避免冲突.
    [self.SNNVViewContainer removeConstraints: self.SNNVViewContainer.constraints];
    [self.SNNVViewContainer.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    /* 设置新的约束. */
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width];
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.SNNVheightOfHeaderView doubleValue] - [self.SNNVheightOfNavigation doubleValue]];
    
    // 用于存储新的约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    /* 考虑一种特殊情况:整个轮转视图,只有一个页面.*/
    if (1 == self.SNNVMenu.itemsAdded.count) {
        self.SNNVInsertType = SNNVViewContanierContentInsertTypeHead;
        
        // 获取视图.
        SNNewsPageView * view = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[0] preLoad: NO];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.SNNVViewContainer addSubview: view];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[view(==widthOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(view)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(view)]];
        
        [self.SNNVViewContainer addConstraints: constraints];
        return;
    }
    
    /* 考虑位置为0的情况,此时仅需要设置位置0和1的视图. */
    if (0 == index) {
        self.SNNVInsertType = SNNVViewContanierContentInsertTypeHead;
        
        // 优先从已经存储的视图中获取.
        UIView * viewZero = [self.dataSource newsView:self viewForTitle:self.SNNVMenu.itemsAdded[0] preLoad: NO];
        viewZero.translatesAutoresizingMaskIntoConstraints = NO;
        [self.SNNVViewContainer addSubview: viewZero];
        
        UIView * viewOne = [self.dataSource newsView:self viewForTitle:self.SNNVMenu.itemsAdded[1] preLoad: YES];
        viewOne.translatesAutoresizingMaskIntoConstraints = NO;
        [self.SNNVViewContainer addSubview: viewOne];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewZero(==widthOfViewContainer)][viewOne(==viewZero)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewZero, viewOne)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewZero(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewZero)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewOne(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewOne)]];
        
        [self.SNNVViewContainer addConstraints: constraints];
        return;
    }
    
    /* 考虑视图为最后一个视图的情况:此时仅需要设置最后两张图片. */
    if (index == self.SNNVMenu.itemsAdded.count - 1) {
        self.SNNVInsertType = SNNVViewContanierContentInsertTypeTail;
        
        // 优先从已经存储的视图中获取视图.
        UIView * viewTrail = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[index] preLoad: NO];
        viewTrail.translatesAutoresizingMaskIntoConstraints = NO;
        [self.SNNVViewContainer addSubview: viewTrail];
        
        UIView * viewLast = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[index - 1] preLoad: YES];
        viewLast.translatesAutoresizingMaskIntoConstraints = NO;
        [self.SNNVViewContainer addSubview: viewLast];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewLast(==widthOfViewContainer)][viewTrail(==viewLast)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewLast, viewTrail)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewLast(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewLast)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewTrail(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewTrail)]];
        
        [self.SNNVViewContainer addConstraints: constraints];
        [self.SNNVViewContainer setNeedsUpdateConstraints];
        return;
    }
    
    
    /* 下面就是最平常的情况:需要设置自己及其左右邻近位置的视图. */
    
    self.SNNVInsertType = SNNVViewContanierContentInsertTypeMiddle;
    
    // 依然优先从已经存储的视图中获取视图.
    UIView * viewLeft = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[index -1] preLoad: YES];
    viewLeft.translatesAutoresizingMaskIntoConstraints = NO;
    [self.SNNVViewContainer addSubview: viewLeft];
    
    UIView * viewMiddle = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[index] preLoad: NO];
    viewMiddle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.SNNVViewContainer addSubview: viewMiddle];
    
    UIView * viewRight = [self.dataSource newsView: self viewForTitle: self.SNNVMenu.itemsAdded[index + 1] preLoad: YES];
    viewRight.translatesAutoresizingMaskIntoConstraints = NO;
    [self.SNNVViewContainer addSubview: viewRight];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewLeft(==viewRight)][viewMiddle(==viewRight)][viewRight(==widthOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft, viewMiddle, viewRight)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewLeft(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewMiddle(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewMiddle)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewRight(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewRight)]];
    
    [self.SNNVViewContainer addConstraints: constraints];
}

- (SNNewsMenu *)SNNVMenu
{
    if (nil == _SNNVMenu) {
        self.SNNVMenu = [self.dataSource menuInNewsView: self];
    }
    
    return _SNNVMenu;
}

# pragma mark - 协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /* 更新视图 */
    if (SNNVViewContanierContentInsertTypeHead == self.SNNVInsertType &&
        self.frame.size.width == scrollView.contentOffset.x) {
        [self SNNVShowCellAtIndex: self.SNNVIndexOfCurrentPage + 1];
        return;
    }
    
    if (SNNVViewContanierContentInsertTypeTail == self.SNNVInsertType &&
        0 == scrollView.contentOffset.x) {
        [self SNNVShowCellAtIndex: self.SNNVIndexOfCurrentPage - 1];
        return;
    }
    
    if (SNNVViewContanierContentInsertTypeMiddle == self.SNNVInsertType) {
        if (0 == scrollView.contentOffset.x) {
            [self SNNVShowCellAtIndex: self.SNNVIndexOfCurrentPage - 1];
        }
        if (2 * self.frame.size.width == scrollView.contentOffset.x) {
            [self SNNVShowCellAtIndex: self.SNNVIndexOfCurrentPage + 1];
        }
    }
}

#pragma mark - SNNewsHeaderViewDataSource协议方法.
- (SNNewsMenu *) menuInNewsHeaderView: (SNNewsHeaderView *) newsHeaderView
{
    return self.SNNVMenu;
}

#pragma mark - SNNewsHeaderViewDelegate协议方法.
- (void) newsHeaderView: (SNNewsHeaderView *) newsHeaderView
didClickSegmentActionAtIndex: (NSUInteger) index
{
    [self SNNVShowCellAtIndex: index];
}

- (NSNumber *)heightForNewsView:(SNNewsHeaderView *)newsHeaderView
{
    return self.SNNVheightOfHeaderView;
}
@end
