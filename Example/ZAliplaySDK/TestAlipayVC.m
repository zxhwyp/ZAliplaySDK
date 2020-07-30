//
//  TestAlipayVC.m
//  AliyunVideoClient_Entrance
//
//  Created by 刘家伟 on 2020/7/24.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import "TestAlipayVC.h"
#import "AlivcLongVideoSTSConfig.h"
#import "AlivcLongVideoPlayView.h"
#import "AliyunUtil.h"
#import "AliPlayManger.h"
#import "AVPTool.h"
#import "AlivcPlayVideoRequestManager.h"

@interface TestAlipayVC ()<AliyunVodPlayerViewDelegate>

@property (nonatomic, strong) AlivcLongVideoPlayView *playerView;// 包含了各种控件的播放页面
@property (nonatomic, strong) AliPlayManger *manager;

@end

@implementation TestAlipayVC

- (AliPlayManger *)manager {
    if (!_manager) {
        _manager = [[AliPlayManger alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16)];
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *iv = self.manager.playerView;
    [self.view addSubview:iv];
    NSLog(@"俯视图：%@,子视图：%@",iv.superview, iv);
    
    [self getNewPlayerPlayList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark 新播放器请求和播放

- (void)getNewPlayerPlayList {
//    [AVPTool loadingHudToView:self.view];
//    [AlivcPlayVideoRequestManager getWithParameters:nil urlType:AVPUrlTypePlayerVideoList success:^(AVPDemoResponseModel *resultModel) {
//        [AVPTool hideLoadingHudForView:self.view];
//        NSMutableArray <AlivcLongVideoTVModel *>*tempArray = [NSMutableArray array];
//        NSMutableArray <NSString *>*array = [NSMutableArray array];
//        for (AVPDemoResponseVideoListModel *model in resultModel.data.videoList) {
//            AlivcLongVideoTVModel *TVmodel = [[AlivcLongVideoTVModel alloc]init];
//            TVmodel.videoId = model.videoId;
//            TVmodel.coverUrl = model.coverUrl;
//            TVmodel.title = model.title;
//            TVmodel.descriptionStr = model.descriptionStr;
//            [tempArray addObject:TVmodel];
//            [array addObject:model.videoId];
//        }
//
//        [self.manager setVidsArray:array];
//        [self.manager startVidPlay];
//        [self.manager prePlayWithTimeInterval:60];
//    } failure:^(NSString *errorMsg) {
//        [AVPTool hideLoadingHudForView:self.view];
//        [AVPTool hudWithText:errorMsg view:self.view];
//    }];
}



@end
