

# iOS中Block的用法，举例，解析与底层原理（Block看我really足够了）



本文Demo的[传送门](https://github.com/cimain/BlockTestApp/tree/master)

## 1. 前言
---

> **Block**：带有自动变量（局部变量）的匿名函数。它是C语言的扩充功能。之所以是拓展，是因为C语言不允许存在这样匿名函数。

#### 1.1 匿名函数

匿名函数是指不带函数名称函数。C语言中，函数是怎样的呢？类似这样：

```
int func(int count);
```
调用的时候：

```
int result = func(10);
```
func就是它的函数名。也可以通过指针调用函数，看起来没用到函数名：
```
int result = (*funcptr)(10);
```
实际，在赋值给函数指针时，必须通过函数的名称才能获得该函数的地址。完整的步骤应该是：
```
int (*funcptr)(int) = &func;
int result = (*funcptr)(10);
```

而通过Block，就能够使用匿名函数，即不带函数名称的函数。

#### 1.2 带有自动变量

关于“带有自动变量（局部变量）”的含义，这是因为Block拥有捕获外部变量的功能。在Block中访问一个外部的局部变量，Block会持用它的临时状态，自动捕获变量值，外部局部变量的变化不会影响它的的状态。

捕获外部变量，看一个经典block面试题：

```
int val = 10; 
void (^blk)(void) = ^{
    printf("val=%d\n",val);
}; 
val = 2; 
blk(); 
```
上面这段代码，输出值是：val = 10，而不是2。

 block 在实现时就会对它引用到的它所在方法中定义的栈变量进行一次只读拷贝，然后在 block 块内使用该只读拷贝；换句话说block截获自动变量的瞬时值；或者block捕获的是自动变量的副本。

由于block捕获了自动变量的瞬时值，所以在执行block语法后，即使改写block中使用的自动变量的值也不会影响block执行时自动变量的值。

所以，上面的面试题的结果是2不是10。

> 解决block不能修改自动变量的值，这一问题的另外一个办法是使用`__block`修饰符。

```
__block int val = 10;  
void (^blk)(void) = ^{printf("val=%d\n",val);};  
val = 2;  
blk(); 
```

上面的代码，跟第一个代码段相比只是多了一个`__block`修饰符。但是输出结果确是2。


## 2. Block语法大全
---
约定：用法中的符号含义列举如下：
- `return_type` 表示返回的对象/关键字等(可以是void，并省略)
- `blockName` 表示block的名称
- `var_type` 表示参数的类型(可以是void，并省略)
- `varName` 表示参数名称

#### 2.1 Block声明及定义语法，及其变形

###### (1) 标准声明与定义
```
return_type (^blockName)(var_type) = ^return_type (var_type varName) {
    // ...
};
blockName(var);
```
###### (2) 当返回类型为void

```
void (^blockName)(var_type) = ^void (var_type varName) {
    // ...
};
blockName(var);
```
可省略写成
```
void (^blockName)(var_type) = ^(var_type varName) {
    // ...
};
blockName(var);
```
###### (3) 当参数类型为void
```
return_type (^blockName)(void) = ^return_type (void) {
    // ...
};
blockName();
```
可省略写成
```
return_type (^blockName)(void) = ^return_type {
    // ...
};
blockName();
```
###### (4) 当返回类型和参数类型都为void
```
void (^blockName)(void) = ^void (void) {
    // ...
};
blockName();
```
可省略写成
```
void (^blockName)(void) = ^{
    // ...
};
blockName();
```

###### (5) 匿名Block

Block实现时，等号右边就是一个匿名Block，它没有blockName，称之为匿名Block：

```
^return_type (var_type varName)
{
    //...
};
```

#### 2.2 typedef简化Block的声明

利用`typedef`简化Block的声明：

- 声明
```
typedef return_type (^BlockTypeName)(var_type);
```
- 例子1：作属性
```
//声明
typedef void(^ClickBlock)(NSInteger index);
//block属性
@property (nonatomic, copy) ClickBlock imageClickBlock;
```
- 例子2：作方法参数
```
//声明
typedef void (^handleBlock)();
//block作参数
- (void)requestForRefuseOrAccept:(MessageBtnType)msgBtnType messageModel:(MessageModel *)msgModel handle:(handleBlock)handle{
  ...
```

#### 2.3 Block的常见用法

###### 2.3.1 局部位置声明一个Block型的变量
- 位置
```
return_type (^blockName)(var_type) = ^return_type (var_type varName) {
    // ...
};
blockName(var);
```
- 例子
```
void (^globalBlockInMemory)(int number) = ^(int number){
     printf("%d \n",number);
};
globalBlockInMemory(90);
```

###### 2.3.2 @interface位置声明一个Block型的属性
- 位置
```
@property(nonatomic, copy)return_type (^blockName) (var_type);
```
- 例子
```
//按钮点击Block
@property (nonatomic, copy) void (^btnClickedBlock)(UIButton *sender);
```

###### 2.3.3 在定义方法时，声明Block型的形参

- 用法
```
- (void)yourMethod:(return_type (^)(var_type))blockName;
```

- 例子

UIView+AddClickedEvent.h
```
- (void)addClickedBlock:(void(^)(id obj))clickedAction;
```

###### 2.3.4 在调用如上方法时，Block作实参
- 例子

UIView+AddClickedEvent.m
```
- (void)addClickedBlock:(void(^)(id obj))clickedAction{
    self.clickedAction = clickedAction;
    // :先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        // :添加单击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap{
    if (self.clickedAction) {
        self.clickedAction(self);
    }
}
```

#### 2.4 Block的少见用法

###### 2.4.1 Block的内联用法

这种形式并不常用，匿名Block声明后立即被调用：
```
^return_type (var_type varName)
{
    //...
}(var);
```

###### 2.4.2 Block的递归调用


Block内部调用自身，递归调用是很多算法基础，特别是在无法提前预知循环终止条件的情况下。注意：由于Block内部引用了自身，这里必须使用`__block`避免**循环引用**问题。

```
__block return_type (^blockName)(var_type) = [^return_type (var_type varName)
{
    if (returnCondition)
    {
        blockName = nil;
        return;
    }
    // ...
    // 【递归调用】
    blockName(varName);
} copy];

【初次调用】
blockName(varValue);
```
###### 2.4.3 Block作为返回值
方法的返回值是一个Block，可用于一些“工厂模式”的方法中：
- 用法：
```
- (return_type(^)(var_type))methodName
{
    return ^return_type(var_type param) {
        // ...
    };
}
```
- 例子：Masonry框架里面的🌰
```
- (MASConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        if ([attribute isKindOfClass:NSArray.class]) {
            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
            NSMutableArray *children = NSMutableArray.new;
            for (id attr in attribute) {
                MASViewConstraint *viewConstraint = [self copy];
                viewConstraint.secondViewAttribute = attr;
                [children addObject:viewConstraint];
            }
            MASCompositeConstraint *compositeConstraint = [[MASCompositeConstraint alloc] initWithChildren:children];
            compositeConstraint.delegate = self.delegate;
            [self.delegate constraint:self shouldBeReplacedWithConstraint:compositeConstraint];
            return compositeConstraint;
        } else {
            NSAssert(!self.hasLayoutRelation || self.layoutRelation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
            self.layoutRelation = relation;
            self.secondViewAttribute = attribute;
            return self;
        }
    };
}
```

## 3. Block应用场景

#### 3.1 响应事件

> 情景：UIViewContoller有个UITableView并是它的代理，通过UITableView加载CellView。现在需要监听CellView中的某个按钮（可以通过tag值区分），并作出响应。

如上面 2.3.2节在CellView.h中@interface位置声明一个Block型的属性，为了设置激活事件调用Block，接着我们在CellView.m中作如下设置：

```
// 激活事件
#pragma mark - 按钮点击事件
- (IBAction)btnClickedAction:(UIButton *)sender {
    if (self.btnClickedBlock) {
        self.btnClickedBlock(sender);
    }
}
```
随后，在ViewController.m的适当位置（`- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{...`代理方法）中通过setter方法设置CellView的Block属性。Block写着当按钮被点击后要执行的逻辑。

```
// 响应事件
cell.btnClickedBlock = ^(UIButton *sender) {
    //标记消息已读
    [weakSelf requestToReadedMessageWithTag:sender.tag];
    //刷新当前cell
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
};
```

> 其实，即使Block不传递任何参数，也可以传递事件的。但这种情况，无法区分事件的激活方（cell里面的哪一个按钮？）。即：
```
//按钮点击Block
@property (nonatomic, copy) void (^btnClickedBlock)(void);
```
```
// 激活事件
#pragma mark - 按钮点击事件
- (IBAction)btnClickedAction:(UIButton *)sender {
    if (self.btnClickedBlock) {
        self.btnClickedBlock();
    }
}
```
```
// 响应事件
cell.btnClickedBlock = ^{
    //标记消息已读
    [weakSelf requestToReadedMessageWithTag:nil];
    //刷新当前cell
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
};
```


#### 3.2 传递数据

上面的响应事件，其实也是传递数据，只是它传递的对象是UIButton。如下所示，SubTableView是VC的一个属性和子视图。

- 传递数值

SubTableView.h
```
@property (strong, nonatomic) void (^handleDidSelectedItem)(int indexPath);
```
SubTableView.m
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _handleDidSelectedItem ? _handleDidSelectedItem(indexPath) : NULL;
}
```
VC.m
```
[_subView setHandleDidSelectedItem:^(int indexPath) {
        [weakself handleLabelDidSearchTableSelectedItem:indexPath];
    }];
