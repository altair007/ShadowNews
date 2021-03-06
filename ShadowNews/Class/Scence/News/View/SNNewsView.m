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
// !!!: 清除各视图中不必要的视图相关的属性,即不在初始化视图意外的地方使用的属性.
@property (retain, nonatomic, readwrite) SNNewsPageView * currentPageView;
#pragma mark - 私有属性.
@property (retain, nonatomic) UIScrollView * SNNVViewContainer; //!< 用于放置视图.
@property (retain, nonatomic) SNNewsHeaderView * SNNVHeaderView; //!< 页眉用于导航.
@property (assign, nonatomic) SNNVViewContanierContentInsertType SNNVInsertType; //!< 用于实时记录往容器视图插入视图的方式.
@property (retain, nonatomic) SNNewsMenu * SNNVMenu; //!< 新闻菜单.
@property (retain, nonatomic) NSNumber * SNNVheightOfHeaderView; //!< 页眉高度.
@property (assign, nonatomic) BOOL SNNVSubviewsSetUp; //!< 是否已经初始化子视图.
@property (retain, nonatomic) NSMutableDictionary * SNNVLoadedViews; //!< 存储已加载的视图.以新闻版块名为键,以视图为值.
@property (retain, nonatomic) NSMutableDictionary * SNNVDelegates; //!< 存储已经加载的视图对象的代理.
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
    self.currentPageView = nil;
    
    self.SNNVViewContainer = nil;
    self.SNNVHeaderView = nil;
    self.SNNVheightOfHeaderView = nil;
    self.SNNVLoadedViews = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.SNNVInsertType = UIDataDetectorTypeNone;
        self.SNNVLoadedViews = [NSMutableDictionary dictionaryWithCapacity: 42];
        self.SNNVDelegates = [NSMutableDictionary dictionaryWithCapacity: 42];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    // 仅当第一次显示视图到窗口上时,需要初始化视图.
    if (nil == self.window &&
        YES != self.SNNVSubviewsSetUp) {

        
        [self SNNVSetUpSubviews];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    /* 正确布局视图容器上视图的相对位置. */
    CGRect bouds = self.SNNVViewContainer.bounds;
    bouds.origin.x = 0; // !!!:注意到一个现象: 当不移除子视图时,轮转视图的原偏移值会被保留.或许可以用来简化轮转视图的编写.
    bouds.origin.x = self.frame.size.width;
    self.SNNVViewContainer.bounds = bouds;
}

// !!!: 这个属性的逻辑,应该移到 currentPageView 的设置器里.
- (void) setCurrentPageView:(SNNewsPageView *)currentPageView
{
    [currentPageView retain];
    [_currentPageView release];
    _currentPageView = currentPageView;
    
    if (nil == currentPageView) {
        return;
    }
    
    // !!!: 猜想: 页眉和中心轮转图,最好也通过title连接.暂时先用index.
    
    // 获取当前视图的相对位置.
    NSUInteger index = [self.SNNVMenu.itemsAdded indexOfObject: currentPageView.title];
    
    // 使页眉导航栏同步变化.
    self.SNNVHeaderView.selectedIndex = index;
    
    /* 只保留当前页面及其当前位置的视图及其代理. */
    NSMutableArray * keysToRemove = [NSMutableArray arrayWithCapacity: 42];
    
    [self.SNNVLoadedViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 获取正在被遍历的视图的位置.
        NSUInteger indexTemp = [self.SNNVMenu.itemsAdded indexOfObject: key];
        
        if (labs(indexTemp - index) > 1 && indexTemp + index != self.SNNVMenu.itemsAdded.count -1) { // 说明不是临近视图位置.这里提供了对轮转的支持.
            [keysToRemove addObject: key];
        }
    }];
    
    [keysToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.SNNVLoadedViews removeObjectForKey: obj];
        [self.SNNVDelegates removeObjectForKey: obj];
    }];
}

#pragma mark - 私有方法

/**
 *  初始化子视图.
 */
