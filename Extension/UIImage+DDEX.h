//
//  UIImage+DDEX.h
//
//  Created by mac on 2020/4/9.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
    GradientTypeUpleftToLowrightOffset56 = 4,//左上到右下，偏移56度
    GradientTypeLowerleftToUpperrightOffset72 = 5,//左下到右上，偏移72度
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DDEX)

/// 创建纯色图片
/// @param color 颜色
/// @param size 大小
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size;

/**  设置图片的渐变色(颜色->图片)

 @param colors 渐变颜色数组
 @param gradientType 渐变样式
 @param imgSize 图片大小
 @return 颜色->图片
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

//对View进行截屏
+(void)CutScreenWithView:(UIView *)view successBlock:( void(^)(UIImage * image,NSData * imagedata))block;

@end

NS_ASSUME_NONNULL_END