```
```
- (void)handleLabelDidSearchTableSelectedItem:(int )indexPath {
    if (indexPath==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.searchNullView.telLabel.text]]];
    }else if (indexPath==1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
```

- 传递对象

例如HYBNetworking网络框架中请求成功时传递接口返回数据对象的Block:
```
[HYBNetworking postWithUrl:kSearchProblem refreshCache:NO params:params success:^(id response) {
        
        typeof(weakSelf) strongSelf = weakSelf;
//        [KVNProgress dismiss];
        NSString *stringData = [response mj_JSONString];
        stringData = [DES3Util decrypt:stringData];
        NSLog(@"stirngData: %@", stringData);
       ...
}
```

#### 3.3 链式语法

> **链式编程思想**：核心思想为将block作为方法的返回值，且返回值的类型为调用者本身，并将该方法以setter的形式返回，这样就可以实现了连续调用，即为链式编程。

Masonry的一个典型的链式编程用法如下：

```
[self.containerView addSubview:self.bannerView];
[self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.containerView.mas_leading);
    make.top.equalTo(self.containerView.mas_top);
    make.trailing.equalTo(self.containerView.mas_trailing);
    make.height.equalTo(@(kViewWidth(131.0)));
}];
```
现在，简单使用链式编程思想实现一个简单计算器的功能：

###### 3.3.1 在CaculateMaker.h文件中声明一个方法add：
- CaculateMaker.h
```
//  CaculateMaker.h
//  ChainBlockTestApp

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CaculateMaker : NSObject

