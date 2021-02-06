//
//  UIViewController+DDPop.m
//
//  Created by ctmm_ios on 2019/12/16.
//  Copyright © 2019年 appledev. All rights reserved.
//

#import "UIViewController+DDPop.h"

@implementation UIViewController (DDPop)


-(NSMutableArray *)removerControllersWithName:(NSString *)controllerName{
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    __block NSInteger index = -1;
    
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            
            NSLog(@"%@",NSStringFromClass([obj class]));
            
            if ([obj isKindOfClass:[UIViewController class]] && [NSStringFromClass([obj class]) isEqualToString:controllerName]) {
                
                index = idx;
                
            }
            
        }
        
    }];
    
    if (index >= 0) {
        
        NSInteger idx = ++index;
        NSInteger loc = [viewControllers count] - idx;
        
        [viewControllers removeObjectsInRange:NSMakeRange(idx, loc)];
        
    }
    
    return viewControllers;
    
}

-(void)removerNavControllersWithName:(NSString *)controllerName{
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    __block NSInteger index = -1;
    
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            
            NSLog(@"%@",NSStringFromClass([obj class]));
            
            if ([obj isKindOfClass:[UIViewController class]] && [NSStringFromClass([obj class]) isEqualToString:controllerName]) {
                
                index = idx;
                
            }
            
        }
        
    }];
    
    if (index >= 0) {
        
        [viewControllers removeObjectsInRange:NSMakeRange(index, 1)];
        
    }
    
    [self.navigationController setViewControllers:viewControllers animated:NO];
    
}

-(BOOL)canPopControllersWithName:(NSString *)controllerName{
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    __block BOOL canPop = NO;
    
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            
            NSLog(@"%@",NSStringFromClass([obj class]));
            
            if ([obj isKindOfClass:[UIViewController class]] && [NSStringFromClass([obj class]) isEqualToString:controllerName]) {
                
                canPop = YES;
                
                *stop = YES;
                
            }
            
        }
        
    }];
    
    return canPop;
    
}

#pragma mark - popVC

/**
 回退到指定页面
 
 @param controllerName 页面名称
 */
-(void)popWithViewControllerName:(NSString *)controllerName{
    
    NSMutableArray *removerControllers = [self removerControllersWithName:controllerName];
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    if ([removerControllers isEqualToArray:viewControllers]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController setViewControllers:removerControllers animated:YES];
        
    }
    
}

/**
 回退到指定页面
 
 @param controllerName 页面名称
 @param pushVC 需要跳转的页面
 */
-(void)popWithViewControllerName:(NSString *)controllerName pushVC:(UIViewController *)pushVC{
    
    NSMutableArray *removerControllers = [self removerControllersWithName:controllerName];
    
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    if ([removerControllers isEqualToArray:viewControllers]) {
        
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }else{
        
        [removerControllers addObject:pushVC];
        
        [self.navigationController setViewControllers:removerControllers animated:YES];
        
    }
    
}

-(void)popRootAndPushVC:(UIViewController *)pushVC{
    
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController *VC = [array firstObject];
    
    NSMutableArray *removerControllers = [self removerControllersWithName:NSStringFromClass([VC class])];
    
    [removerControllers addObject:pushVC];
    
    [self.navigationController setViewControllers:removerControllers animated:YES];
    
}

@end
