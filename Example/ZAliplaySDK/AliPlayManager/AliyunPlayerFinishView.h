//
//  AliyunPlayerFinishView.h
//  AliyunVideoClient_Entrance
//
//  Created by 刘家伟 on 2020/7/26.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 播放完成视图
@interface AliyunPlayerFinishView : UIView

@property (nonatomic, strong) UIButton *rePlayButton; //界面中 点击按钮
@property (nonatomic, strong) UIButton *nextPlayButton; //界面中 点击按钮
@property (nonatomic, copy) void(^block)(NSString *senderName);

@end

NS_ASSUME_NONNULL_END
