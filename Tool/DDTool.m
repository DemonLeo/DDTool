//
//  DDTool.m
//
//  Created by mac on 2020/4/24.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import "DDTool.h"

#import "DDToolHeader.h"
#import <objc/runtime.h>

@implementation DDTool
#pragma mark - copy

/**
 复制所有值
 
 @param copiedObject 被复制对象
 @param copyObject 复制到的对象
 */
+(void)copyAllExistPropertysWithCopiedObject:(id)copiedObject copyObject:(id)copyObject{
    
    NSArray<NSString *> *existPropertys = [DDTool getExistPropertyWithInstance:copyObject];
    
    NSArray<NSString *> *selfExistPropertys = [DDTool getExistPropertyWithInstance:copiedObject];
    
    if ([copiedObject isKindOfClass:[NSDictionary class]]) {
        
        selfExistPropertys = [copiedObject allKeys];
        
    }
    
    [existPropertys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            
            if ([selfExistPropertys containsObject:obj]) {
                
                id value = [copiedObject valueForKey:obj];
                
                id copyValue = [copyObject valueForKey:obj];
                
                if([copyValue isKindOfClass:[NSNumber class]]){
                    
                    [copyObject setValue:value forKeyPath:obj];
                    
                }else if([copyValue isKindOfClass:[NSString class]]){
                    
                    NSString *string = [[NSString stringWithFormat:@"%@",value] copy];
                    
                    if (!IsNilOrNullOrZone(string)) {
                        
                        [copyObject setValue:string forKeyPath:obj];
                        
                    }
                    
                }else{
                    
                    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
                        
                        NSString *string = [[NSString stringWithFormat:@"%@",value] copy];
                        
                        if (!IsNilOrNullOrZone(string)) {
                            
                            [copyObject setValue:string forKeyPath:obj];
                            
                        }
                        
                    }else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]){
                        
                        [copyObject setValue:[value mutableCopy] forKey:obj];
                        
                    }else{
                        
                        [copyObject setValue:[value copy] forKey:obj];
                        
                    }
                    
                }
                
            }
            
        }
        
    }];
    
}

#pragma mark - archiver
+(void)archiverWithModel:(id)model key:(NSString *)key{
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    //创建归档辅助类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:model forKey:key];
    //结束编码
    [archiver finishEncoding];
    //写入到沙盒
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:key];
    
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}

+(id)unarchiverWithkey:(NSString *)key{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:key];
    //解档
    NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
    //解档辅助类
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
    //解码并解档出model
    id model = [unarchiver decodeObjectForKey:key];
    //关闭解档
    [unarchiver finishDecoding];
    
    return model;
}

#pragma mark - class processing
/**
 根据类名返回类
 
 @param name 类名
 @return 类
 */
+(id)getClassWithName:(NSString *)name{
    
    //判断是否存在这个类
    Class pkClass=NSClassFromString(name);
    
    if (!pkClass) {
        return nil;
    }
    
    const char *className = [name cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    
    
    return instance;
}

/**
 检测对象是否存在该属性
 
 @param instance 对象
 @param verifyPropertyName 属性名
 @return 结果
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        @autoreleasepool {
            objc_property_t property =properties[i];
            //  属性名转成字符串
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            // 判断该属性是否存在
            if ([propertyName isEqualToString:verifyPropertyName]) {
                free(properties);
                return YES;
            }
        }
    }
    free(properties);
    
    return NO;
}

+(NSArray<NSString *> *)getExistPropertyWithInstance:(id)instance{
    
    NSMutableArray *titleArray = [NSMutableArray array];
    
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        @autoreleasepool {
            objc_property_t property =properties[i];
            //  属性名转成字符串
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            // 加入数组
            [titleArray addObject:propertyName];
        }
        
    }
    
    free(properties);
    
    return titleArray;
}

/**
 根据类名创建类,带参数
 
 @param name 类名
 @param verifyPropertyDic 类属性
 @return 类
 */
+(id)getClassWithName:(NSString *)name verifyPropertyDic:(NSDictionary *)verifyPropertyDic{
    id instance = [DDTool getClassWithName:name];
    
    [verifyPropertyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @autoreleasepool {
            if ([DDTool checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
                [instance setValue:obj forKey:key];
            }
        }
    }];
    
    return instance;
}

#pragma mark - viewController

/// 获取当前VC
+ (UIViewController *)getCurrentVC{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
    
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    
    UIViewController *currentVC;

    if ([rootVC presentedViewController]) {

        // 视图是被presented出来的

        rootVC = [rootVC presentedViewController];

    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        // 根视图为UITabBarController

        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];

    } else if ([rootVC isKindOfClass:[UINavigationController class]]){

        // 根视图为UINavigationController

        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];

    } else {

        // 根视图为非导航类

        currentVC = rootVC;

    }

    return currentVC;
}

@end