@property (nonatomic, assign) CGFloat result;

- (CaculateMaker *(^)(CGFloat num))add;

@end
```

###### 3.3.2 在CaculateMaker.m文件中实现add方法：

- CaculateMaker.m
```
//  CaculateMaker.m
//  ChainBlockTestApp


#import "CaculateMaker.h"

@implementation CaculateMaker

- (CaculateMaker *(^)(CGFloat num))add;{
    return ^CaculateMaker *(CGFloat num){
        _result += num;
        return self;
    };
}

@end
```


###### 3.3.3 在viewController里面导入CaculateMaker.h文件，然后调用add方法就完成了链式语法：

- ViewController.m

```
CaculateMaker *maker = [[CaculateMaker alloc] init];
maker.add(20).add(30);
```


## 4. Block使用注意

#### 4.1 截获自动变量与__block说明符

前面讲过block所在函数中的，捕获自动变量。但是不能修改它，不然就是“编译错误”。但是可以改变**全局变量**、**静态变量**、**全局静态变量**。其实这两个特点不难理解：

- 不能修改**自动变量**的值是因为：block捕获的是自动变量的const值，名字一样，不能修改

- 可以修改**静态变量**的值：静态变量属于类的，不是某一个变量。由于block内部不用调用self指针。所以block可以调用。

解决block不能修改自动变量的值，这一问题的另外一个办法是使用`__block`修饰符。

#### 4.2 截获对象

对于捕获ObjC对象，不同于基本类型；Block会引起对象的引用计数变化。

```
@interface MyClass : NSObject {  
    NSObject* _instanceObj;  
}  
@end  
  
