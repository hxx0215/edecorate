//
//  HNDeliverApplyViewController.m
//  edecorate
//
//  Created by 刘向宏 on 14-11-1.
//
//

#import "HNDeliverApplyViewController.h"
#import "UIView+AHKit.h"
#import "NSString+Crypt.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "HNLoginData.h"
#import "HNDecorateChoiceView.h"
#import "HNDeliverData.h"
#import "HNPersonNewTableViewCell.h"
#import "HNUploadImage.h"
#import "HNDeliverGodTableViewCell.h"

@interface HNDeliverApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HNDecorateChoiceViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
@property bool bo;
@property (strong, nonatomic) HNDecorateChoiceView *choiceDecorateView;

@property (nonatomic, strong)IBOutlet UITextField* productTextField;
@property (nonatomic, strong)IBOutlet UITextField* bTimeTextField;
@property (nonatomic, strong)IBOutlet UITextField* eTimeTextField;


@property (nonatomic, strong) HNDeliverData* model;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIButton * imageButton;

@property (strong, nonatomic) UIDatePicker *pickerView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIToolbar * topView;
@property (strong,nonatomic) UIView *commitView;
@property (nonatomic)CGFloat contentSizeHeight;
@end

@implementation HNDeliverApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bo = false;
    self.navigationItem.title = NSLocalizedString(@"Delivery&Installation Apply", nil);
    
    self.model = [[HNDeliverData alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    HNDeliverProposerItem *Proposer = [[HNDeliverProposerItem alloc]init];
    [self.model.proposerItems addObject:Proposer];
    
    
    self.choiceDecorateView = [[HNDecorateChoiceView alloc]initWithFrame:CGRectMake(12, 12, self.view.bounds.size.width-24, 25)];
    self.choiceDecorateView.delegate = self;
    
    
    self.pickerView = [[UIDatePicker alloc]init];
    self.pickerView.frame = CGRectMake(0, 500, 300, 200);
    self.pickerView.backgroundColor = [UIColor grayColor];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    
    self.topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(OKTextClick)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [self.topView setItems:buttonsArray];
    
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate =self;
    self.imagePicker.sourceType = sourceType;
    self.imagePicker.allowsEditing = NO;
    
}

-(void)OKTextClick
{
    [self.bTimeTextField resignFirstResponder];
    [self.eTimeTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.frame = self.view.bounds;
    if(!self.commitView)
        self.commitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 88)];
    UIButton *purchase = [UIButton buttonWithType:UIButtonTypeCustom];
    purchase.height = 40;
    purchase.width = self.view.width - 36;
    purchase.left = 18;
    purchase.centerY = 44;
    purchase.layer.cornerRadius = 5.0;
    [purchase setTitle:NSLocalizedString(@"提交申请", nil) forState:UIControlStateNormal];
    [purchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purchase setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:72.0/255.0 blue:0.0 alpha:1.0]];
    [purchase addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.commitView addSubview:purchase];
    [self movewButton];
}

-(void)movewButton
{
    CGSize size = self.tableView.contentSize;
    self.commitView.top = size.height;
    [self.tableView addSubview:self.commitView];
    size.height += self.commitView.height;
    self.tableView.contentSize = size;
    self.contentSizeHeight = size.height;
}

- (IBAction)addNewClick:(id)sender
{
    HNDeliverProposerItem* data = [[HNDeliverProposerItem alloc]init];
    [self.model.proposerItems addObject:data];
    [self.tableView reloadData];
    [self movewButton];
}


- (void)updataDecorateInformation:(HNDecorateChoiceModel*)model
{
    self.model.declareId = model.declareId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commit:(id)sender
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *jsonStr = [[self encodeWithModel] JSONString];
    request.URL = [NSURL URLWithString:[NSString createResponseURLWithMethod:@"set.install.list" Params:jsonStr]];
    NSString *contentType = @"text/html";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        [self performSelectorOnMainThread:@selector(didcommit:) withObject:data waitUntilDone:YES];
    }];
    
}

-(void)didcommit:(NSData*)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (data)
    {
        NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *retJson =[NSString decodeFromPercentEscapeString:[retStr decryptWithDES]];
        NSLog(@"%@",retJson);
        NSDictionary* dic = [retJson objectFromJSONString];
        int commitStatus = 1;
        if (commitStatus)
        {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"支付成功，您的申请已提交审核，请在审核通过够到物业管理处领取证件", nil) delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
            alert.tag=1;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Loading Fail", nil) message:NSLocalizedString(@"Please try again", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error", nil) message:NSLocalizedString(@"Please check your network.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
    }

}

