//
//  UIImage+DDQRCodeEX.m
//
//  Created by mac on 2020/5/8.
//  Copyright © 2020 tech-QiMing. All rights reserved.
//

#import "UIImage+DDQRCodeEX.h"

@implementation UIImage (DDQRCodeEX)
+(UIImage *)ImageOfQRFromURL:(NSString *)urlStr codeSize:(CGFloat)codeSize{
    
    if (urlStr ==nil || [urlStr isEqualToString:@""]) {
        return  nil;
    }
    
    //限制大小
//    codeSize = [self limitCodeSize:codeSize];
    
    CIImage *outputImage = [self QRFromUrl:urlStr];
    
    UIImage *finalImage =  [self createUIImageFormCIImage:outputImage withSize:codeSize];
    
    return finalImage;
}

+(UIImage *)ImageOfQRFromURL:(NSString *)urlStr codeSize:(CGFloat)codeSize logoName:(NSString *)logoName  radius: (CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    
    UIImage *orginQRImage =[self ImageOfQRFromURL:urlStr codeSize:codeSize];
    
    if (!logoName || [logoName isEqualToString:@""]) {
        NSLog(@"未输入logo图片名字");
        return  orginQRImage;
    }
    
    UIImage *finalImage ;
    
    //根据二维码图片设置生成水印图片rect
    CGRect waterImageRect = [self getWaterImageRectFromOutputQRImage:orginQRImage];
    
    UIImage *logoImage =[[UIImage imageNamed:logoName] scaleToSize:waterImageRect.size];
    //生成水印图片 rect 从00 开始
    UIImage *waterImage =[UIImage ClipImageRadiousWithImage:logoImage circleRect:CGRectMake(0, 0, waterImageRect.size.width, waterImageRect.size.height) radious:radius borderWith:borderWidth borderColor:borderColor];
    
    
    //添加水印图片
    
    finalImage =[UIImage WaterImageWithImage:orginQRImage waterImage:waterImage waterImageRect:waterImageRect];
    
    
    
    return finalImage;
    
}
+(CGRect)getWaterImageRectFromOutputQRImage:(UIImage *)orginQRImage{
    
    CGSize linkSize = CGSizeMake(orginQRImage.size.width / 4, orginQRImage.size.height / 4);
    
    CGFloat linkX = (orginQRImage.size.width -linkSize.width)/2;
    CGFloat linkY = (orginQRImage.size.height -linkSize.height)/2;
    
    
    return CGRectMake(linkX, linkY, linkSize.width, linkSize.height);
}
//限制大小
+(CGFloat)limitCodeSize:(CGFloat)codeSize
{
    codeSize = MAX(40, codeSize);
    codeSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, codeSize);
    return codeSize;
}
//根据url 创建CIImage
+(CIImage *)QRFromUrl:(NSString *)urlStr{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = urlStr;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    return outputImage;
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(UIImage*)scaleToSize:(CGSize)size
{
    size = CGSizeMake(size.width  , size.height );
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
//    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width , size.height )];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//添加水印图片
+ (UIImage *)WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect{
    
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
    
}
+ (UIImage *)ClipImageWithImage:(UIImage *)image circleRect:(CGRect)rect radious:(CGFloat) radious{
    //1、开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2、设置裁剪区域
    //    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radious];
    [path addClip];
    //3、绘制图片
    [image drawAtPoint:CGPointZero];
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5、关闭上下文
    UIGraphicsEndImageContext();
    //6、返回新图片
    return newImage;
}
//裁剪圆形
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleRect:(CGRect)rect{
    //1、开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    //2.设置剪裁区域
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    [path addClip];
    
    //绘制图片
    
    [image drawAtPoint:CGPointZero];
    
    
    //获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //返回新图片
    
    return  newImage;
    
    
    
}



//裁剪带边框的圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleRect:(CGRect)rect borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    //1、开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    //2、设置边框
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [borderColor setFill];
    [path fill];
    
    //3、设置裁剪区域
    UIBezierPath * clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + borderW , rect.origin.x + borderW , rect.size.width - borderW * 2, rect.size.height - borderW *2)];
    [clipPath addClip];
    
    //3、绘制图片
    [image drawAtPoint:CGPointZero];
    
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5、关闭上下文
    UIGraphicsEndImageContext();
    //6、返回新图片
    return newImage;
    
}

//裁剪带边框的图片 可设置圆角 边框颜色
+(UIImage *)ClipImageRadiousWithImage:(UIImage *)image circleRect:(CGRect)rect radious:(CGFloat)radious borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    
    
    //1、开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    //2、设置边框
    
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radious];
    
    [borderColor setFill];
    
    [path fill];
    
    
    //3、设置裁剪区域
    
    
    UIBezierPath * clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x + borderW , rect.origin.x + borderW , rect.size.width - borderW * 2, rect.size.height - borderW *2) cornerRadius:radious];
    
    [clipPath addClip];
    
    //3、绘制图片
    [image drawAtPoint:CGPointZero];
    
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5、关闭上下文
    UIGraphicsEndImageContext();
    //6、返回新图片
    return newImage;
    
    
    
}
//对View进行截屏
+(void)CutScreenWithView:(UIView *)view successBlock:( void(^)(UIImage * image,NSData * imagedata))block{
    //1、开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    //2.获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //3.截屏
    [view.layer renderInContext:ctx];
    
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.转化成为Data
    //compressionQuality:表示压缩比 0 - 1的取值范围
    NSData * data = UIImageJPEGRepresentation(newImage, 1);
    //6、关闭上下文
    UIGraphicsEndImageContext();
    
    //7.回调
    block(newImage,data);
    
}
@end