@implementation MyClass  
  
NSObject* __globalObj = nil;  
  
- (id) init {  
    if (self = [super init]) {  
        _instanceObj = [[NSObject alloc] init];  
    }  
    return self;  
}  
  
- (void) test {  
    static NSObject* __staticObj = nil;  
    __globalObj = [[NSObject alloc] init];  
    __staticObj = [[NSObject alloc] init];  
  
    NSObject* localObj = [[NSObject alloc] init];  
    __block NSObject* blockObj = [[NSObject alloc] init];  
  
    typedef void (^MyBlock)(void) ;  
    MyBlock aBlock = ^{  
        NSLog(@"%@", __globalObj);  
        NSLog(@"%@", __staticObj);  
        NSLog(@"%@", _instanceObj);  
        NSLog(@"%@", localObj);  
        NSLog(@"%@", blockObj);  
    };  
    aBlock = [[aBlock copy] autorelease];  
    aBlock();  
  
    NSLog(@"%d", [__globalObj retainCount]);  
    NSLog(@"%d", [__staticObj retainCount]);  
    NSLog(@"%d", [_instanceObj retainCount]);  
    NSLog(@"%d", [localObj retainCount]);  
    NSLog(@"%d", [blockObj retainCount]);  
}  
@end  
  
int main(int argc, charchar *argv[]) {  
    @autoreleasepool {  
        MyClass* obj = [[[MyClass alloc] init] autorelease];  
        [obj test];  
        return 0;  
    }  
}  
```

执行结果为1 1 1 2 1。

`__globalObj`和`__staticObj`在内存中的位置是确定的，所以Block `copy`时不会retain对象。

`_instanceObj`在Block `copy`时也没有直接retain `_instanceObj`对象本身，但会retain self。所以在Block中可以直接读写`_instanceObj`变量。
`localObj`在Block `copy`时，系统自动`retain`对象，增加其引用计数。
`blockObj`在Block `copy`时也不会`retain`。

#### 4.3 Block引起的循环引用

一般来说我们总会在设置Block之后，在合适的时间回调Block，而不希望回调Block的时候Block已经被释放了，所以我们需要对Block进行copy，copy到堆中，以便后用。

Block可能会导致循环引用问题，因为block在拷贝到堆上的时候，会retain其引用的外部变量，那么如果block中如果引用了他的宿主对象，那很有可能引起循环引用，如：

```
- (void) dealloc {
    NSLog(@"no cycle retain");
} - (id) init {
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

} - (void) doSomething {
    NSLog(@"do Something");
}

