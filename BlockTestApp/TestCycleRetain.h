//
//  TestCycleRetain.h
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/24.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^blk)(void);

@interface TestCycleRetain : NSObject

@property (nonatomic,copy) blk myblock;

@end
