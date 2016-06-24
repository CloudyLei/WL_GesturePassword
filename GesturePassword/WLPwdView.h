//
//  WLPwdView.h
//  GesturePassword
//
//  Created by wanglei on 16/6/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WLPwdViewDelegate <NSObject>

//密码验证正确后的代理方法
- (void) checkPasswordSuccess:(NSString *) pwd;

@end

@interface WLPwdView : UIView

@property (nonatomic,assign) id<WLPwdViewDelegate> delegate;

//构建初始化界面
- (instancetype) initWithFrame:(CGRect) frame;

//开放修改按钮状态图片的方法
- (void) changeBtnDefaultImageToCustom:(UIImage *) image forState:(UIControlState) state;

@end
