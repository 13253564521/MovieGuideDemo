//
//  MovieGuideViewController.m
//  MovieGuideDemo
//
//  Created by 刘高升 on 2017/6/6.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "MovieGuideViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MovieGuideViewController ()<UIScrollViewDelegate>
{

    AVPlayer *_avPlayer;
    AVPlayerItem *_playerItem;
    AVPlayerViewController *_avPlayerVC;
    UIScrollView *_baseScrollView;
    UIPageControl *_pageControll;


}
@property (nonatomic , strong) NSMutableArray *contentArray;
@end

@implementation MovieGuideViewController
//懒加载
- (NSMutableArray *)contentArray {

    if (_contentArray == nil) {
        _contentArray = [NSMutableArray arrayWithObjects:@"每个动作都精确规范",@"规划陪伴你的训练过程",@"分享汗水后你的性感",@"全程记录你的健身数据", nil];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self initAVVC];
}

- (void)initAVVC {

   NSString *path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@".mp4"];
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    _avPlayerVC = [[AVPlayerViewController alloc]init];
    _avPlayerVC.player = _avPlayer;
    _avPlayerVC.view.frame = self.view.bounds;
    _avPlayerVC.showsPlaybackControls = NO;
    [_avPlayer play];
    [self.view addSubview:_avPlayerVC.view];
    
    //初始化滑动视图
    [self initBaseScrollView];
    
    //注册通知 重复播放
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}


- (void)initBaseScrollView {

    _baseScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _baseScrollView.backgroundColor = [UIColor clearColor];
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.contentSize = CGSizeMake(self.contentArray.count * self.view.bounds.size.width, self.view.bounds.size.height);
    _baseScrollView.delegate = self;
    [self.view addSubview:_baseScrollView];
    
    //初始化pagecontroller
    [self initPagecontroll];



}


- (void)initPagecontroll {

    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height * 5 / 6, 100, 20)];
    _pageControll.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 5 / 6);
    _pageControll.currentPage = 0;
    _pageControll.numberOfPages = self.contentArray.count;
    _pageControll.pageIndicatorTintColor = [UIColor grayColor];
    _pageControll.currentPageIndicatorTintColor = [UIColor greenColor];
    [self.view addSubview:_pageControll];
    for (NSInteger i = 0; i < self.contentArray.count; i++) {
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(i * self.view.bounds.size.width, _pageControll.frame.origin.y - 50, self.view.bounds.size.width, 25)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = self.contentArray[i];
        [_baseScrollView addSubview:titleLable];
    }
    



}


- (void)runLoopTheMovie:(NSNotification *)noti {
    
    [_playerItem seekToTime:kCMTimeZero];
    [_avPlayer play];


    NSLog(@"重复播放。。");
}





#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currenPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControll.currentPage = currenPage;

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSInteger currenPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControll.currentPage = currenPage;


}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
