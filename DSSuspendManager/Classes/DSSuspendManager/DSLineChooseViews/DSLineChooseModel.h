//
//  DSLineChooseModel.h
//  DSSuspendManager
//
//  Created by Chian on 2018/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
