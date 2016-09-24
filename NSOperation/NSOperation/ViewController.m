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

@implementation ViewController {
    NSOperationQueue *_queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self NSOperation];
//    [self demo2];
    [self setupOP];
}

- (void)setupOP {
    _queue = [[NSOperationQueue alloc]init];
//    [self demo3];
//    [self demo4];
//    [self demo5];
//    [self demo6];
//    [self demo7];
    [self demo8];
}

//常用线程间通讯
- (void)demo8 {
    [_queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"耗时操作 %@", [NSThread currentThread]);
        NSString *json = @"This is Json";
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSLog(@"mainQueue %@, %@", [NSThread currentThread], json);
        }];
    }];
    
}


#pragma mark - 执行块
//设置执行块
- (void)demo7 {
    NSBlockOperation *blockOP = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOP %@", [NSThread currentThread]);
    }];
    [blockOP addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"inExecutionBlock %@", [NSThread currentThread]);
    }];
    [_queue addOperation:blockOP];
    NSLog(@"outExecutionBlock%@", blockOP.executionBlocks);
}


#pragma mark - 优先级设置
- (void)demo6 {
    NSBlockOperation *blockOP1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 10; i++) {
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"Interactive %@", [NSThread currentThread]);
        }
    }];
    blockOP1.qualityOfService = NSQualityOfServiceUserInteractive;
    [_queue addOperation:blockOP1];
    
    NSBlockOperation *blockOP2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"BackGround %@", [NSThread currentThread]);
        }
    }];
    blockOP2.qualityOfService = NSQualityOfServiceBackground;
    [_queue addOperation:blockOP2];
}


#pragma mark - NSBlockOperation
- (void)demo4 {
    //新建操作
    NSBlockOperation *blockOP = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"%@", [NSThread currentThread]);
    }];
    // 设置完成 block -> 会另外新建一条线程执行完成回调
    [blockOP setCompletionBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"完成回调 %@", [NSThread currentThread]);
    }];
    //添加操作到队列
    [_queue addOperation:blockOP];
}

//blockOperation的简单写法,直接添加 block 更加简单，不过会少了一些控制，例如：完成监听、优先级等
- (void)demo5 {
    [_queue addOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
}


#pragma mark - NSOperation
/*
 执行效果：会开启多条线程，而且不是顺序执行。与 GCD 中 并发队列&异步执行 效果一样！
 一般在使用 NSOpeartion 时，会建立一个全局队列，统一调度所有的异步操作
 
 结论，在 NSOperation 中：
 
 操作 -> 异步执行的任务
 队列 -> 并发队列
 */
//添加多个操作
- (void)demo3 {
    for (NSInteger i = 0; i < 10; i++) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(demo3) object:@"__FUNCTION__"];
        NSLog(@"%@", [NSThread currentThread]);
        [_queue addOperation:op];
    }
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

//默认情况下，调用 start 方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作
//只有将 NSOperation 放到一个 NSOperationQueue 中，才会异步执行操作
- (void)demo2 {
    //创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(demo2) object:@"__FUNCTION__"];
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    NSLog(@"%@", [NSThread currentThread]);
    // 一旦添加，指定的操作会保留在队列中，直至执行完毕
    // 将操作添加到队列后，系统会从队列中取出操作，并新建线程，执行操作指定方法
    [queue addOperation:op];
}



@end
