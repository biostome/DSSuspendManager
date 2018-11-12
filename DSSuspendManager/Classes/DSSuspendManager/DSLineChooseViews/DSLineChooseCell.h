//
//  DSLineChooseCell.h
//  DSSuspendManager
//
//  Created by Chian on 2018/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSLineChooseModel;
@interface DSLineChooseCell : UITableViewCell
@property (nonatomic, strong)UILabel *label1;
@property (nonatomic, strong)UILabel *label2;
@property (nonatomic, strong)DSLineChooseModel *lineModel;
@end

NS_ASSUME_NONNULL_END
