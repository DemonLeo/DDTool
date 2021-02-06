//
//  UIViewController+DDPop.h
//
//  Created by ctmm_ios on 2019/12/16.
//  Copyright © 2019年 appledev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DDPop)

/**
 回退到指定页面
 
 @param controllerName 页面名称
 */
-(void)popWithViewControllerName:(NSString *)controllerName;

/**
 回退到指定页面
 
 @param controllerName 页面名称
 @param pushVC 需要跳转的页面
 */
-(void)popWithViewControllerName:(NSString *)controllerName pushVC:(UIViewController *)pushVC;

/**
 退回主页并跳转页面
 
 @param pushVC 需要跳转的页面
 */
-(void)popRootAndPushVC:(UIViewController *)pushVC;

/// 是否能返回对应的页面
/// @param controllerName 页面名字
-(BOOL)canPopControllersWithName:(NSString *)controllerName;

/// 在push列表中删除指定页面
/// @param controllerName 页面名
-(void)removerNavControllersWithName:(NSString *)controllerName;

@end

NS_ASSUME_NONNULL_END
