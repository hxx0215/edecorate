//
//  HNPurchaseViewController.m
//  edecorate
//
//  Created by hxx on 10/24/14.
//
//

#import "HNPurchaseViewController.h"
#import "HNPurchaseItem.h"
#import "HNPurchaseTableViewCell.h"
#import "MBProgressHUD.h"
#import "HNPaySupport.h"
#import "HNDecorateReportViewController.h"
@interface HNPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource,HNDecoratePayModelDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSIndexPath *selectIndex;
@property (nonatomic, strong)UIView *purchaseView;
@property (nonatomic, strong)UILabel *totalLabel;
@property (nonatomic, strong)UIButton *purchase;
@property (nonatomic, strong)UIButton *checkAll;
@property (nonatomic, assign)CGFloat totalFee;
@property (nonatomic, strong)NSMutableArray *sendData;
@end

@implementation HNPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initPurchaseView];
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}
- (void)initPurchaseView{
    self.purchaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, 0, 19)];
    self.totalLabel.font = [UIFont systemFontOfSize:19.0];
    self.totalLabel.text = @"合计￥3160.00";
    [self.totalLabel sizeToFit];
    self.totalLabel.left = 27;
    self.totalLabel.centerY = 74;
    
    self.purchase = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchase setTitle:NSLocalizedString(@"在线支付", nil) forState:UIControlStateNormal];
    [self.purchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.purchase.width = 130;
    self.purchase.height = 40;
    self.purchase.right = self.view.width - 18;
    self.purchase.top = 54;
    [self.purchase setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:72.0/255.0 blue:0 alpha:1.0]];
    self.purchase.layer.cornerRadius = 5.0;
    [self.purchase addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.purchaseView addSubview:self.totalLabel];
    [self.purchaseView addSubview:self.purchase];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    self.tableView.frame = self.view.bounds;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize size = self.tableView.contentSize;
    self.purchaseView.top = size.height;
    [self.tableView addSubview:self.purchaseView];
    size.height += self.purchaseView.height;
    self.tableView.contentSize = size;
    [self updateTotalPrice];
    for (int i=0;i<[self.allData count];i++){
        NSMutableDictionary *dic = [self.allData[i] mutableCopy];
        [dic setObject:@(0.00) forKey:@"number"];
        [dic setObject:@(0.00) forKey:@"totalMoney"];
        [self.allData replaceObjectAtIndex:i withObject:dic];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 55)];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, tableView.width - 20, 50)];
    contentView.backgroundColor = [UIColor projectGreen];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
    if ((section == 0)&&([self.mustPay count] == 0))
        maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
    if ((section==1)&&([self.optionPay count]==0))
        maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    [view addSubview:contentView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, view.width - 27, 14)];
    label.centerY = contentView.height / 2;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    [contentView addSubview:label];
    if (0==section){
//        view.backgroundColor = [UIColor colorWithRed:0 green:188.0/255.0 blue:125.0/255.0 alpha:1.0];
        label.text = NSLocalizedString(@"必交项目(单位:元)", nil);
    }
    else{
//        view.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:155.0/255.0 blue:239.0/255.0 alpha:1.0];
        label.text = NSLocalizedString(@"可选项目(单位:元)", nil);
        UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBox setBackgroundImage:[UIImage imageNamed:@"purchasecheckbox.png"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"purchasecheck.png"] forState:UIControlStateSelected];
        [checkBox addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
        [checkBox sizeToFit];
        self.checkAll = checkBox;
//        [contentView addSubview:checkBox];
        checkBox.left = 4;
        checkBox.centerY = label.centerY;
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0==section){
        return [self.mustPay count];
    }
    else if (1== section)
        return [self.optionPay count];
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        HNPurchaseItem *item = self.mustPay[indexPath.row];
        if (0 == item.single)
            return 45.0;
        else return 60.0;
    }
    else{
        HNPurchaseItem *item = self.optionPay[indexPath.row];
        if (0 == item.single)
            return 45.0;
        else return 60.0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                /*} else if (indexPath.row == 0) {
                 CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                 CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                 CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                 CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                 addLine = YES;*/
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
            
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath   {
    static NSString *identy = @"purchaseIdenty";
    HNPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell){
        cell = [[HNPurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        [cell.checkButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    }
    HNPurchaseItem *item = nil;
    if (indexPath.section == 0)
    {
//        cell.textLabel.text = [self.mustPay[indexPath.row] title];
        item = self.mustPay[indexPath.row];
        cell.detail.textColor = [UIColor colorWithWhite:128.0/255.0 alpha:1.0];
        cell.checkButton.hidden = YES;
        cell.checkButton.tag = 100 + indexPath.row;
    }
    else{
        item = self.optionPay[indexPath.row];
        cell.detail.textColor = [UIColor colorWithRed:45.0/255.0 green:138.05 blue:204.0 alpha:1.0];
        cell.checkButton.hidden = NO;
        cell.checkButton.tag = 1000 + indexPath.row;
    }
//    cell.checkButton.tag = indexPath.row;
    cell.title.text = item.title;
    cell.price.text = [NSString stringWithFormat:@"%.2f",item.price];
    cell.single = item.single;
    cell.detail.text = [NSString stringWithFormat:@"单价%.2f    数量%d",item.unitPrice,(int)item.nums];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HNPurchaseTableViewCell *cell = (HNPurchaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.single != 0){
        self.selectIndex = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请输入数量", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        HNPurchaseItem *item = nil;
        if (indexPath.section == 0)
        {
            item = self.mustPay[indexPath.row];
        }
        else
        {
            item = self.optionPay[indexPath.row];
        }
        tf.text = [NSString stringWithFormat:@"%d",(int)item.nums];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }
}
- (void)checkAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    [self.optionPay enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:1];
        HNPurchaseTableViewCell *cell = (HNPurchaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkButton.selected = sender.selected;
    }];
    [self updateTotalPrice];
}

- (void)check:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (!sender.selected)
        self.checkAll.selected = NO;
    if (sender.tag>=1000){
        int index = sender.tag % 1000;
        HNPurchaseItem *item = self.optionPay[index];
        item.isSelect = sender.selected;
        self.optionPay[index] = item;
    }
    [self updateTotalPrice];
}
- (void)poptoList{
    NSLog(@"%@",[self.navigationController viewControllers]);
    BOOL find = NO;
    for (UIViewController *vc in [self.navigationController viewControllers]){
        if ([vc isKindOfClass:[HNDecorateReportViewController class]])
        {
            find = YES;
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 123){
        [self poptoList];
        return ;
    }
    UITextField *tf=[alertView textFieldAtIndex:0];
    if (1==buttonIndex){
        HNPurchaseItem *item = nil;
        if (self.selectIndex.section == 0){
            item = self.mustPay[self.selectIndex.row];
        }else{
            item= self.optionPay[self.selectIndex.row];
        }
        HNPurchaseTableViewCell *cell = (HNPurchaseTableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
        cell.detail.text = [NSString stringWithFormat:@"单价%.2f    数量%d",item.unitPrice,(int)[tf.text integerValue]];
        item.nums = [tf.text integerValue];
        item.price = item.nums * item.unitPrice;
        cell.price.text = [NSString stringWithFormat:@"%.2f",item.price];
        for (int i=0;i<[self.allData count];i++){
            if ([self.allData[i][@"name"] isEqualToString:cell.title.text]){
                NSMutableDictionary *dic = [self.allData[i] mutableCopy];
                [dic setObject:[NSNumber numberWithFloat:[cell.price.text floatValue]] forKey:@"totalMoney"];
                [dic setObject:[NSNumber numberWithFloat:(CGFloat)item.nums] forKey:@"number"];
                [self.allData replaceObjectAtIndex:i withObject:dic];
                break ;
            }
        }
        [self updateTotalPrice];
    }
}

- (void)updateTotalPrice{
    __block CGFloat total = 0;
    [self.mustPay enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        HNPurchaseItem *item = obj;
        total += item.price;
    }];
    [self.optionPay enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        HNPurchaseItem *item = obj;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:1];
        HNPurchaseTableViewCell *cell = (HNPurchaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.checkButton.selected)
            total += item.price;
    }];
    self.totalLabel.text = [NSString stringWithFormat:@"合计￥%.2f",total];
    self.totalFee = total;
    [self.totalLabel sizeToFit];
    self.totalLabel.right = self.purchase.left - 24;
}
- (void)showMustSub{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"有必交项未填入数量", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
    [alert show];
}
- (void)purchase:(id)sender{
    if (fabs(self.totalFee)<1e-6)
        return ;
    NSMutableArray *item = [NSMutableArray new];
    for (int i=0;i<[self.allData count];i++){
        NSMutableDictionary *dic =[NSMutableDictionary new];
        BOOL iscontinue = NO;
        [dic setObject:self.allData[i][@"name"] forKey:@"name"];
        for (int i=0;i<[self.optionPay count];i++)
            if ([[self.optionPay[i] title] isEqualToString:dic[@"name"]]){
                iscontinue = ![self.optionPay[i] isSelect];
                break;
            }
        if (iscontinue) continue;
        [dic setObject:[NSNumber numberWithFloat:[self.allData[i][@"price"] floatValue]] forKey:@"price"];
        [dic setObject:self.allData[i][@"useUnit"] forKey:@"useUnit"];
        [dic setObject:self.allData[i][@"number"] forKey:@"number"];
        [dic setObject:[NSNumber numberWithFloat:[self.allData[i][@"IsSubmit"] floatValue]]  forKey:@"IsSubmit"];
        [dic setObject:[NSNumber numberWithFloat:[self.allData[i][@"Isrefund"] floatValue]]  forKey:@"Isrefund"];
        [dic setObject:self.allData[i][@"totalMoney"] forKey:@"totalMoney"];
        [dic setObject:@(i) forKey:@"sort"];
        [item addObject:dic];
    }
    NSArray *arr = [NSArray arrayWithArray:item];
    NSDictionary *sendDic = @{@"u_paytype":[NSString stringWithFormat:@"%d",self.type],@"u_declareId": self.declareid};
    NSString *sendJson = [sendDic JSONString];
    NSLog(@"%@",sendJson);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:[NSString createResponseURLWithMethod:@"update.decoraton.declaredetails" Params:sendJson]];//[NSURL URLWithString:[NSString createLongResponseURLWithMethod:@"update.decoraton.declaredetails" Params:sendJson ]];
    NSString *bodyStr = [NSString stringWithFormat:@"u_needItem=%@",[arr JSONString]];
    NSData *jsonBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonBody];
    NSString *postLength = [NSString stringWithFormat:@"%d",[jsonBody length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (data){
            NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!retStr){
                [self showBadServer];
                return ;
            }
            NSString *retJson =[NSString decodeFromPercentEscapeString:[retStr decryptWithDES]];
            NSDictionary *retDic = [retJson objectFromJSONString];
            NSLog(@"%@",retDic);
            [HNPaySupport shared].delegate = self;
            [[HNPaySupport shared] getPayToken:self.declareid cid:self.declareid payType:self.type];
            [self showJump];
        }
    }];
}
- (void)showBadServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"服务器出现错误，请联系管理人员", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
    });
}
- (void)showJump{
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"完成", nil) message:NSLocalizedString(@"请在网页端完成支付", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"完成", nil) otherButtonTitles:NSLocalizedString(@"支付遇到问题", nil), nil];
//        alert.tag = 123;
//        [alert show];
        [self poptoList];
    });
}
- (void)didGetPayUrl:(NSString *)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
