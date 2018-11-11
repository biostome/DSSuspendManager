//
//  DSSuspendBtn.h
//  DSBet
//
//  Created by iOS开发 on 2018/3/6.
//  Copyright © 2018年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSSuspendManageDelegate <NSObject>
@optional
/// 自动选择线路
- (void)autoChooseLineFinishWithURL:(NSURL*)URL;
/// 手动选择线路
- (void)manuallyChooseLineWithFinishWithURL:(NSURL*)URL;
/// 关闭、开启悬浮窗的代理方法
- (void)on_offFloatDidSwitchFinishWithStatus:(BOOL)status;
@end

@interface DSSuspendManager : NSObject
+ (instancetype)share;
/// 关闭悬浮窗
- (void)dismissFloatButton;
/// 显示悬浮窗
- (void)showFloatButtonWithURLs:(NSArray<NSString*>*)URLs;
/// 选择线路后是否自动关闭，默认为YES
@property(nonatomic, assign) BOOL chooseAfterDismiss;
/// 悬浮窗的开启状态 默认为NO
@property(nonatomic, assign) BOOL on_offFloatSwitchStatus;
/// 代理
@property(nonatomic, assign) id<DSSuspendManageDelegate> delegate;
@end
