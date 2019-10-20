//
//  ViewController.m
//  TLBookTextView
//
//  Created by TL on 2019/9/19.
//  Copyright © 2019年 yuanqutech. All rights reserved.
//
#define TLDeviceWidth [UIScreen mainScreen].bounds.size.width
#define TLDeviceHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "TLBookTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TLBookTextViewConfiguration *configuration = [TLBookTextViewConfiguration new];
    TLBookTextView *textView = [[TLBookTextView alloc]initWithFrame:CGRectMake(15, 100, TLDeviceWidth -30, 370) configuration:configuration textBlock:^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
    }];
    [self.view addSubview:textView];
    
    
}


@end
