//
//  AliPlayManger.m
//  AliyunVideoClient_Entrance
//
//  Created by 刘家伟 on 2020/7/26.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import "AliPlayManger.h"
#import "AVPTool.h"
#import "AlivcPlayVideoRequestManager.h"

@implementation AliPlayManger

/// 初始化播放器
/// @param frame 播放器视图坐标
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // 初始化加密文件
        NSString *encrptyFilePath = [[NSBundle mainBundle] pathForResource:@"encryptedApp" ofType:@"dat"];
        [AliPrivateService initKey:encrptyFilePath];
        
        // 初始化网络监听
        self.reachability = [AliyunReachability reachabilityForInternetConnection];
        
        // 下载器进度管理初始化
        self.downLoadProgressManager = [AlivcLongVideoDownLoadProgressManager sharedInstance];
        self.downLoadProgressManager.delegate = self;
        self.downLoadManager = [AlivcLongVideoDownLoadManager shareManager];
        self.downLoadManager.delegate = self.downLoadProgressManager;
        
        // 初始化播放器
        self.playerView = [[AlivcLongVideoPlayView alloc] initWithFrame:frame];
        self.playerView.delegate = self;
        self.playerView.previewView.delegate = self;
        // 播放器默认设置
        AlivcVideoPlayPlayerConfig *config = [AlivcVideoPlayPlayerConfig new];
        config.sourceType = SourceTypeNull;
        [self.playerView setPlayerAllConfig:config];
        [self.playerView setPlayFinishDescribe:@"再次观看，请点击重新播放"];
        [self.playerView setNetTimeOutDescribe:@"当前网络不佳，请稍后点击重新播放"];
        [self.playerView setNoNetDescribe:@"无网络连接，检查网络后点击重新播放"];
        [self.playerView setLoaddataErrorDescribe:@"视频加载出错，请点击重新播放"];
        [self.playerView setUseWanNetDescribe:@"当前为移动网络，请点击播放"];
        __weak typeof(self) weakSelf = self;
        // 播放器各种状态的回调
        self.playerView.playerStatusChangeBlock = ^(AVPStatus status) {
            if (weakSelf.finishView && weakSelf.finishView.superview && status != AVPStatusCompletion) {
                [weakSelf.finishView removeFromSuperview];
            }
        };
        
    }
    return self;
}

/// 设置播放列表
/// @param VidArray 播放列表数组，里面转载的是 videoid
- (void)setPlayListsWithVideoIdsArray:(NSArray <NSString *>*)VidArray {
    self.vidsArray = VidArray;
}

/// 开始Vid地址播放
- (void)startVidPlay {
    if (!self.playerView.currentModel && self.vidsArray.count > 0) {
        // 获取vid
        NSString *vid = self.vidsArray.firstObject;
        UIView *view = self.playerView.superview;
        if (!view) {
            view = self.playerView;
        }
        [AVPTool loadingHudToView:view];
        __weak typeof(self) weakSelf = self;
        [self getVideoPlayAuthInfoWithVideoId:vid block:^(NSString *playAuth) {
            AVPVidAuthSource *source = [[AVPVidAuthSource alloc]initWithVid:vid playAuth:playAuth region:@"cn-shanghai"];
            if (!weakSelf.playerView.currentModel) {
                AlivcVideoPlayListModel *mo = [[AlivcVideoPlayListModel alloc] init];
                mo.videoId = vid;
                weakSelf.playerView.currentModel = mo;
            }
            weakSelf.playerView.authSource = source;
            [weakSelf.playerView playViewPrepareWithVid:vid playAuth:source.playAuth];
        }];
    }else{
        [self.playerView start];
    }
}

/// STS鉴权播放播放
/// @param vid 视频ID
/// @param auth 鉴权
- (void)playerWithVid:(NSString *)vid playAuth:(NSString *)auth {
    [self.playerView playViewPrepareWithVid:vid playAuth:auth];
}


