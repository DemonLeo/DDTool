//
//  DDTool.h
//
//  Created by mac on 2020/4/24.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTool : NSObject

#pragma mark - copy

/**
 复制所有值

 @param copiedObject 被复制对象
 @param copyObject 复制到的对象
 */
+(void)copyAllExistPropertysWithCopiedObject:(id)copiedObject copyObject:(id)copyObject;

#pragma mark - archiver

/// 归档
+(void)archiverWithModel:(id)model key:(NSString *)key;

/// 解归档
+(id)unarchiverWithkey:(NSString *)key;

#pragma mark - class processing

/**
 根据类名返回类
 */
+(id)getClassWithName:(NSString *)name;

/**
 检测对象是否存在该属性
 
 @param instance 对象
 @param verifyPropertyName 属性名
 @return 结果
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;

/**
 获取类的全部属性名

 @param instance 对象
 @return 属性名
 */
+(NSArray<NSString *> *)getExistPropertyWithInstance:(id)instance;

/**
 根据类名创建类,带参数
 
 @param name 类名
 @param verifyPropertyDic 类属性
 @return 类
 */
+(id)getClassWithName:(NSString *)name verifyPropertyDic:(NSDictionary *)verifyPropertyDic;

#pragma mark - viewController

/// 获取当前VC
+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
