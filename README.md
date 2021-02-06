# DDTool 通用的便捷方法 

-复制 : 用在自定义类需要复制的时候 批量获取 并 赋值
举例 :
-(instancetype)copyWithZone:(NSZone *)zone{
    
    DDClassroomMemberCharmModel *copy = [[[self class] allocWithZone:zone] init];
    
    [DDTool copyAllExistPropertysWithCopiedObject:self copyObject:copy];
    
    return copy;
    
}

-归档 解归档

-根据类名生成类 可包含属性赋值: 可用于后台动态传参控制前端展示页面 
举例:
id class = [DDTool getClassWithName:clickModel.value];

if (class) {

    [currentVC.navigationController pushViewController:class animated:YES];

}

-获取当前控制器 做了tabbar区分

# UIButton+DDEX

-设置button的titleLabel和imageView的布局样式，及间距

# UIImage+DDEX

-创建纯色/变色图片

-截屏

# UIImage+DDQRCodeEX

-二维码图片创建

# UIViewController+DDPop

-提供多钟修改控制器链的方法