/// 自动播放下一个
- (void)moveToNext {
    if (self.vidsArray.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < self.vidsArray.count; i++) {
        NSString *vid = self.vidsArray[i];
        if ([self.playerView.authSource.vid isEqualToString:vid]) {
            if ((i + 1) < self.vidsArray.count) {
                vid = self.vidsArray[i + 1];
                [self getVideoPlayAuthInfoWithVideoId:vid block:^(NSString *playAuth) {
                    AVPVidAuthSource *source = [[AVPVidAuthSource alloc]initWithVid:vid playAuth:playAuth region:@"cn-shanghai"];
                    if (!weakSelf.playerView.currentModel) {
                        AlivcVideoPlayListModel *mo = [[AlivcVideoPlayListModel alloc] init];
                        mo.videoId = vid;
                        weakSelf.playerView.currentModel = mo;
                    }
                    weakSelf.playerView.authSource = source;
                    [weakSelf.playerView playViewPrepareWithVid:vid playAuth:source.playAuth];
                }];
            }
            break;
        }
    }
}
/// 传参播放下一个
- (void)changePlayVidSource:(NSString *)vid {
    __weak typeof(self) weakSelf = self;
    [self getVideoPlayAuthInfoWithVideoId:vid block:^(NSString *playAuth) {
        AVPVidAuthSource *source = [[AVPVidAuthSource alloc]initWithVid:vid playAuth:playAuth region:@"cn-shanghai"];
        if (!weakSelf.playerView.currentModel) {
            AlivcVideoPlayListModel *mo = [[AlivcVideoPlayListModel alloc] init];
            mo.videoId = vid;
            weakSelf.playerView.currentModel = mo;
        }
        weakSelf.playerView.authSource = source;
        [weakSelf.playerView playViewPrepareWithVid:vid playAuth:source.playAuth];
    }];
}

//TODO: 播放完成
- (void)onFinishWithAliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView {
    // 设置自动播放
//    if (!self.finishView) {
//        if (!self.finishView) {
//            self.finishView = [AliyunPlayerFinishView new];
//            __weak typeof(self) weakSelf = self;
//            __block AliyunPlayerFinishView *vi = self.finishView;
//            self.finishView.block = ^(NSString * _Nonnull senderName) {
//                if ([senderName isEqualToString:@"rePlayButton"]) {
//                    [weakSelf.playerView seekTo:0];
//                    [weakSelf.playerView start];
//                }else if ([senderName isEqualToString:@"nextPlayButton"]) {
//                    [weakSelf moveToNext];
//                }
//                [vi removeFromSuperview];
//            };
//        }
//    }else{
//        if (self.finishView.superview) {
//            [self.finishView removeFromSuperview];
//        }
//    }
//
//    [playerView addSubview:self.finishView];
//    self.finishView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.finishView.centerYAnchor constraintEqualToAnchor:playerView.centerYAnchor].active = true;
//    [self.finishView.centerXAnchor constraintEqualToAnchor:playerView.centerXAnchor].active = true;
//    [self.finishView.widthAnchor constraintEqualToConstant:300].active = true;
//    [self.finishView.heightAnchor constraintEqualToConstant:30].active = true;
    
    NSLog(@"onFinishWithAliyunVodPlayerView");
}

/// 重新播放
- (void)rePlay {
    [self.playerView seekTo:0];
    [self.playerView start];
}

/**
 * 功能：所有事件发生的汇总
 * 参数：event ： 发生的事件
 */
- (void)aliyunVodPlayerView:(AlivcLongVideoPlayView*)playerView happen:(AVPEventType )event {
    NSLog(@"");
}

// TODO: 继续播放
- (void)aliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView onResume:(NSTimeInterval)currentPlayTime {
    NSLog(@"onResume");
}

// TODO: 暂停播放
- (void)aliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView onPause:(NSTimeInterval)currentPlayTime {
    NSLog(@"onPause");
}

// TODO: 拖动进度条结束事件
- (void)aliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView onSeekDone:(NSTimeInterval)seekDoneTime {
    NSLog(@"onSeekDone");
    
}

- (void)onClickedBarrageBtnWithVodPlayerView:(AlivcLongVideoPlayView *)playerView {
    NSLog(@"onClickedBarrageBtnWithVodPlayerView");
}

// TODO: 下载按钮
- (void)onDownloadButtonClickWithAliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView {
    NSLog(@"onDownloadButtonClickWithAliyunVodPlayerView");
}

