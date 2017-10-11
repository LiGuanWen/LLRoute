
//
//  FirstViewController.m
//  LLRoute
//
//  Created by Lilong on 2017/10/11.
//  Copyright © 2017年 第七代目. All rights reserved.
//

#import "FirstViewController.h"
#import "LLSpeedRoute.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pushAction:(id)sender {
    //    [LLSpeedRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
    [LLRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
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
