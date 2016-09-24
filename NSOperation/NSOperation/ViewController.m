//
//  ViewController.m
//  NSOperation
//
//  Created by 刘宏立 on 16/9/24.
//  Copyright © 2016年 lhl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NSOperation];
}


- (void)NSOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(demo:) object:@"__FUNCTION__"];
    [op start];
}

- (void)demo:(id)obj {
    NSLog(@"%@ %@", [NSThread currentThread], obj);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
