//
//  ViewController.m
//  semaphore
//
//  Created by 胡杨 on 2017/5/12.
//  Copyright © 2017年 net.fitcome.www. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 关于信号量的几个细节
    
    [self dispatchSignal];
}

- (void)dispatchSignal {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // global queue 全局队列是一个并行队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"begin task 1 %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"async task 1 %@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
        
        NSLog(@"semaphore signal task 1 %@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"run task 1 %@", [NSThread currentThread]);
            //            sleep(2);
            NSLog(@"complete task 1 %@", [NSThread currentThread]);
        });
        
    });
    
//    dispatch_time_t dispatchtime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC));
//    dispatch_time_t dispatchtime = DISPATCH_TIME_FOREVER;
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"wait task 1 %@", [NSThread currentThread]);
    
    
    //任务2
    dispatch_async(queue, ^{
        NSLog(@"run task 2");
        sleep(2);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"wait task 2");
    
    
    //任务3
    dispatch_async(queue, ^{
        NSLog(@"run task 3");
        sleep(2);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"wait task 3");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