#pragma mark - 代理
//TODO: 全屏事件代理
- (void)aliyunVodPlayerView:(AlivcLongVideoPlayView *)playerView fullScreen:(BOOL)isFullScreen {
    NSLog(@"isFullScreen : %d, [AliyunUtil isInterfaceOrientationPortrait] = %d",isFullScreen, [AliyunUtil isInterfaceOrientationPortrait]);
    static CGRect rect;
    static UIView *oldView;
    if (![AliyunUtil isInterfaceOrientationPortrait]) {
        [self.playerView setTopViewWithBackBtnisShow:true topViewWithTitleisShow:true];
        rect = playerView.frame;
        oldView = playerView.superview;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [playerView removeFromSuperview];
        [window addSubview:playerView];
        playerView.frame = [UIScreen mainScreen].bounds;
    }else if (oldView) {
        [playerView removeFromSuperview];
        [oldView addSubview:playerView];
        [self.playerView setTopViewWithBackBtnisShow:false topViewWithTitleisShow:false];
        self.playerView.frame = rect;
    }else{
        
    }
}

// TODO: 返回按钮事件代理
- (void)onBackViewClickWithAliyunVodPlayerView:(nonnull AlivcLongVideoPlayView *)playerView {
    if (![AliyunUtil isInterfaceOrientationPortrait]) {
        [AliyunUtil setFullOrHalfScreen];
        [self aliyunVodPlayerView:playerView fullScreen:NO];
    }
    NSLog(@"屏幕模式：%d",[AliyunUtil isInterfaceOrientationPortrait]);
}

/// 开始播放
- (void)start {
    [self.playerView start];
}

/// 停止播放
- (void)stop {
    [self.playerView stop];
}

/**
 功能：重载播放
 */
- (void)reload {
    [self.playerView reload];
}
/**
 功能：暂停播放视频
 */
- (void)pause {
    [self.playerView pause];
}

/**
 功能：继续播放视频，此功能应用于pause之后，与pause功能匹配使用
 */
- (void)resume {
    [self.playerView resume];
}
/**
 功能：seek到某个时间播放视频
 */
- (void)seekTo:(NSTimeInterval)seekTime {
    [self.playerView seekTo:seekTime];
}

/**
 功能：释放播放器
 */
- (void)releasePlayer {
    [self.playerView releasePlayer];
}

/// 设置成静音
/// @param muted 静音标识
- (void)setMuted:(BOOL)muted {
    self.playerView.muted = muted;
}

/// 设置音量
/// @param volum 音量大小
- (void)setVolum:(CGFloat)volum {
    [self.playerView setVolume:volum];
}

/// 播放速度 0.5-2.0之间，1为正常播放
/// @param speedValue 0.5-2.0之间，1为正常播放
- (void)changeSpeed:(CGFloat)speedValue {
    [self.playerView setRate:speedValue];
}

/// 播放本地视频文件
/// @param path 视频文件地址
- (void)playWithLocalSource:(NSString *)path {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView playViewPrepareWithLocalURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",self.downLoadManager.downLoadPath,path]]];
    });
}

/// 全屏播放
- (void)setScreenFull {
    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        [AliyunUtil setFullOrHalfScreen];
        [self aliyunVodPlayerView:self.playerView fullScreen:YES];
    }
}

/// 设置亮度
/// @param brightness 亮度
- (void)setWindowBrightness:(CGFloat)brightness {
    if (brightness > 1) {
        brightness = 1;
    }else if (brightness < 0.1) {
        brightness = 0.1;
    }
    [UIScreen mainScreen].brightness = brightness;
}

#pragma mark - 下载资源部分

/// 准备下载资源
/// @param vid 资源的videoID
/// @param auth 资源的鉴权
/// @param path 资源保存的地址
- (void)startDownLoad:(NSString *)vid playAuth:(NSString *)auth withPath:(NSString *)path {
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunSVNetworkStatusNotReachable: {
            [AVPTool hudWithText:@"当前无网络,请连网后重试!" view:self.playerView.superview];
        }
            break;
        case AliyunSVNetworkStatusReachableViaWiFi: {
            if (vid && auth) {
                [self goToCacheControllerWithPath:path withVid:vid playAuth:auth];
            }else{
                [self goToCacheControllerWithPath:path withVid:self.playerView.authSource.vid playAuth:self.playerView.authSource.playAuth];
            }
        }
            break;
        case AliyunSVNetworkStatusReachableViaWWAN: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前为移动数据网络，是否继续下载？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            __weak typeof(self)weakSelf = self;
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                if (vid && auth) {
                    [weakSelf goToCacheControllerWithPath:path withVid:vid playAuth:auth];
                }else{
                    [weakSelf goToCacheControllerWithPath:path withVid:weakSelf.playerView.authSource.vid playAuth:weakSelf.playerView.authSource.playAuth];
                }
            }];
            [alert addAction:sureAction];
            UIViewController *vc = [self.playerView findCurrentViewController];
            [vc presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

/// 开始下载
/// @param path 下载后的资源保存地址
/// @param vid 资源的videoID
/// @param auth 资源的鉴权
- (void)goToCacheControllerWithPath:(NSString *)path withVid:(NSString *)vid playAuth:(NSString *)auth {
    
    AlivcLongVideoTVModel *mo = [[AlivcLongVideoTVModel alloc] init];
    mo.videoId = vid;
    AlivcLongVideoDownloadSource *currentSource = [[AlivcLongVideoDownloadSource alloc]init];
    currentSource.longVideoModel = mo;
    self.downLoadManager.downLoadPath = path;
    currentSource.authSource = [[AVPVidAuthSource alloc] initWithVid:vid playAuth:auth region:@""];
    currentSource.trackIndex = -1;
    currentSource.downloadSourceType = DownloadSourceTypeAuth;
    self.currentDownloadSource = currentSource;
    [AVPTool loadingHudToView:self.playerView.superview];
    //15秒超时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AVPTool hideLoadingHudForView:self.playerView.superview];
    });
    
    [self.downLoadManager clearAllPreparedSources];
    [self.downLoadManager prepareDownloadSource:currentSource];
}

