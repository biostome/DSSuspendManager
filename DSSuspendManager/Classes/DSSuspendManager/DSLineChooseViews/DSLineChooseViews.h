//
//  DSLineChooseViews.h
//  SuspendBtn
//
//  Created by Chian on 2018/11/10.
//  Copyright © 2018 com.deshen.suspend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDPingServices.h"

NS_ASSUME_NONNULL_BEGIN
@class DSLineChooseViews;
@protocol DSLineChooseViewsDelegate <NSObject>
@required
- (NSArray<NSString*>*)URLsDSLineChooseViews;
@optional
- (void)manuallyChooseWithURL:(NSURL *)URL DSLineChooseViews:(DSLineChooseViews*)view;
- (void)autoChooseWithURL:(NSURL *)URL DSLineChooseViews:(DSLineChooseViews*)view;
- (void)floatBtnWithClose:(BOOL)close DSLineChooseViews:(DSLineChooseViews*)view;
@end

@interface DSLineChooseViews : UIView
- (void)show;
- (void)dismiss;
- (void)setDefaultOn_OffSwitchStatus:(BOOL)status;
@property (nonatomic, weak) id<DSLineChooseViewsDelegate> delegate;
@end





NS_ASSUME_NONNULL_END
