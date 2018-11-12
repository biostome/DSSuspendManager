//
//  DSLineChooseCell.m
//  DSSuspendManager
//
//  Created by Chian on 2018/11/12.
//

#import "DSLineChooseCell.h"
#import "DSLineChooseModel.h"

@implementation DSLineChooseCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSelf];
        
    }
    return self;
}

- (void)initSelf{
    self.label1 = [[UILabel alloc] init];
    self.label1.font = [UIFont systemFontOfSize:12];
    self.label1.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] init];
    self.label2.font = [UIFont systemFontOfSize:12];
    self.label2.textColor = [UIColor blueColor];
    self.label2.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.label2];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label1.frame = CGRectMake(15, 5, 80, 20);
    self.label2.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-150-10, 5, 150, 20);
}

- (void)setLineModel:(DSLineChooseModel *)lineModel{
    _lineModel = lineModel;
    lineModel.pingActionBlock = ^(double timeMilliseconds) {
        NSString * des = @"ms[非常快]";
        if (timeMilliseconds>60) {
            des = @"ms[很快]";
        }
        if (timeMilliseconds>100) {
            des = @"ms[一般]";
        }
        if (timeMilliseconds>150) {
            des = @"ms[较慢]";
        }
        if (timeMilliseconds>200) {
            des = @"ms[非常慢]";
        }
        NSString * ss = [NSString stringWithFormat:@"%.1f%@",timeMilliseconds,des];
        self.label2.text = ss;
    };
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
