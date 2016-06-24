//
//  ViewController.m
//  GesturePassword
//
//  Created by wanglei on 16/6/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "WLPwdView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
    
    WLPwdView *pwdView=[[WLPwdView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 400)];
    pwdView.normalImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"space.png" ofType:nil]];
    pwdView.selectedImae=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected.png" ofType:nil]];
    pwdView.backgroundColor=[UIColor whiteColor];
    
    
    [self.view addSubview:pwdView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
