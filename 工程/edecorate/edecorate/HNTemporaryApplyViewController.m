//
//  HNTemporaryApplyViewController.m
//  edecorate
//
//  Created by 刘向宏 on 14-9-18.
//
//

#import "HNTemporaryApplyViewController.h"
#import "UIView+AHKit.h"
/*
 "House Information" = "房屋信息";
 "Owners" = "业主";
 "Phone number" = "手机号";
 "Construction unit" = "施工单位";
 "Person in charge of construction" = "施工负责人";
 "Notice the use of fire" = "用火须知";
 "Fire units" = "用火单位";
 "Use of fire by" = "用火是由";
 "Fire tools" = "用火工具";
 "Fire load" = "用火负荷";
 "Start Time" = "开始时间";
 "End Time" = "结束时间";
 "Operator" = "操作人";
 "Phone" = "联系电话";
 "Valid documents" = "有效证件";
 "Upload" = "上传";
 "Submission" = "提交申请";
 */
@interface HNTemporaryApplyViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong)IBOutlet UIScrollView *mainView;
@property (nonatomic, strong)IBOutlet UILabel *houseInfMainLabel;
@property (nonatomic, strong)IBOutlet UILabel *houseInfTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *houseInfLabel;
@property (nonatomic, strong)IBOutlet UILabel *ownersTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *ownersLabel;
@property (nonatomic, strong)IBOutlet UILabel *ownersPhoneNumberTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *ownersPhoneNumberLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionUnitTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionUnitLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionPersonTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionPersonLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionPersonPhoneNumberTitleLabel;
@property (nonatomic, strong)IBOutlet UILabel *constructionPersonPhoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *temporaryApplyMainLable;
@property (strong, nonatomic) IBOutlet UILabel *fireunitsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *useOfFireByTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fireToolsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fireLoadTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *operatorTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *validDocumentsTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *noticeFireButton;
@property (strong, nonatomic) IBOutlet UILabel *uploadTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@end

#define HSPACE 10
#define WSPACE 5
#define TSPACEPER 0.1
#define LABELHEIGHT 20
#define STARTTOP 10

@implementation HNTemporaryApplyViewController

-(id)initWithModel:(HNTemporaryModel *)model
{
    self = [super init];
    self.temporaryModel = model;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self labelWithTitle:NSLocalizedString(@"House Information", nil) label:self.houseInfMainLabel];
    
    [self labelWithTitle:NSLocalizedString(@"House Information", nil) label:self.houseInfTitleLabel];
    [self labelWithTitle:self.temporaryModel.huseInfo.houseInf label:self.houseInfLabel];
    
    [self labelWithTitle:NSLocalizedString(@"Owners", nil) label:self.ownersTitleLabel];
    [self labelWithTitle:self.temporaryModel.huseInfo.constructionPerson  label:self.constructionPersonLabel];
    [self labelWithTitle:NSLocalizedString(@"Phone number", nil) label:self.ownersPhoneNumberTitleLabel];
    [self labelWithTitle:self.temporaryModel.huseInfo.ownersPhoneNumber  label:self.ownersPhoneNumberLabel];
    
    //constructionUnitTitleLabel
    [self labelWithTitle:NSLocalizedString(@"Construction unit", nil) label:self.constructionUnitTitleLabel];
    
    [self labelWithTitle:self.temporaryModel.huseInfo.constructionUnit  label:self.constructionUnitLabel];
    
    [self labelWithTitle:NSLocalizedString(@"Person in charge of construction", nil) label:self.constructionPersonTitleLabel];
    
    [self labelWithTitle:self.temporaryModel.huseInfo.owners  label:self.ownersLabel];
    
    [self labelWithTitle:NSLocalizedString(@"Phone number", nil) label:self.constructionPersonPhoneNumberTitleLabel];
    
    [self labelWithTitle:self.temporaryModel.huseInfo.constructionPersonPhoneNumber  label:self.constructionPersonPhoneNumberLabel];
    
    
    [self labelWithTitle:NSLocalizedString(@"Fire Apply", nil) label:self.temporaryApplyMainLable];
    [self labelWithTitle:NSLocalizedString(@"Fire units", nil) label:self.fireunitsTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Use of fire by", nil) label:self.useOfFireByTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Fire tools", nil) label:self.fireToolsTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Fire load", nil) label:self.fireLoadTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Start Time", nil) label:self.startTimeTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"End Time", nil) label:self.endTimeTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Operator", nil) label:self.operatorTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Phone", nil) label:self.phoneTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Valid documents", nil) label:self.validDocumentsTitleLabel];
    [self labelWithTitle:NSLocalizedString(@"Upload", nil) label:self.uploadTitleLabel];
    //@property (strong, nonatomic) IBOutlet UIButton *commitButton;
    [self.noticeFireButton setTitle:NSLocalizedString(@"Notice the use of fire", nil) forState:UIControlStateNormal];
    [self.noticeFireButton sizeToFit];

    
    [self.commitButton setTitle:NSLocalizedString(@"Submission", nil) forState:UIControlStateNormal];
    [self.commitButton sizeToFit];
    self.commitButton.layer.borderWidth = 1.0;
    self.commitButton.layer.borderColor = [UIColor blackColor].CGColor;

        // Do any additional setup after loading the view.
}

- (IBAction)commit:(id)sender
{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"已提交审核" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil,nil];
    alert.tag=1;
    [alert show];
}

- (IBAction)noticeFireClicked:(id)sender
{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"用火须知" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil,nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        self.temporaryModel.status = TemporaryStatusApplying;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)labelWithTitle:(NSString *)title label:(UILabel*)lab
{
    [lab setText:title];
    [lab sizeToFit];
    lab.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainView.frame = [[UIScreen mainScreen] bounds];
    self.mainView.contentSize = CGSizeMake(self.view.bounds.size.width, self.commitButton.bottom+20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