int main(int argc, char * argv[]) {@autoreleasepool {
        TestCycleRetain * obj = [[TestCycleRetain alloc] init];
        obj = nil;
        return 0;
    }
}
```

- MRC情况下，用__block可以消除循环引用。
- ARC情况下，必须用弱引用才可以解决循环引用问题，iOS 5之后可以直接使用__weak，之前则只能使用__unsafe_unretained了，__unsafe_unretained缺点是指针释放后自己不会置

在上述使用 block中，虽说使用`__weak`，但是此处会有一个隐患，你不知道 self 什么时候会被释放，为了保证在block内不会被释放，我们添加`__strong`。更多的时候需要配合`strongSelf`使用，如下：

```
__weak __typeof(self) weakSelf = self; 
self.testBlock =  ^{
       __strong __typeof(weakSelf) strongSelf = weakSelf;
       [strongSelf test]; 
});
```


#### 4.4 实用宏定义：避免Block引起循环引用

- 第一步

在工程的TestAPP-Prefix.pch的文件中直接（不推荐）或在其导入的头文件中间接写入以下宏定义：
```
//----------------------强弱引用----------------------------
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
```
- 第二步

在设置Block体的时候，像如下这样使用即可。
```
@weakify(self);
[footerView setClickFooterBlock:^{
        @strongify(self);
        [self handleClickFooterActionWithSectionTag:section];
}];
```

#### 4.5 所有的Block里面的self必须要weak一下？

很显然答案不都是，有些情况下是可以直接使用self的，比如调用系统的方法：

```
[UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%@", self);
    }];
