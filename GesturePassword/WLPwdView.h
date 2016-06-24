//
//  WLPwdView.h
//  GesturePassword
//
//  Created by wanglei on 16/6/17.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WLPwdViewDelegate <NSObject>

- (void) checkPasswordSuccess:(NSString *) pwd;

@end

@interface WLPwdView : UIView

@property (nonatomic,assign) id<WLPwdViewDelegate> delegate;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *selectedImae;

- (instancetype) initWithFrame:(CGRect) frame;

@end
