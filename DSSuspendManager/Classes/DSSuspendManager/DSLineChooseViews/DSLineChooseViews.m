//
//  DSLineChooseViews.m
//  SuspendBtn
//
//  Created by Chian on 2018/11/10.
//  Copyright © 2018 com.deshen.suspend. All rights reserved.
//

#import "DSLineChooseViews.h"
#import "STDPingServices.h"
#import "DSLineChooseModel.h"
#import "DSLineChooseCell.h"

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
static NSString * autoChooseSwitchKey = @"autoChooseSwitchKey";

@interface DSLineChooseViews ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentChooseLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoChooseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *on_offSwitch;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSArray <DSLineChooseModel*>* dataArr;

@end

@implementation DSLineChooseViews

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray new];
    }
    return _dataArr;
}

- (void)setTableViewDelegate {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setContentViewLayout {
    self.contentView.layer.cornerRadius = 7;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setAutoSwitchStatus {
    BOOL autoOpen = [NSUserDefaults.standardUserDefaults boolForKey:autoChooseSwitchKey];
    self.autoChooseSwitch.on = autoOpen;
}

- (void)setDefaultOn_OffSwitchStatus:(BOOL)status{
    self.on_offSwitch.on = status;
}

- (void)swichAddTarget {
    [self.on_offSwitch addTarget:self action:@selector(on_offSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.autoChooseSwitch addTarget:self action:@selector(autoChooseSwitchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAutoSwitchStatus];
    [self setContentViewLayout];
    [self setTableViewDelegate];
    [self swichAddTarget];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, screenW, screenH);
}

- (void)setALineWithURL:(DSLineChooseModel *)fasterLine {
    NSString * urlStirng = [self fixURL:fasterLine];
    [self setCurrentLabel:fasterLine];
    if ([self.delegate respondsToSelector:@selector(manuallyChooseWithURL:DSLineChooseViews:)]) {
        NSURL * url = [[NSURL alloc]initWithString:urlStirng];
        [self.delegate manuallyChooseWithURL:url DSLineChooseViews:self];
    }
}

- (NSString *)fixURL:(DSLineChooseModel *)fasterLine {
    NSString * urlStirng = fasterLine.url.absoluteString;
    if (fasterLine.url.host==nil) urlStirng = [NSString stringWithFormat:@"http://%@",fasterLine.url.absoluteString];
    return urlStirng;
}

- (void)setCurrentLabel:(DSLineChooseModel *)fasterLine {
    self.currentChooseLabel.text = [NSString stringWithFormat:@"当前线路：%lu",(unsigned long)fasterLine.idx+1];
}

- (void)autoSetLineWithURLs:(NSArray<DSLineChooseModel*> *)array {
    if (self.autoChooseSwitch.on) {
        // 排序
        NSArray * resArray = [array sortedArrayUsingComparator:^NSComparisonResult(DSLineChooseModel*  _Nonnull obj1, DSLineChooseModel*  _Nonnull obj2) {
            return obj1.timeMilliseconds>obj2.timeMilliseconds;
        }];
        // 得到最快
        DSLineChooseModel * fasterLine = resArray.firstObject;
        NSString * urlStirng = [self fixURL:fasterLine];
        [self setCurrentLabel:fasterLine];
        if ([self.delegate respondsToSelector:@selector(autoChooseWithURL:DSLineChooseViews:)]) {
            NSURL * url = [[NSURL alloc]initWithString:urlStirng];
            [self.delegate autoChooseWithURL:url DSLineChooseViews:self];
        }
    }

}

- (NSMutableArray<DSLineChooseModel *> *)converModel:(NSArray<NSString *> *)urls {
    NSMutableArray<DSLineChooseModel*> * urlArray = [[NSMutableArray alloc]init];
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DSLineChooseModel * model = [[DSLineChooseModel alloc]init];
        model.url = [NSURL URLWithString:obj];
        model.idx = idx;
        [urlArray addObject:model];
    }];
    return urlArray;
}

- (void)cancelAllPingTask{
    for (DSLineChooseModel*item in self.dataArr) {
        [item stopPing];
    }
}

- (void)startAllPingTask {
    for (DSLineChooseModel*item in self.dataArr) {
        [item startPing];
    }
}

- (void)setData{
    // 异步执行测速
    __weak typeof(self) weakself = self;
    [self getHostLines:^(NSArray<NSString *> *urls) {
        // 转模型
        NSMutableArray<DSLineChooseModel *> * urlArray = [self converModel:urls];
        weakself.dataArr = urlArray;
        [weakself startAllPingTask];
        [weakself.tableView reloadData];
        
        // 3秒后自动关闭
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself cancelAllPingTask];
            [weakself autoSetLineWithURLs:weakself.dataArr];
        });
    }];
}

- (void)getHostLines:(void(^)(NSArray <NSString*>* urls))callBlock{
    if ([self.delegate respondsToSelector:@selector(URLsDSLineChooseViews)]) {
       NSArray<NSString*>* urls = [self.delegate URLsDSLineChooseViews];
        NSMutableArray *urlArr = [NSMutableArray array];
        [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = [obj stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            obj = [obj stringByReplacingOccurrencesOfString:@"https://" withString:@""];
            [urlArr addObject:obj];
        }];
        if (callBlock) {
            callBlock(urlArr);
        }
    }
}

- (void)showAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setData]; // 设置数据
    [self showAnimation];// 动画
    [self.on_offSwitch setOn:YES];// 显示了就要把开关打开
}

- (void)dismissAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)dismiss{
    [self dismissAnimation];
    [self removeFromSuperview];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject].view.subviews containsObject:_contentView]) {
        [self cancelAllPingTask];
        [self dismiss];
    }
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSLineChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) cell = [[DSLineChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    DSLineChooseModel * model = self.dataArr[indexPath.row];
    cell.lineModel = model;
    cell.label1.text = [NSString stringWithFormat:@"线路%ld",(long)indexPath.row+1];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSLineChooseModel * model = self.dataArr[indexPath.row];
    [self cancelAllPingTask];
    [self setALineWithURL:model];
}

#pragma mark - action

- (void)autoChooseSwitchAction:(UISwitch *)st{
    [NSUserDefaults.standardUserDefaults setBool:st.on forKey:autoChooseSwitchKey];
    if (st.on) {
        [self cancelAllPingTask];
        [self autoSetLineWithURLs:self.dataArr];
    }
}

- (void)on_offSwitchAction:(UISwitch *)st{
    if ([self.delegate respondsToSelector:@selector(floatBtnWithClose:DSLineChooseViews:)]) {
        [self.delegate floatBtnWithClose:!st.on DSLineChooseViews:self];
    }
}
@end





