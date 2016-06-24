//
//  WLPwdView.m
//  GesturePassword
//
//  Created by wanglei on 16/6/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "WLPwdView.h"

#define HorSpace self.frame.size.width*0.1
#define margin self.frame.size.width*0.1
#define SpotDiameter self.frame.size.width*0.2
#define VerSpace (self.frame.size.height-SpotDiameter*3-margin*2)*0.5

@interface WLPwdView (){
    NSMutableArray *allSpots;
    NSMutableArray *selectedSpots;
    CGPoint lastPoint;
    CGPoint currentPoint;
    NSString *rightPwd;
    
    UILabel *tipLabel;
}

@end


@implementation WLPwdView

- (instancetype) initWithFrame:(CGRect)frame{

    if(self==[super initWithFrame:frame]){
        
        //初始化变量
        allSpots=[[NSMutableArray alloc] init];
        selectedSpots=[NSMutableArray array];
        
        //创建圆点添加到密码面板上
        [self createSpotOnView];
        
        //创建一个显示错误的 label
        tipLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-200)*0.5, 15, 200, 15)];
        [self addSubview:tipLabel];
    }
    return self;
}



//创建圆点添加到面板上
- (void) createSpotOnView{

    for(int i=0;i<9;i++){
    
        //计算当前圆点的位置
        int row=(int)i/3+1;
        int col=i%3+1;
        
        CGFloat spotX=HorSpace+(col-1)*(SpotDiameter+margin);
        CGFloat spotY=VerSpace+(row-1)*(SpotDiameter+margin);
        
        UIButton *btnImg=[[UIButton alloc] initWithFrame:CGRectMake(spotX, spotY, SpotDiameter, SpotDiameter)];
        [btnImg setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"space.png" ofType:nil]] forState:UIControlStateNormal];
        [btnImg setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected.png" ofType:nil]] forState:UIControlStateSelected];
        btnImg.userInteractionEnabled=NO;
        btnImg.tag=i+2017;
        
        [self addSubview:btnImg];
        [allSpots addObject:btnImg];
    }
}


//触摸开始
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    tipLabel.text=@"";
    
    //获取当前触摸开始的坐标
    UITouch *touch=[[event allTouches] anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    [allSpots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btnImg=(UIButton *) obj;
        
        if(CGRectContainsPoint(btnImg.frame, point)){
            
            lastPoint=btnImg.center;
            
            btnImg.selected=YES;
            
            //将当前的btnImg 添加到被选择的点数组内
            [selectedSpots addObject:btnImg];
        }
    }];
}



//触摸滑动
- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //获取当前触摸开始的坐标
    UITouch *touch=[[event allTouches] anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    
    [allSpots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btnImg=(UIButton *) obj;
        
        if(CGRectContainsPoint(btnImg.frame, point)){
        
            //判断当前的点是否被选择过
            if(btnImg.isSelected){
            
                //表示之前被选择过的点，直接结束密码勾画
                return;
                
            }else{
                
                btnImg.selected=YES;
            }
            
            //将当前的btnImg 添加到被选择的点数组内
            [selectedSpots addObject:btnImg];
            
            if(CGPointEqualToPoint(lastPoint, CGPointZero)){
                
                lastPoint=btnImg.center;
            }
            
            UIGraphicsBeginImageContext(self.frame.size);
            currentPoint=btnImg.center;
            
            UIBezierPath *bezierPath=[[UIBezierPath alloc] init];
            bezierPath.lineWidth=10;
            bezierPath.lineJoinStyle=kCGLineJoinBevel;
            [[UIColor colorWithRed:36/255.0 green:200/255.0 blue:260/255.0 alpha:0.5]  set];
            
            [bezierPath moveToPoint:lastPoint];
            [bezierPath addLineToPoint:currentPoint];
            [bezierPath stroke];
            lastPoint=currentPoint;
            
            UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageView *currView=[[UIImageView alloc] initWithImage:image];
            [self addSubview:currView];
        }
    }];
}



//滑动结束
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //创建一个可变字符串
    NSMutableString *pwd=[[NSMutableString alloc] init];
    
    [selectedSpots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn=(UIButton *) obj;
        [pwd appendString:[NSString stringWithFormat:@"%ld",(btn.tag-2016)]];
        
    }];
    
    NSLog(@"密码为：%@",pwd);
    
    if(rightPwd==nil || [@"" isEqualToString:rightPwd]){
    
        //这个地方也可以改造，将密码存入本地 或者 服务器
        rightPwd=pwd;
        
    }else{
        
        if([rightPwd isEqualToString:pwd]&& [_delegate respondsToSelector:@selector(checkPasswordSuccess:)]){
            
            [self.delegate checkPasswordSuccess:pwd];
        
        }else{
            //直接调用密码验证错误的处理方法
            tipLabel.text=@"密码错误";
            tipLabel.textColor=[UIColor redColor];
            tipLabel.textAlignment=NSTextAlignmentCenter;
            tipLabel.font=[UIFont systemFontOfSize:13.0];
        }
        
        rightPwd=@"";
    }
    
    //将原先的线条痕迹删除
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:UILabel.class]){
        
        }else{
        
            [obj removeFromSuperview];
        }
    }];
    
    //清空原有数据
    [allSpots removeAllObjects];
    [selectedSpots removeAllObjects];
    lastPoint=currentPoint=CGPointZero;
    
    [self createSpotOnView];
}


//设置按钮不同状态下的图片
- (void) changeBtnDefaultImageToCustom:(UIImage *)image forState:(UIControlState)state{

    for (UIButton *btn in allSpots) {
        
        [btn setImage:image forState:state];
        
    }
}

@end