- (AlivcLongVideoDefinitionSelectView *)definitionSelectView {
    if (!_definitionSelectView) {
        _definitionSelectView = [[AlivcLongVideoDefinitionSelectView alloc]init];
        _definitionSelectView.delegate = self;
        _definitionSelectView.hidden = YES;
    }
    return _definitionSelectView;
}

- (void)alivcLongVideoDownLoadProgressManagerPrepared:(AlivcLongVideoDownloadSource *)source mediaInfo:(AVPMediaInfo *)mediaInfo {
    [AVPTool hideLoadingHudForView:self.playerView.superview];
    
    if (!self.definitionSelectView.superview) {
        [self.playerView.window addSubview:self.definitionSelectView];
    }
    self.definitionSelectView.trackInfoArray = mediaInfo.tracks;
    [UIView animateWithDuration:0.2 animations:^{
        self.definitionSelectView.frame = [UIScreen mainScreen].bounds;
        self.definitionSelectView.hidden = NO;
    }];
}

- (void)alivcLongVideoDownLoadProgressManagerOnProgress:(AlivcLongVideoDownloadSource *)source percent:(int)percent {
    NSLog(@"下载进度：%d",percent);
}

- (void)alivcLongVideoDownLoadProgressManagerComplete:(AlivcLongVideoDownloadSource *)source {
    NSLog(@"下载完成：source:%@",source.downloadedFilePath);
}

- (void)alivcLongVideoDownLoadProgressManagerStateChanged:(AlivcLongVideoDownloadSource *)source {
    NSLog(@"下载状态改变");
}

#pragma mark 下载清晰度选择视图代理AlivcLongVideoDefinitionSelectViewDelegate

- (void)alivcLongVideoDefinitionSelectViewSelecTrack:(AVPTrackInfo *)info{
    
    // 开始下载
    if (info == nil) {
        [self.downLoadManager clearAllPreparedSources];
        return;
    }
    
    self.currentDownloadSource.trackIndex = info.trackIndex;
    
    AlivcLongVideoDownloadSource *hasSource = [self.downLoadManager hasDownloadSource:self.currentDownloadSource];
    if (hasSource.downloadStatus != LongVideoDownloadTypePrepared) {
        [MBProgressHUD showMessage:@"已经加入下载列表" inView:self.playerView.superview];
        return;
    }
    
    CGFloat mSize =  info.vodFileSize /1024.0 /1024.0;
    NSString *mString = [NSString stringWithFormat:@"%.1fM",mSize];
    self.currentDownloadSource.totalDataString = mString;
    
    [self.downLoadManager addDownloadSource:self.currentDownloadSource];
    [self.downLoadManager startDownloadSource:self.currentDownloadSource];
    
    [MBProgressHUD showMessage:@"加入下载列表" inView:self.playerView.superview];
}

