//
//  main.m
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/23.
//  Copyright © 2018年 cimain. All rights reserved.
//

//For checking memory management of block
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}



////For Clang rewrite
//#include <stdio.h>

//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//
//        typedef void (^blk_t)(void);
//        blk_t block = ^{
//            printf("Hello, World!\n");
//        };
//        block();
//    }
//}

