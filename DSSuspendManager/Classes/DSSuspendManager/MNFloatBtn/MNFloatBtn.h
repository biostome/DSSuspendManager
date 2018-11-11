//
//  MNAssistiveBtn.h
//  LevitationButtonDemo
//
//  Created by 梁宇航 on 2018/3/8.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MNAssistiveTouchType)
{
    MNAssistiveTypeNone = 0,   //自动识别贴边
    MNAssistiveTypeNearLeft,   //拖动停止之后，自动向左贴边
    MNAssistiveTypeNearRight,  //拖动停止之后，自动向右贴边
};

@interface MNFloatBtn : UIButton

typedef void (^floatBtnClick)(UIButton *sender);

//任何模式都显示floatBtn
+ (void)show;

//移除floatBtn在界面显示
+ (void)hidden;

//获取floatBtn单例对象
+ (instancetype)getFloatBtn;

//按钮点击事件
@property (nonatomic, copy)floatBtnClick btnClick;

@end
