//
//  AliyunPlayerFinishView.m
//  AliyunVideoClient_Entrance
//
//  Created by 刘家伟 on 2020/7/26.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import "AliyunPlayerFinishView.h"
#import <AliyunUtil.h>
#import "AliyunPrivateDefine.h"

@implementation AliyunPlayerFinishView

- (UIButton *)rePlayButton{
    if (!_rePlayButton) {
        _rePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rePlayButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_error_btn" skin:AliyunVodPlayerViewSkinBlue] forState:UIControlStateNormal];
        [_rePlayButton setImage:[AliyunUtil imageWithNameInBundle:@"al_over_btn_refresh" skin:AliyunVodPlayerViewSkinBlue] forState:UIControlStateNormal];
        _rePlayButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        [_rePlayButton setTitle:@"重新播放" forState:UIControlStateNormal];
        _rePlayButton.titleLabel.font = [UIFont systemFontOfSize:[AliyunUtil nomalTextSize]];
        _rePlayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rePlayButton setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        _rePlayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
        [_rePlayButton addTarget:self action:@selector(onClick1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rePlayButton;
}

- (UIButton *)nextPlayButton{
    if (!_nextPlayButton) {
        _nextPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextPlayButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_error_btn" skin:AliyunVodPlayerViewSkinBlue] forState:UIControlStateNormal];
        [_nextPlayButton setImage:[AliyunUtil imageWithNameInBundle:@"al_over_btn_refresh" skin:AliyunVodPlayerViewSkinBlue] forState:UIControlStateNormal];
        [_nextPlayButton setTitle:@"播放下一个" forState:UIControlStateNormal];
        _nextPlayButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        _nextPlayButton.titleLabel.font = [UIFont systemFontOfSize:[AliyunUtil nomalTextSize]];
        _nextPlayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nextPlayButton setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        _nextPlayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
        [_nextPlayButton addTarget:self action:@selector(onClick2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextPlayButton;
}

#pragma mark - init
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.rePlayButton];
        self.rePlayButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.rePlayButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
        [self.rePlayButton.rightAnchor constraintEqualToAnchor:self.centerXAnchor constant:-10].active = true;
        [self.rePlayButton.widthAnchor constraintEqualToConstant:120].active = true;
        [self.rePlayButton.heightAnchor constraintEqualToConstant:30].active = true;
        
        [self addSubview:self.nextPlayButton];
        self.nextPlayButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.nextPlayButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
        [self.nextPlayButton.leftAnchor constraintEqualToAnchor:self.centerXAnchor constant:10].active = true;
        [self.nextPlayButton.widthAnchor constraintEqualToAnchor:self.rePlayButton.widthAnchor].active = true;
        [self.nextPlayButton.heightAnchor constraintEqualToAnchor:self.rePlayButton.heightAnchor].active = true;
        
    }
    return self;
}

- (void)onClick1:(UIButton *)sender {
    if (self.block) {
        self.block(@"rePlayButton");
    }
}

- (void)onClick2:(UIButton *)sender {
    if (self.block) {
        self.block(@"nextPlayButton");
    }
}

@end
