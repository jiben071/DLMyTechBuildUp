//
//  DLButtonTestViewController.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/28.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLButtonTestViewController.h"
#import "UIView+AppendDivideLine.h"

@interface DLButtonTestViewController ()

@end

@implementation DLButtonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self testAppendLine];
}

#pragma mark - 测试添加分割线功能
- (void)testAppendLine{
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    bigView.backgroundColor = [UIColor blackColor];
    [bigView appendDivideLine:AppendDivideLineTypeBottom lineColor:[UIColor lightTextColor]];
    [self.view addSubview:bigView];
}
@end