- (void) SNNVSetUpSubviews;
{
    if (YES == self.SNNVSubviewsSetUp) { // 视图已经初始化,则直接返回.
        return;
    }
    /* 使用"约束"进行界面布局. */
    // !!!:使用自定义导航栏的话,许多属性和代理方法,就不是必须的了.请删除.
    NSNumber *  navHeight = self.SNNVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.SNNVheightOfHeaderView; //!< 页眉高度.
    
    /* 创建视图. */
    
    // 自定义导航栏.
    UIView * navigationView = [[UIView alloc] init];
    [navigationView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self addSubview: navigationView];
    SNRelease(navigationView);
    
    UIView * navigationContentView = [[UIView alloc] init];
    [navigationContentView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [navigationView addSubview: navigationContentView];
    navigationContentView.backgroundColor = [UIColor blackColor];
    SNRelease(navigationContentView);

    UILabel * titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    titleLabel.text = @"魅影资讯";
    titleLabel.font = [UIFont systemFontOfSize: 20.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationContentView addSubview: titleLabel];
    
    // !!!:临时屏蔽"设置页面".
//    UIButton * settingButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [settingButton setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [settingButton setTitle: @"设置" forState: UIControlStateNormal];
//    [settingButton addTarget: self.delegate action: @selector(newsView:didClickSettingButtonButtonAction:) forControlEvents: UIControlEventTouchUpInside];
//    settingButton.titleLabel.textColor = [UIColor whiteColor];
//    [titleLabel addSubview: settingButton];
    
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
    viewContainer.backgroundColor = self.backgroundColor;
    self.SNNVViewContainer = viewContainer;
    [self addSubview: self.SNNVViewContainer];
    SNRelease(viewContainer);
    
    
    // !!!: 视图遮罩层,用于实现夜间模式/日间模式的切换.
    UIView * maskView = [[UIView alloc] init];
    [maskView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // !!!:临时更改.
    maskView.backgroundColor = [UIColor clearColor];
//    maskView.backgroundColor = [UIColor blackColor]; //???:用黑色,合适吗?
    maskView.alpha = 0.0;
    maskView.userInteractionEnabled = NO;
    [self insertSubview: maskView atIndex: self.subviews.count];
    SNRelease(maskView);
    
    // 设置视图间的约束.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[navigationView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[navigationContentView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationContentView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-20-[navigationContentView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationContentView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[titleLabel]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(titleLabel)]];
    
    // !!!: 临时屏蔽"设置"页.
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"[settingButton(==35)]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(settingButton)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[settingButton(==44)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(settingButton)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[titleLabel(==44)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[navigationView(==64)][headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(navigationView,headerView,viewContainer)]];

    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[maskView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(maskView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[maskView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(maskView)]];
    
    [self addConstraints: constraintsArray];
    
    /* 设置页面上初始显示的视图. */
    NSUInteger indexOfSetUpCell = [self.SNNVMenu.itemsAdded indexOfObject: self.SNNVMenu.itemLastScan];
        
    if (NSNotFound == indexOfSetUpCell ||
        indexOfSetUpCell > self.SNNVMenu.itemsAdded.count) {
        indexOfSetUpCell = 0;
    }
    
    [self SNNVShowCellAtIndex: indexOfSetUpCell];
    
    // 设置视图初始化标记.
    self.SNNVSubviewsSetUp = YES;
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

/**
 *  显示第几个位置的视图.
 *
 *  @param index 要显示的视图的位置.
 */
// !!!: 视图命名可以改一下!
- (void) SNNVShowCellAtIndex: (NSUInteger) index
{
    // 移除已有的子视图及其"约束",避免冲突.
    [self.SNNVViewContainer removeConstraints: self.SNNVViewContainer.constraints];
    
    // ???:没必要移除已有的子视图吧?
    // !!!:可以通过精细化消除约束,来取代对子视图的完全移除操作?
    [self.SNNVViewContainer.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    /* 设置新的约束. */
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width];
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.SNNVheightOfHeaderView doubleValue] - [self.SNNVheightOfNavigation doubleValue]];
    
    // 用于存储新的约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    // !!!: 总感觉:根据title获取视图的逻辑,可以封装下,用的太频繁了.

    /* 下面就是最平常的情况:需要设置自己及其左右邻近位置的视图. */
    
    self.SNNVInsertType = SNNVViewContanierContentInsertTypeMiddle;
    
    // 依然优先从已经存储的视图中获取视图.
    // 中间的视图.
    NSString * titleMiddle= self.SNNVMenu.itemsAdded[index];
    SNNewsPageView * viewMiddle = [self.SNNVLoadedViews objectForKey: titleMiddle];
    viewMiddle.preLoad = NO;
    if (nil == viewMiddle) {
        viewMiddle = [self.dataSource newsView: self viewForTitle: titleMiddle preLoad: NO];
        [self.SNNVLoadedViews setObject: viewMiddle forKey: titleMiddle];
        
        // 因为代理通常是 assign, 所以此处额外持有一次delegate,以避免潜在的内存管理异常.
        [self.SNNVDelegates setObject: viewMiddle.delegate forKey: titleMiddle];
        viewMiddle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.SNNVViewContainer addSubview: viewMiddle];
    
    // 左侧视图.
    NSUInteger indexLeft = (index - 1 + self.SNNVMenu.itemsAdded.count) % self.SNNVMenu.itemsAdded.count;
    
    NSString * titleLeft = self.SNNVMenu.itemsAdded[indexLeft];
    SNNewsPageView * viewLeft = [self.SNNVLoadedViews objectForKey: titleLeft];
    viewLeft.preLoad = YES;
    if (nil == viewLeft) {
        viewLeft = [self.dataSource newsView: self viewForTitle: titleLeft preLoad: YES];
        [self.SNNVLoadedViews setObject: viewLeft forKey: titleLeft];
        
        // 因为代理通常是 assign, 所以此处额外持有一次delegate,以避免潜在的内存管理异常.
        [self.SNNVDelegates setObject: viewLeft.delegate forKey: titleLeft];
        viewLeft.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.SNNVViewContainer addSubview: viewLeft];
    
    // 右侧视图.
    NSUInteger indexRight = (index + 1) % self.SNNVMenu.itemsAdded.count;
    NSString * titleRight = self.SNNVMenu.itemsAdded[indexRight];
    SNNewsPageView * viewRight = [self.SNNVLoadedViews objectForKey: titleRight];
    viewRight.preLoad = YES;
    if (nil == viewRight) {
        viewRight = [self.dataSource newsView: self viewForTitle: titleRight preLoad: YES];
        [self.SNNVLoadedViews setObject: viewRight forKey: titleRight];
        
        // 因为代理通常是 assign, 所以此处额外持有一次delegate,以避免潜在的内存管理异常.
        [self.SNNVDelegates setObject: viewRight.delegate forKey: titleRight];
        
        viewRight.translatesAutoresizingMaskIntoConstraints = NO;
    }
    [self.SNNVViewContainer addSubview: viewRight];
    
    // 设置约束.
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewLeft(==viewRight)][viewMiddle(==viewRight)][viewRight(==widthOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft, viewMiddle, viewRight)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewLeft(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewMiddle(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewMiddle)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewRight(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewRight)]];
    
    [self.SNNVViewContainer addConstraints: constraints];
    
    // 更新当前视图.
    self.currentPageView = viewMiddle;
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
    // 获取当前视图的相对位置.
    NSUInteger index = [self.SNNVMenu.itemsAdded indexOfObject: self.currentPageView.title];
    
    /* 更新视图 */
    if (0 == scrollView.contentOffset.x) {
        [self SNNVShowCellAtIndex: (index - 1 + self.SNNVMenu.itemsAdded.count) % self.SNNVMenu.itemsAdded.count];
    }
    if (2 * self.frame.size.width == scrollView.contentOffset.x) {
        [self SNNVShowCellAtIndex: (index + 1) % self.SNNVMenu.itemsAdded.count];
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
