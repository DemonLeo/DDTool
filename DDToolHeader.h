//
//  DDToolHeader.h
//
//  Created by Demon on 2021/2/6.
//

#ifndef DDToolHeader_h
#define DDToolHeader_h

//对象是否为空
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空 / "" / "(null)"
#define IsNilOrNullOrZone(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSString class]] && [(_ref) isEqualToString:@""]) || ([(_ref) isKindOfClass:[NSString class]] && [(_ref) isEqualToString:@"(null)"]))

//图片方法
#define UIImageMake(img) [UIImage imageNamed:img inBundle:nil compatibleWithTraitCollection:nil]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// View 圆角和加边框
#define ViewBorder(View, Width, Color)\
\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// 字体
#define FONT_SIZE(SIZE) [UIFont systemFontOfSize:SIZE]
#define BOLD_SIZE(SIZE) [UIFont boldSystemFontOfSize:SIZE]

// 窗口
#define DELEGATE_WINDOW UIApplication.sharedApplication.delegate.window
#define TOP_WINDOW [[[UIApplication sharedApplication] windows] lastObject]
#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height

#endif /* DDToolHeader_h */
