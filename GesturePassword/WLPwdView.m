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
}

@end


@implementation WLPwdView

- (instancetype) initWithFrame:(CGRect)frame{

    if(self==[super initWithFrame:frame]){
    
        //创建圆点添加到密码面板上
        [self createSpotOnView];
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
        [btnImg setImage:[UIImage imageNamed:@"space.png"] forState:UIControlStateNormal];
        [btnImg setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
        btnImg.userInteractionEnabled=NO;
        btnImg.tag=i+2017;
        
        [self addSubview:btnImg];
        
        if(allSpots==nil){
            allSpots=[[NSMutableArray alloc] init];
        }
        
        [allSpots addObject:btnImg];
    }
}


//触摸开始
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //获取当前触摸开始的坐标
    UITouch *touch=[[event allTouches] anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    [allSpots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btnImg=(UIButton *) obj;
        
        if(CGRectContainsPoint(btnImg.frame, point)){
            
            lastPoint=btnImg.center;
            
            btnImg.selected=YES;
            
            //将当前的btnImg 添加到被选择的点数组内
            if(selectedSpots==nil){
                selectedSpots=[NSMutableArray array];
            }
            
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
            
            btnImg.selected=YES;
            
            if(selectedSpots==nil){
                selectedSpots=[NSMutableArray array];
            }
            
            //判断当前的点是否被选择过
            NSInteger index=[selectedSpots indexOfObject:btnImg];
            if(index>=0 && index<selectedSpots.count){
                return ;
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
        
        if([rightPwd isEqualToString:pwd] && [_delegate respondsToSelector:@selector(checkPasswordSuccess:)]){
            
            [self.delegate checkPasswordSuccess:pwd];
        
        }else if([_delegate respondsToSelector:@selector(checkPasswordFail:)]){

            [self.delegate checkPasswordFail:pwd];
        }
    }
    
    //将原先的线条痕迹删除
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //清空原有数据
    [allSpots removeAllObjects];
    [selectedSpots removeAllObjects];
    lastPoint=currentPoint=CGPointZero;
    
    [self createSpotOnView];
}




@end