- (NSDictionary *)encodeWithModel{
    /*
     declareId	Y	报建编号
     product		送货产品名称
     btime		送货开始时间
     etime		送货结束时间
     proposer		申请人员信息json[{realname:姓名,idcard:身份证号,phone:联系电话,idcardImg:身份证照片,icon:头像},{...}]）
     needItem		缴费项json([{name:名称,price:价格,useUnit:单位,number:数量,IsSubmit:是否必缴,Isrefund:是否可退,totalMoney:总金额,sort:排序},{...}]
     */
    

    NSArray *array = [[NSArray alloc]init];
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    for (int i=0; i<[self.model.proposerItems count]; i++) {
        HNDeliverProposerItem *tModel = [self.model.proposerItems objectAtIndex:i];
        NSDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
        //申请人员信息JSON（realname：姓名，idcard：身份证号，phone：联系电话，idcardImg：身份证照片，icon：头像）
        [dic setValue:tModel.name forKey:@"realname"];
        [dic setValue:tModel.IDcard forKey:@"idcard"];
        [dic setValue:tModel.phone forKey:@"phone"];
        [dic setValue:tModel.IDcardImg forKey:@"idcardImg"];
        [dic setValue:tModel.Icon forKey:@"icon"];
        [jsonArray addObject:dic];
    }
    array = [NSArray arrayWithArray:jsonArray];
    
    NSArray *array2 = [[NSArray alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.declareId,@"declareId", self.model.product,@"product",self.model.bTime,@"btime",self.model.eTime,@"etime",[array JSONString],@"proposer",[array2 JSONString],@"needItem",nil];
    NSLog(@"%@",[dic JSONString]);
    
    return dic;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if(alertView.tag==1)
    //self.temporaryModel.status = TemporaryStatusApplying;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4+[self.model.proposerItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else if (section==1) {
        return 1;
    }
    else if (section<[self.model.proposerItems count]+2) {
        return 1;
    }
    else if (section==2+[self.model.proposerItems count]) {
        return 0;
    }
    else if (section==3+[self.model.proposerItems count]) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 55)];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, tableView.width - 20, 50)];
    contentView.backgroundColor = [UIColor projectGreen];
    if (section==0 || section== 2+[self.model.proposerItems count])
    {
        [HNUIStyleSet UIStyleSetRoundView:contentView];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    
    if (section==0) {
        if(!self.choiceDecorateView)
        {
            self.choiceDecorateView = [[HNDecorateChoiceView alloc]initWithFrame:CGRectMake(12, 12, self.view.bounds.size.width-24, 30)];
            self.choiceDecorateView.delegate = self;
            self.choiceDecorateView.left = 5;
            self.choiceDecorateView.centerY = contentView.height / 2;
            
        }
        [contentView addSubview:self.choiceDecorateView];
    }
    else if (section==2+[self.model.proposerItems count]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.width = contentView.width -10;
        btn.height = contentView.height -5;
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.left = 5;
        btn.centerY = contentView.height / 2;
        [contentView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"+号_24"] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"新增送货安装人员", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addNewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.width = contentView.width -10;
        label.height = contentView.height -5;
        label.numberOfLines = 2;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.left = 5;
        label.centerY = contentView.height / 2;
        [contentView addSubview:label];
        if (section==1) {
            label.text = NSLocalizedString(@"货物信息", nil);
        }
        else if (section<[self.model.proposerItems count]+2) {
            label.text = NSLocalizedString(@"施工人员信息", nil);
        }
        
        else if (section==3+[self.model.proposerItems count]) {
            label.text = NSLocalizedString(@"缴费项目", nil);
        }
    }
    [view addSubview:contentView];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1)
    {
        return 100;
    }
    else if (indexPath.section<[self.model.proposerItems count]+2)
    {
        return 145;
    }
    return 30;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1)
    {
        static NSString *identy = @"deliverGodCell";
        HNDeliverGodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
        if (!cell)
        {
            cell = [[HNDeliverGodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        }
        cell.nameTextField.text = self.model.product;
        cell.bTimeTextField.text = self.model.bTime;
        cell.endTimeTextField.text = self.model.eTime;
        cell.nameTextField.tag = 7;
        cell.bTimeTextField.tag = 8;
        cell.endTimeTextField.tag = 9;
        cell.nameTextField.delegate = self;
        cell.bTimeTextField.delegate = self;
        cell.endTimeTextField.delegate = self;
        cell.bTimeTextField.inputView = self.pickerView;
        cell.endTimeTextField.inputView = self.pickerView;
        cell.bTimeTextField.inputAccessoryView = self.topView;
        cell.endTimeTextField.inputAccessoryView = self.topView;
        self.bTimeTextField = cell.bTimeTextField;
        self.eTimeTextField = cell.endTimeTextField;
        self.productTextField = cell.nameTextField;
        return cell;
    }
    else if (indexPath.section<[self.model.proposerItems count]+2)
    {
        static NSString *identy = @"newPersonCell";
        HNPersonNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
        if (!cell)
        {
            cell = [[HNPersonNewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        }
        HNDeliverProposerItem *peroposer = (HNDeliverProposerItem *)[self.model.proposerItems objectAtIndex:(indexPath.section -2)];
        cell.nameTextField.delegate = self;
        cell.nameTextField.text = peroposer.name;
        cell.nameTextField.tag = (indexPath.section-2)*10+1;
        cell.phoneTextField.delegate = self;
        cell.phoneTextField.text = peroposer.phone;
        cell.phoneTextField.tag = (indexPath.section-2)*10+2;
        cell.cardNOTextField.delegate = self;
        cell.cardNOTextField.text = peroposer.IDcard;
        cell.cardNOTextField.tag = (indexPath.section-2)*10+3;
        [cell.iconPhoto addTarget:self action:@selector(imageUploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cardPhoto addTarget:self action:@selector(imageUploadClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconPhoto.tag = (indexPath.section-2)*10+4;
        cell.cardPhoto.tag = (indexPath.section-2)*10+5;
        [cell reSetPohoto];
        if (peroposer.imageIcon) {
            [cell.iconPhoto setImage:peroposer.imageIcon forState:UIControlStateNormal];
        }
        if (peroposer.imageIDcard) {
            [cell.cardPhoto setImage:peroposer.imageIDcard forState:UIControlStateNormal];
        }
        return cell;
    }
    static NSString *identy = @"DefaultApplyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identy];
    }
    return cell;
    
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



#pragma mark UITextFieldDelegate

#pragma mark - UIImagePickerControllerDelegate

- (void)imageUploadClick:(id)sender
{
    self.imageButton = sender;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    CGFloat scaleSize = 0.1f;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    [HNUploadImage UploadImage:scaledImage block:^(NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (msg) {
            [self.imageButton setImage:image forState:UIControlStateNormal];
            
            NSInteger section = self.imageButton.tag/10;
            HNDeliverProposerItem *data = [self.model.proposerItems objectAtIndex:section];
            NSInteger row = self.imageButton.tag%10;
            switch (row) {
                case 4:
                {
                    data.imageIcon = image;
                    data.Icon = msg;
                }
                    break;
                case 5:
                {
                    data.imageIDcard = image;
                    data.IDcardImg = msg;
                }
                    
                default:
                    break;
            }
            
        }
    }];
    
}

#pragma mark textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    self.bo = true;
    NSLog(@"textFieldShouldBeginEditing");
    self.tableView.contentSize = CGSizeMake(self.view.bounds.size.width,self.contentSizeHeight+216);//原始滑动距离增加键盘高度
    CGPoint pt = [textField convertPoint:CGPointMake(0, 0) toView:self.tableView];//把当前的textField的坐标映射到scrollview上
    if(self.tableView.contentOffset.y-pt.y<=0)//判断最上面不要去滚动
        [self.tableView setContentOffset:CGPointMake(0, pt.y) animated:YES];//华东
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    self.bo = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==8||textField.tag==9) {
        NSDate *selected = [self.pickerView date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        textField.text = destDateString;
        if (textField.tag==8) {
            self.model.bTime = destDateString;
        }
        else
        {
            self.model.eTime = destDateString;
        }
    }
    else if(textField.tag == 7)
    {
        self.model.product = textField.text;
    }
    else
    {
        NSInteger section = textField.tag/10;
        HNDeliverProposerItem *data = [self.model.proposerItems objectAtIndex:section];
        NSInteger row = textField.tag%10;
        switch (row) {
            case 1:
            {
                data.name = textField.text;
            }
                break;
            case 2:
            {
                data.phone = textField.text;
            }
                break;
            case 3:
            {
                data.IDcard = textField.text;
            }
                break;
                
            default:
                break;
        }
    }
    
    if (!self.bo) {
        //开始动画
        [UIView animateWithDuration:0.30f animations:^{
            self.tableView.contentSize = CGSizeMake(self.view.bounds.size.width, self.contentSizeHeight);
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