- (void)alivcLongVideoDownLoadProgressErrorModel:(AVPErrorModel *)errorModel source:(AlivcLongVideoDownloadSource *)source {
    [AVPTool hideLoadingHudForView:self.playerView.superview];
    
    [MBProgressHUD showMessage:errorModel.message inView:self.playerView.superview];
     
    if (errorModel.code == DOWNLOADER_ERROR_NOT_SUPPORT_FORMAT && self.currentDownloadSource) {
        [self.downLoadManager clearMedia:self.currentDownloadSource];
    }else{
        [AVPTool loadingHudToView:self.playerView.superview];
        [AlivcPlayVideoRequestManager getWithParameters:@{@"videoId":self.currentDownloadSource.longVideoModel.videoId} urlType:AVPUrlTypePlayerVideoPlayAuth success:^(AVPDemoResponseModel *responseObject) {
            [AVPTool hideLoadingHudForView:self.playerView.superview];
            AVPVidAuthSource *vidAuthSource = [[AVPVidAuthSource alloc]initWithVid:responseObject.data.videoMeta.videoId playAuth:responseObject.data.playAuth region:@"cn-shanghai"];
            self.currentDownloadSource.authSource = vidAuthSource;
            [self.downLoadManager prepareDownloadSource:self.currentDownloadSource];
        } failure:^(NSString *errorMsg) {
            [AVPTool hideLoadingHudForView:self.playerView.superview];
            [AVPTool hudWithText:errorMsg view:self.playerView.superview];
        }];
    }
}

/*
 功能：清除指定下载的视频资源
 参数：downloadSource 要删除的视频资源
 */
- (void)deleteFile:(NSString *)path {
    for (AlivcLongVideoDownloadSource *mo in self.downLoadManager.doneSources) {
        if ([mo.downloadedFilePath isEqualToString:path]) {
            [self.downLoadManager clearMedia:mo];
        }
    }
}

/// 获取已经下载完成的视频文件地址列表
- (NSArray <NSString *>*)getDoneDownLoadSource {
    NSMutableArray <NSString *>*arr = [NSMutableArray array];
    for (AlivcLongVideoDownloadSource *mo in self.downLoadManager.doneSources) {
        [arr addObject:mo.downloadedFilePath];
    }
    return arr;
}

/// 获取正在下载的资源地址
- (NSString *)getDownloadingSource {
    return self.currentDownloadSource.downloadedFilePath;
}

/*
 功能：清除所有准备的的视频资源
 */
- (void)clearAllSources {
    [self.downLoadManager clearAllSources];
}

/// 停止下载
- (void)stopDownload {
    [self.downLoadManager stopDownloadSource:self.currentDownloadSource];
}

/// 继续下载
- (void)continueDownload {
    [self.downLoadManager startDownloadSource:self.currentDownloadSource];
}

#pragma mark ---------------------------- 试看接口 -----------------------------
- (void)setTrailerTime:(CGFloat)time {
    if (!self.playerView.currentModel) {
        AlivcVideoPlayListModel *mo = [[AlivcVideoPlayListModel alloc] init];
        mo.videoId = self.playerView.authSource.vid;
        self.playerView.currentModel = mo;
    }
    self.playerView.currentModel.authorityType = AlivcPlayVideoFreeTrialType;
    self.playerView.currentModel.previewTime = time;
}

- (void)alivcLongVideoPreviewViewReplay {
    [self.playerView seekTo:0];
    [self.playerView start];
}
- (void)alivcLongVideoPreviewViewGoVipController {
    
}
- (void)alivcLongVideoPreviewViewGoBack {
    
}

#pragma mark ------------------------------ 文件加密 ----------------------------
/// 加密文件
- (void)encry:(NSString *)encryptPath {
    if (!encryptPath || encryptPath.length == 0) {
        return;
    }
    [AliPrivateService initKey:encryptPath];
}

#pragma mark ---------------------------- 获取playauth -------------------------
- (void)getVideoPlayAuthInfoWithVideoId:(NSString *)vid block:(void(^)(NSString *playAuth))block {
    [AVPTool loadingHudToView:self.playerView.superview];
    [AlivcPlayVideoRequestManager getWithParameters:@{@"videoId":vid} urlType:AVPUrlTypePlayerVideoPlayAuth success:^(AVPDemoResponseModel *responseObject) {
        [AVPTool hideLoadingHudForView:self.playerView.superview];
        AVPVidAuthSource *source = [[AVPVidAuthSource alloc]initWithVid:responseObject.data.videoMeta.videoId playAuth:responseObject.data.playAuth region:@"cn-shanghai"];
        if (block) {
            block(source.playAuth);
        }
    } failure:^(NSString *errorMsg) {
        [AVPTool hideLoadingHudForView:self.playerView.superview];
        [AVPTool hudWithText:errorMsg view:self.playerView.superview];
    }];
}

@end
