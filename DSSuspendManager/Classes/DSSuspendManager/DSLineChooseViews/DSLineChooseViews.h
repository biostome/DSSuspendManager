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

@class DSLineChooseModel;
@interface DSLineChooseCell : UITableViewCell
@property (nonatomic, strong)UILabel *label1;
@property (nonatomic, strong)UILabel *label2;
@property (nonatomic, strong)DSLineChooseModel *lineModel;
@end

typedef void(^PingActionBlock)(double timeMilliseconds);
@interface DSLineChooseModel : NSObject
@property (nonatomic, assign) NSUInteger idx;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) double timeMilliseconds;
@property (nonatomic, copy) PingActionBlock pingActionBlock;
- (void)startPing;
- (void)stopPing;
@end

NS_ASSUME_NONNULL_END
