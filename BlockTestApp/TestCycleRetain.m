//
//  TestCycleRetain.m
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/24.
//  Copyright © 2018年 cimain. All rights reserved.
//

#define TestCycleRetainCase1 1

#import "TestCycleRetain.h"

@implementation TestCycleRetain

- (void) dealloc {
    NSLog(@"no cycle retain");
} 

- (id) init {
    self = [super init];
    if (self) {
        
#if TestCycleRetainCase1
        //会循环引用
        self.myblock = ^{
            [self doSomething];
        };
        
#elif TestCycleRetainCase2
        //会循环引用
        __block TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase3
        //不会循环引用
        __weak TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase4
        //不会循环引用
        __unsafe_unretained TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#endif NSLog(@"myblock is %@", self.myblock);
    }
    return self;
} 

- (void) doSomething {
    NSLog(@"do Something");
}

@end
