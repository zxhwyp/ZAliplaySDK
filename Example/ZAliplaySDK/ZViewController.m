//
//  ZViewController.m
//  ZAliplaySDK
//
//  Created by 周小华 on 07/30/2020.
//  Copyright (c) 2020 周小华. All rights reserved.
//

#import "ZViewController.h"
#import "TestAlipayVC.h"

@interface ZViewController ()

@end

@implementation ZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TestAlipayVC *vc = [TestAlipayVC new];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
