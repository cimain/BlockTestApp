//
//  ViewController.m
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/23.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "TestCycleRetain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testTestCycleRetain];
}

#pragma mark - testBlockForHeapOfARC
-(void)testBlockForHeapOfARC{
    int val =10;
    typedef void (^blk_t)(void);
    blk_t block = ^{
        NSLog(@"blk0:%d",val);
    };
    block();
}

#pragma mark - testBlockForHeap0 - crash
-(NSArray *)getBlockArray0{
    int val =10;
    return [NSArray arrayWithObjects:
            ^{NSLog(@"blk0:%d",val);},
            ^{NSLog(@"blk1:%d",val);},nil];
}


-(void)testBlockForHeap0{
    
    NSArray *tempArr = [self getBlockArray0];
    NSMutableArray *obj = [tempArr mutableCopy];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[obj objectAtIndex:0]};
    block();
}


#pragma mark - testBlockForHeap1
-(void)testBlockForHeap1{
    
    NSArray *tempArr = [self getBlockArray1];
    NSMutableArray *obj = [tempArr mutableCopy];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[obj objectAtIndex:0]};
    block();
}

-(NSArray *)getBlockArray1{
    int val =10;
    return [NSArray arrayWithObjects:
            [^{NSLog(@"blk0:%d",val);} copy],
            [^{NSLog(@"blk1:%d",val);} copy],nil];
}

#pragma mark - testBlockForHeap2
- (void)testBlockForHeap2{
    
    NSMutableArray *array = [NSMutableArray array];
    [self addBlockToArray:array];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[array objectAtIndex:0]};
    block();
}

- (void)addBlockToArray:(NSMutableArray *)array {

    int val =10;
    [array addObjectsFromArray:@[
         ^{NSLog(@"blk0:%d",val);},
         ^{NSLog(@"blk1:%d",val);}]];
}

#pragma mark - testTestCycleRetain
- (void)testTestCycleRetain{
    TestCycleRetain * obj = [[TestCycleRetain alloc] init];
    obj.myblock();
    obj = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
