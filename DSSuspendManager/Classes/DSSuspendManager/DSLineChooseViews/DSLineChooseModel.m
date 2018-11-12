//
//  DSLineChooseModel.m
//  DSSuspendManager
//
//  Created by Chian on 2018/11/12.
//

#import "DSLineChooseModel.h"
#import "STDPingServices.h"

@interface DSLineChooseModel ()
@property (nonatomic, strong, nullable) STDPingServices *pingServices;
@end

@implementation DSLineChooseModel


- (void)startPing{
    __weak typeof(self) weakself = self;
    if (self.pingServices==nil) {
        self.pingServices = [STDPingServices startPingAddress:weakself.url.absoluteString callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
            if (pingItem.status != STDPingStatusFinished) {
                weakself.timeMilliseconds = pingItem.timeMilliseconds;
                if (weakself.pingActionBlock) {
                    weakself.pingActionBlock(pingItem.timeMilliseconds);
                }
            } else {
                weakself.pingServices = nil;
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.pingServices cancel];
        });
    }
}

- (void)stopPing{
    [self.pingServices cancel];
}
@end
