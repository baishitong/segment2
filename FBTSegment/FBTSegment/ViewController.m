//
//  ViewController.m
//  FBTSegment
//
//  Created by zsw on 2017/4/8.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "FBTButton.h"
#import "UIView+Ext.h"
static CGFloat height = 40;


@interface ViewController ()
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *selectBgView;
@property (nonatomic, strong) UIView *selectUnderline;
@property (nonatomic, strong) UIButton *previousClickedSelectButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"shenxu";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化子控制器
    [self setupAllChildVcs];
    // scrollView
    [self setupScrollView];
    
    //选择栏
    [self setupSelectView];
    
    // 添加第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];
    NSLog(@"我提交了一次测试");
}
/**
 *  初始化子控制器
 */
- (void)setupAllChildVcs
{
    FirstViewController *FirstVc = [[FirstViewController alloc] init];
    [self addChildViewController:FirstVc];
    
    SecondViewController *SecondVc = [[SecondViewController alloc] init];
    [self addChildViewController:SecondVc];
}

/**
 *  scrollView
 */
- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-height)];
    
    [self.view addSubview:self.scrollView];
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    // 添加子控制器的view
    //    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollViewW, 0);
}
/**
 *  选择栏
 */
- (void)setupSelectView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.selectBgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    [self.view addSubview:self.selectBgView];
    // 选择栏按钮
    [self setupSelectButtons];
    
    // 选择下划线
    [self setupSelectUnderline];
}

/**
 * 选择栏按钮
 */
- (void)setupSelectButtons
{
    // 文字
    NSArray *titles = @[@"我发起的啪啪啪和我女神爱萝莉", @"受邀参加的啪啪啪和我女神爱萝莉"];
    NSUInteger count = titles.count;
    
    // 选择按钮的尺寸
    CGFloat selectButtonW = [UIScreen mainScreen].bounds.size.width / count;
    NSLog(@"%f",selectButtonW);
    CGFloat selectButtonH = height;
    
    // 创建选择按钮
    for (NSUInteger i = 0; i < count; i++) {
        FBTButton *selectButton = [[FBTButton alloc] init];
        selectButton.tag = i;
        
        //   if (i==0) {
        //    selectButton.backgroundColor = [UIColor redColor];
        // }else{
        //     selectButton.backgroundColor = [UIColor blueColor];
        //}
        
        [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectBgView addSubview:selectButton];
        // frame
        selectButton.frame = CGRectMake(i * selectButtonW, 0, selectButtonW, selectButtonH);
        // 文字
        [selectButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}

/**
 *  选择按钮下划线
 */
- (void)setupSelectUnderline
{
    // 选择按钮
    FBTButton *firstButton = self.selectBgView.subviews.firstObject;
    
    // 下划线
    UIView *selectUnderline = [[UIView alloc] init];
    selectUnderline.height = 2;
    selectUnderline.originY = self.selectBgView.height - selectUnderline.height;
    selectUnderline.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    [self.selectBgView addSubview:selectUnderline];
    self.selectUnderline = selectUnderline;
    
    // 切换按钮状态
    firstButton.selected = YES;
    self.previousClickedSelectButton = firstButton;
    
    [firstButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.selectUnderline.width = firstButton.titleLabel.width + 10;
    //self.selectUnderline.width = firstButton.titleLabel.width + 10;
    self.selectUnderline.centerX = firstButton.centerX;
}

- (void)selectButtonClick:(UIButton *)selectButton {
    NSLog(@"--------->>>");
    // 重复点击了选择按钮
    if (self.previousClickedSelectButton == selectButton) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:SelectButtonDidRepeatClickNotification object:nil];
    }
    
    // 切换按钮状态
    self.previousClickedSelectButton.selected = NO;
    selectButton.selected = YES;
    self.previousClickedSelectButton = selectButton;
    
    NSUInteger index = selectButton.tag;
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.selectUnderline.width = selectButton.titleLabel.width + 10;
        self.selectUnderline.centerX = selectButton.centerX;
        
        // 滚动scrollView
        CGFloat offsetX = self.scrollView.width * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == index);
    }
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出选择按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 点击对应的按钮
    FBTButton *titleButton = self.selectBgView.subviews[index];
    [self selectButtonClick:titleButton];
}

#pragma mark - 其他
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
