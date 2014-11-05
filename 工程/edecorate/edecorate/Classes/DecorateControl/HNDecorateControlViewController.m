//
//  HNDecorateControlViewController.m
//  edecorate
//
//  Created by hxx on 9/17/14.
//
//

#import "HNDecorateControlViewController.h"
#import "UIView+AHKit.h"
#import "HNDecorateReportViewController.h"
#import "HNTemporaryFireViewController.h"
#import "HNOfficePassesViewController.h"
#import "HNDecorateCheckViewController.h"
#include "HNComplaintTableViewController.h"
#import "HNRefundTableViewController.h"
#import "HNOfficePassesApplyViewController.h"
#import "HNDeliverViewController.h"


/*
 装修报建
 装修验收
 办出入证
 临时用火
 临时用电
 送货安装
 押金退款
 我要投诉
 
 Reported that construction decoration
 Decoration acceptance
 Office passes
 Temporary fire
 Temporary power
 Delivery&Installation
 Deposit refund
 I have a complaint
 */

@interface HNDecorateControlViewController ()

@property (nonatomic, strong)UIButton *decorateReportedConstruction;
@property (nonatomic, strong)UIButton *decorateAcceptance;
@property (nonatomic, strong)UIButton *officePasses;
@property (nonatomic, strong)UIButton *temporaryFire;
@property (nonatomic, strong)UIButton *temporaryPower;
@property (nonatomic, strong)UIButton *deliveryAndInstallation;
@property (nonatomic, strong)UIButton *depositRefund;
@property (nonatomic, strong)UIButton *IHaveAComplaint;
@end


@implementation HNDecorateControlViewController


#define HSPACE 126/2
#define WLEFT 30/2
#define WRIGHT 30/2
#define WSPACE 44/2
#define TSPACEPER 0.1
#define STARTTOP 266/2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"Decorate Control", nil) ;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.decorateReportedConstruction = [self createButtonWithTitle:NSLocalizedString(@"Reported that construction decoration", nil) selector:@selector(decorateReportedConstructionButton_Clicked:) row:0 coloum:0 image:[UIImage imageNamed:@"装修报建.png"] imageClick:[UIImage imageNamed:@"装修报建点击.png"]];
    
    self.decorateAcceptance = [self createButtonWithTitle:NSLocalizedString(@"Decoration acceptance", nil) selector:@selector(decorateAcceptanceButton_Clicked:) row:0 coloum:1 image:[UIImage imageNamed:@"装修验收.png"] imageClick:[UIImage imageNamed:@"装修验收点击.png"]];
    self.officePasses = [self createButtonWithTitle:NSLocalizedString(@"Office passes", nil) selector:@selector(officePassesButton_Clicked:) row:0 coloum:2 image:[UIImage imageNamed:@"办出入证.png"] imageClick:[UIImage imageNamed:@"办出入证点击.png"]];
    self.temporaryFire = [self createButtonWithTitle:NSLocalizedString(@"Temporary fire", nil) selector:@selector(temporaryFireConstructionButton_Clicked:) row:0 coloum:3 image:[UIImage imageNamed:@"临时用火.png"] imageClick:[UIImage imageNamed:@"临时用火点击.png"]];
    self.temporaryPower = [self createButtonWithTitle:NSLocalizedString(@"Temporary power", nil) selector:@selector(temporaryPowerButton_Clicked:) row:1 coloum:0 image:[UIImage imageNamed:@"临时用电.png"] imageClick:[UIImage imageNamed:@"临时用电点击.png"]];
    self.deliveryAndInstallation = [self createButtonWithTitle:NSLocalizedString(@"Delivery&Installation", nil) selector:@selector(deliveryAndInstallationButton_Clicked:) row:1 coloum:1 image:[UIImage imageNamed:@"送货安装.png"] imageClick:[UIImage imageNamed:@"送货安装点击.png"]];
    self.depositRefund = [self createButtonWithTitle:NSLocalizedString(@"Deposit refund", nil) selector:@selector(depositRefundButton_Clicked:) row:1 coloum:2 image:[UIImage imageNamed:@"押金退款.png"] imageClick:[UIImage imageNamed:@"押金退款点击.png"]];
    self.IHaveAComplaint = [self createButtonWithTitle:NSLocalizedString(@"I have a complaint", nil) selector:@selector(IHaveAComplaintButton_Clicked:) row:1 coloum:3 image:[UIImage imageNamed:@"我要投诉.png"] imageClick:[UIImage imageNamed:@"我要投诉点击.png"]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title selector:(SEL)selector row:(int)ro coloum:(int)col image:(UIImage* )image imageClick:(UIImage* )imageClick{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:imageClick forState:UIControlStateSelected];
    [btn.titleLabel setContentMode:UIViewContentModeCenter];
    [btn sizeToFit];
    CGFloat f = (self.view.width - image.size.width*4)/5.0;
    CGFloat hf = (self.view.bounds.size.height -100 - image.size.width*2 - HSPACE-40)/2.0;
    btn.left = f+(f+image.size.width)*col;
    btn.top = hf+(image.size.width+20+HSPACE)*ro;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, image.size.height, image.size.width, 20)];
    
    [btn addSubview:label];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    
    
    //btn.layer.borderWidth = 1.0;
    //btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}


- (void)setMyInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (UIInterfaceOrientationIsPortrait(orientation)){
    }
    else{
    }
}

-(void)btnclicked:(UIButton*)btn
{
}

- (void)decorateReportedConstructionButton_Clicked:(id)sender{
    HNDecorateReportViewController *reportViewController = [[HNDecorateReportViewController alloc] init];
    reportViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reportViewController animated:YES];
}

- (void)decorateAcceptanceButton_Clicked:(id)sender{
    HNDecorateCheckViewController *checkViewController = [[HNDecorateCheckViewController alloc] init];
    checkViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkViewController animated:YES];
}
- (void)officePassesButton_Clicked:(id)sender{
    HNOfficePassesViewController *officePassViewcontroller=[[HNOfficePassesViewController alloc] init];
    officePassViewcontroller.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:officePassViewcontroller animated:YES];
    
    //HNOfficePassesApplyViewController *officePassApplyViewcontroller=[[HNOfficePassesApplyViewController alloc] init];
    //[self.navigationController pushViewController:officePassApplyViewcontroller animated:YES];
}

- (void)temporaryFireConstructionButton_Clicked:(id)sender{
    HNTemporaryFireViewController *temporaryViewController = [[HNTemporaryFireViewController alloc] initWithTemporaryType:FIRE];
    temporaryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temporaryViewController animated:YES];
}

- (void)temporaryPowerButton_Clicked:(id)sender{
    HNTemporaryFireViewController *temporaryViewController = [[HNTemporaryFireViewController alloc] initWithTemporaryType:POWER];
    temporaryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temporaryViewController animated:YES];
}

- (void)deliveryAndInstallationButton_Clicked:(id)sender{
    HNDeliverViewController *deliverViewController = [[HNDeliverViewController alloc]init];
    deliverViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deliverViewController animated:YES];
}

- (void)depositRefundButton_Clicked:(id)sender{
    HNRefundTableViewController *refundViewcontroller=[[HNRefundTableViewController alloc] init];
    refundViewcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:refundViewcontroller animated:YES];
}

- (void)IHaveAComplaintButton_Clicked:(id)sender{
    HNComplaintTableViewController *complaintViewController = [[HNComplaintTableViewController alloc] init];
    complaintViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:complaintViewController animated:YES];
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
