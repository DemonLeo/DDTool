//
//  UIImage+DDQRCodeEX.h
//
//  Created by mac on 2020/5/8.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DDQRCodeEX)
//普通的二维码
+(UIImage *)ImageOfQRFromURL:(NSString *)urlStr codeSize:(CGFloat)codeSize;

//带logo 的二维码
+(UIImage *)ImageOfQRFromURL:(NSString *)urlStr codeSize:(CGFloat)codeSize logoName:(NSString *)logoName  radius: (CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