```

因为这个block存在于静态方法中，虽然block对self强引用着，但是self却不持有这个静态方法，所以完全可以在block内部使用self。

另外，来看一个Masonry代码布局的例子，这里面的self会不会造成循环引用呢？

```
[self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.otherView.mas_centerY);
}];
```

并不是 block 就一定会造成循环引用，是不是循环引用要看是不是**相互持有强引用**。block 里用到了 self，那 block 会保持一个 self 的引用，但是 self 并没有直接或者间接持有 block，所以不会造成循环引用。可以看一下Masonry的源代码：

- View+MASAdditions.m
```
- (NSArray *)mas_makeConstraints:(void(^)(MASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASConstraintMaker *constraintMaker = [[MASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}
```
- MASConstraintMaker.m
```
- (id)initWithView:(MAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}
```


持有链是这样的，并没有形成引用循环:

> self ->self.headView  ···  MASConstraintMaker构造block->self

注意观察，这个作为方法参数的Block体并没有被任何方持有。因此，我们放心在Masonry中使用self.xxx 不会循环引用的。而且这个block里面用weakSelf还有可能会出问题，因为mas_qeual如果得到一个nil参数的话应该会导致程序崩溃。

因为UIView未强持有block，所以这个block只是个栈block，而且构不成循环引用的条件。栈block有个特性就是它执行完毕之后就出栈，出栈了就会被释放掉。看mas_makexxx的方法实现会发现这个block很快就被调用了，完事儿就出栈销毁，构不成循环引用，所以可以直接放心的使self。另外，这个与网络请求里面使用self道理是一样的。


## 5. Block与内存管理

根据Block在内存中的位置分为三种类型：

- NSGlobalBlock是位于全局区的block，它是设置在程序的数据区域（.data区）中。

- NSStackBlock是位于栈区，超出变量作用域，栈上的Block以及  __block变量都被销毁。

- NSMallocBlock是位于堆区，在变量作用域结束时不受影响。

注意：在 ARC 开启的情况下，将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock 类型的 block。

正如它们名字显示得一样，表明了block的三种存储方式：栈、全局、堆。获取block对象中的isa的值，可以得到上面其中一个，下面开始说明哪种block存储在栈、堆、全局。

#### 5.1 位于全局区：GlobalBlock

生成在全局区block有两种情况：

- 定义全局变量的地方有block语法时

```
void(^block)(void) = ^ { NSLog(@"Global Block");};
int main() {
 
}
```

- block语法的表达式中没有使用应截获的自动变量时

```
int(^block)(int count) = ^(int count) {
        return count;
    };
 block(2);
```

虽然，这个block在循环内，但是blk的地址总是不变的。说明这个block在全局段。注：针对没有捕获自动变量的block来说，虽然用clang的rewrite-objc转化后的代码中仍显示_NSConcretStackBlock，但是实际上不是这样的。

#### 5.2 位于栈内存：StackBlock

这种情况，在非ARC下是无法编译的，在ARC下可以编译。

- block语法的表达式中使用截获的自动变量时
```
NSInteger i = 10; 
block = ^{ 
     NSLog(@"%ld", i); 
};
block;
```

设置在栈上的block，如果其作用域结束，该block就被销毁。同样的，由于__block变量也配置在栈上，如果其作用域结束，则该__block变量也会被销毁。

另外，例如
```
typedef void (^block_t)() ;  

-(block_t)returnBlock{  
    __block int add=10;  
    return ^{
        printf("add=%d\n",++add);
    };  
}  
```


#### 5.3 位于堆内存：MallocBlock

堆中的block无法直接创建，其需要由_NSConcreteStackBlock类型的block**拷贝**而来(也就是说**block需要执行copy之后才能存放到堆**中)。由于block的拷贝最终都会调用_Block_copy_internal函数。

 ```
void(^block)(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
 
        __block NSInteger i = 10;
        block = [^{
            ++i;
        } copy];
        ++i; 
        block();
        NSLog(@"%ld", i);
    }
    return 0;
}
```

我们对这个生成在栈上的block执行了copy操作，Block和__block变量均从栈复制到堆上。上面的代码，有跟没有`copy`，在非ARC和ARC下一个是stack一个是Malloc。这是因为ARC下默认为Malloc（即使如此，ARC下还是有一些例外，下面会讲）。

block在ARC和非ARC下有巨大差别。多数情况下，ARC下会默认把**栈block被会直接拷贝生成到堆上**。那么，什么时候栈上的Block会复制到堆上呢？

- 调用Block的copy实例方法时
- Block作为函数返回值返回时
- 将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
- 将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时

> block在ARC和非ARC下的巨大差别

- 在 ARC 中，捕获外部了变量的 block 的类会是 __NSMallocBlock__ 或者 __NSStackBlock__，如果 **block 被赋值给了某个变量**，在这个过程中会执行 _Block_copy 将原有的 __NSStackBlock__ 变成 __NSMallocBlock__；但是如果 block 没有被赋值给某个变量，那它的类型就是 __NSStackBlock__；没有捕获外部变量的 block 的类会是 __NSGlobalBlock__ 即不在堆上，也不在栈上，它类似 C 语言函数一样会在代码段中。

- 在非 ARC 中，捕获了外部变量的 block 的类会是 __NSStackBlock__，放置在栈上，没有捕获外部变量的 block 时与 ARC 环境下情况相同。

例如
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

![image.png](https://upload-images.jianshu.io/upload_images/1283539-5f942173f054d5d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


即使如此，ARC下还是有一些例外：

> 例外
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testBlockForHeap0];
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
```

这段代码在最后一行blk()会异常，因为数组中的block是栈上的。因为val是栈上的。解决办法就是调用copy方法。这种场景，ARC也不会为你添加copy，因为ARC不确定，采取了保守的措施：不添加copy。所以ARC下也是会异常退出。

![image.png](https://upload-images.jianshu.io/upload_images/1283539-e1a089a85c7682b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 例外的改进1

调用block 的copy函数，将block拷贝到堆上:

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testBlockForHeap1];
}

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
```

打个断点可见，该Block的类型：

![image.png](https://upload-images.jianshu.io/upload_images/1283539-21f8bafefb78e3c3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



> 例外的改进2

例如下面代码中，在addBlockToArray方法中的block还是_NSConcreteStackBlock类型的，在testBlockForHeap2方法中就被复制到了堆中，成为_NSConcreteMallocBlock类型的block：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testBlockForHeap2];
}

- (void)addBlockToArray:(NSMutableArray *)array {

    int val =10;
    [array addObjectsFromArray:@[
         ^{NSLog(@"blk0:%d",val);},
         ^{NSLog(@"blk1:%d",val);}]];
}

- (void)testBlockForHeap2{

    NSMutableArray *array = [NSMutableArray array];
    [self addBlockToArray:array];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[array objectAtIndex:0]};
    block();
}
```
打个断点可见，其中Block的类型：

![](https://upload-images.jianshu.io/upload_images/1283539-50efe48f9846e250.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 5.4 Block的复制

- 在全局block调用copy什么也不做
- 在栈上调用copy那么复制到堆上
- 在堆上调用block 引用计数增加

```
-(void) stackOrHeap{  
    __block int val =10;  
    blkt1 s= ^{  
        return ++val;};  
    s();  
    blkt1 h = [s copy];  
    h();  
}  
```
不管block配置在何处，用copy方法复制都不会引起任何问题。在ARC环境下，如果不确定是否要copy这个block，那尽管copy即可。

最后的强调，在 ARC 开启的情况下，除非上面的例外，默认只会有 **NSConcreteGlobalBlock** 和 **NSConcreteMallocBlock** 类型的 block。

## 6. Block的底层研究方法

#### 6.1 研究工具：clang

为了研究编译器是如何实现 block 的，我们需要使用 clang。clang 提供一个命令，可以将 Objetive-C 的源码改写成 c 语言的，借此可以研究 block 具体的源码实现方式。

首先cd到代码文件目录
```
cd /Users/ChenMan/iOSTest/BlockTestApp
```
然后执行clang命令
```
clang -rewrite-objc main.m
```
其中，main.m的代码写好如下
```
#include <stdio.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        typedef void (^blk_t)(void);
        blk_t block = ^{
            printf("Hello, World!\n");
        };
        block();
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```


执行情况：

![](https://upload-images.jianshu.io/upload_images/1283539-4662761648a74e22.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

你会看到main.cpp

![](https://upload-images.jianshu.io/upload_images/1283539-e5dd67653e0b64ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 6.2 实现分析

这里只选取部分关键代码。

不难看出`int main(int argc, char * argv[]) {`就是主函数的实现。
```
int main(int argc, char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        typedef void (*blk_t)(void);
        blk_t block = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
        ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);

    }
}
```

其中，`__main_block_impl_0`是block的一个C++的实现(最后面的_0代表是main中的第几个block)，也就是说也是一个结构体。

###### (1) __main_block_impl_0

`__main_block_impl_0`定义如下：

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

###### (2) __block_impl

其中`__block_impl`的定义如下：
```
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};
```

其结构体成员如下：

- isa，指向所属类的指针，也就是block的类型
- flags，标志变量，在实现block的内部操作时会用到
- Reserved，保留变量
- FuncPtr，block执行时调用的函数指针

可以看出，它包含了isa指针（包含isa指针的皆为对象），也就是说block也是一个对象(runtime里面，对象和类都是用结构体表示)。

###### (3) __main_block_desc_0

`__main_block_desc_0`的定义如下：
```
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
```
其结构成员含义如下：

- reserved：保留字段
- Block_size：block大小(sizeof(struct __main_block_impl_0))

以上代码在定义`__main_block_desc_0`结构体时，同时创建了`__main_block_desc_0_DATA`，并给它赋值，以供在main函数中对`__main_block_impl_0`进行初始化。

###### (4) __main_block_desc_0

如上的`main`函数中，`__main_block_func_0`也是block的一个C++的实现
```
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {

            printf("Hello, World!\n");
        }
```

###### (5) 综合可知：

- `__main_block_impl_0`的isa指针指向了`_NSConcreteStackBlock`。
- 从main函数的main.cpp中看，` __main_block_impl_0`的FuncPtr指向了函数`__main_block_func_0`。
- `__main_block_impl_0`的Desc也指向了定义`__main_block_desc_0`时就创建的`__main_block_desc_0_DATA`，其中纪录了block结构体大小等信息。


以上就是根据编译转换的结果。当然，由于 clang 改写的具体实现方式和 LLVM 不太一样，有急切底层兴趣的读者可以进行更深入的研究。



