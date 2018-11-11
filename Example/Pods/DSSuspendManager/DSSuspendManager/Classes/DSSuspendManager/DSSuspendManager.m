//
//  DSSuspendBtn.m
//  DSBet
//
//  Created by iOS开发 on 2018/3/6.
//  Copyright © 2018年 Bill. All rights reserved.
//
#define kSuspendBtnWidth 115/2

#import "DSSuspendManager.h"
#import "DSLineChooseViews.h"
#import "MNFloatBtn.h"
#import <UIKit/UIKit.h>

@interface DSSuspendManager ()<DSLineChooseViewsDelegate>
@property (nonatomic, strong) DSLineChooseViews * lineChooseView;
@end
static NSString * ChooseLineViewOnSwitchKey = @"ChooseLineViewOnSwitchKey";
@implementation DSSuspendManager{
    NSArray<NSString*>* _URLs;
}

- (DSLineChooseViews *)lineChooseView{
    if (!_lineChooseView) {
        NSBundle * currentBundle = [NSBundle bundleForClass:self.class];
        _lineChooseView  = [currentBundle loadNibNamed:NSStringFromClass(DSLineChooseViews.class) owner:nil options:nil].lastObject;
        _lineChooseView.delegate = self;
    }
    return _lineChooseView;
}

+ (instancetype)share{
    static DSSuspendManager * _suspendBtn;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _suspendBtn = [[DSSuspendManager alloc] init];
    });
    return _suspendBtn;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setVersionBtn];
        [self setChooseAfterDismiss:YES];
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:ChooseLineViewOnSwitchKey];
    }
    return self;
}

-(void)showFloatButtonWithURLs:(NSArray<NSString *> *)URLs{
    _URLs = URLs;
    [MNFloatBtn show];
}

- (void)dismissFloatButton{
    [MNFloatBtn hidden];
}

- (void)setVersionBtn{
    __weak typeof(self) weakself = self;
    _floatBtn = [MNFloatBtn getFloatBtn];
    _floatBtn.btnClick = ^(UIButton *sender) {
        [weakself.lineChooseView show];
    };
}

- (void)setOn_offFloatSwitchStatus:(BOOL)onFloatButtonSwitchStatus{
    BOOL isOn = [NSUserDefaults.standardUserDefaults boolForKey:ChooseLineViewOnSwitchKey];
    [self.lineChooseView setDefaultOn_OffSwitchStatus:isOn];
}

- (BOOL)on_offFloatSwitchStatus{
    BOOL isOn = [NSUserDefaults.standardUserDefaults boolForKey:ChooseLineViewOnSwitchKey];
    return isOn;
}

// MARK: - DSLineChooseViewsDelegate
- (NSArray<NSString *> *)URLsDSLineChooseViews{
    return _URLs;
}

- (void)floatBtnWithClose:(BOOL)close DSLineChooseViews:(DSLineChooseViews *)view{
    if (close) {
        [MNFloatBtn hidden];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:ChooseLineViewOnSwitchKey];
    }else{
        [MNFloatBtn show];
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:ChooseLineViewOnSwitchKey];
    }
    if ([self.delegate respondsToSelector:@selector(on_offFloatDidSwitchFinishWithStatus:)]) {
        [self.delegate on_offFloatDidSwitchFinishWithStatus:close];
    }
}

- (void)autoChooseWithURL:(NSURL *)URL DSLineChooseViews:(DSLineChooseViews *)view{
    NSLog(@"auto:%@",URL.absoluteString);
    if ([self.delegate respondsToSelector:@selector(autoChooseLineFinishWithURL:)]) {
        [self.delegate autoChooseLineFinishWithURL:URL];
    }
}

- (void)manuallyChooseWithURL:(NSURL *)URL DSLineChooseViews:(DSLineChooseViews *)view{
    NSLog(@"manually:%@",URL.absoluteString);
    if ([self.delegate respondsToSelector:@selector(manuallyChooseLineWithFinishWithURL:)]) {
        [self.delegate manuallyChooseLineWithFinishWithURL:URL];
    }
    if (self.chooseAfterDismiss) {
        [view dismiss];
    }
}
@end
