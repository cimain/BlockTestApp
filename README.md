# iOS中Block的用法，举例与解析（Block看我就足够了）

文章示例代码，[简书原文地址](https://www.jianshu.com/p/bcd494ba0e22)


# Usage

下载或clone工程，打开main.m文件，根据不同测试目的，分别打开或注释掉。


### 用法1 - 测试Block内存与复制机制

放开如下代码，注释掉其它代码

```
//For checking memory management of block
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```


打开ViewController.m

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testBlockForHeapOfARC];
}

-(void)testBlockForHeapOfARC{
    int val =10;
    typedef void (^blk_t)(void);
    blk_t block = ^{
        NSLog(@"blk0:%d",val);
    };
    block();
}
```
然后根据文章中的顺序，分别将其中`[self testBlockForHeapOfARC];`代码切换为：
```
[self testBlockForHeap0];
```
```
[self testBlockForHeap1];
```
```
[self testBlockForHeap2];
```
### 用法2 - 测试Block的clang编译及底层原理

打开如下代码，注释掉其它代码

```
//For Clang rewrite
#include <stdio.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {

        typedef void (^blk_t)(void);
        blk_t block = ^{
            printf("Hello, World!\n");
        };
        block();
    }
}
```
cd 到main.m的目录

执行

```
clang -rewrite-objc main.m
```

可以发现同目录下面生成了main.cpp文件。

