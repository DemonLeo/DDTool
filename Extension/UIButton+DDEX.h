//
//  UIButton+DDEX.h
//
//  Created by Demon on 2020/4/12.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDButtonEdgeInsetsStyle) {
    DDButtonEdgeInsetsStyleTop, // image在上，label在下
    DDButtonEdgeInsetsStyleLeft, // image在左，label在右
    DDButtonEdgeInsetsStyleBottom, // image在下，label在上
    DDButtonEdgeInsetsStyleRight // image在右，label在左
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (DDEX)

/**
 增加点击方法
 
 @param tagget self
 @param action way
 */
-(void)addActionBtntarget:(id)tagget action:(SEL)action;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(DDButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
