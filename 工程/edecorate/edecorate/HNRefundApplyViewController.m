//
//  HNRefundApplyViewController.m
//  edecorate
//
//  Created by 刘向宏 on 14-9-21.
//
//

#import "HNRefundApplyViewController.h"
#import "HNDecorateChoiceView.h"
#import "UIView+AHKit.h"
#import "NSString+Crypt.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "HNLoginData.h"

@interface HNRefundApplyViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,HNDecorateChoiceViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;

@property (strong, nonatomic) IBOutlet UILabel *projectrefundLabel;
@property (strong, nonatomic) IBOutlet UILabel *finefundLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardnumberLabel;

@property (nonatomic, strong)UIImagePickerController *imagePicker;

//@property (strong, nonatomic) IBOutlet HNDecorateChoiceView *choiceDecorateView;
@end

@implementation HNRefundApplyViewController

-(id)initWithModel:(HNRefundData *)model
{
    self = [super init];
    self.temporaryModel = model;
    
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate =self;
    self.imagePicker.sourceType = sourceType;
    self.imagePicker.allowsEditing = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.choiceDecorateView = [[HNDecorateChoiceView alloc]initWithFrame:CGRectMake(12, 12, self.view.bounds.size.width-24, 25)];
//    [self.view addSubview:self.choiceDecorateView];
//    self.choiceDecorateView.delegate = self;
    
    self.navigationItem.title = NSLocalizedString(@"Deposit refund", nil);
    
    
    [self.commitButton setTitle:NSLocalizedString(@"Deposit refund", nil) forState:UIControlStateNormal];
    self.commitButton.layer.cornerRadius = 5.0;
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:72.0/255.0 blue:0.0 alpha:1.0]];
    
    self.projectrefundLabel.text = self.temporaryModel.projectrefund;
    self.finefundLabel.text = self.temporaryModel.finefund;
    self.cardnumberLabel.text = self.temporaryModel.cardnumber;
}

- (void)updataDecorateInformation:(HNDecorateChoiceModel*)model
{
//    self.houseInfLabel.text = model.roomName;
//    self.ownersPhoneNumberLabel.text = model.ownerphone;
//    self.ownersLabel.text = model.ownername;
//    [self.ownersPhoneNumberLabel sizeToFit];
//    [self.ownersLabel sizeToFit ];
//    self.ownersPhoneNumberLabel.right = self.view.width - 14;
//    self.ownersLabel.right = self.ownersPhoneNumberLabel.left-5;
    self.temporaryModel.declareId = model.declareId;
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
    request.URL = [NSURL URLWithString:[NSString createResponseURLWithMethod:@"set.deposit.refund" Params:jsonStr]];
    NSString *contentType = @"text/html";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data)
        {
            NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *retJson =[NSString decodeFromPercentEscapeString:[retStr decryptWithDES]];
            NSLog(@"%@",retJson);
            NSDictionary* dic = [retJson objectFromJSONString];
            if ([[dic objectForKey:@"total"] intValue])
            {
                NSArray *arry = [dic objectForKey:@"data"];
                NSDictionary* dicData = [arry objectAtIndex:0];
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:[dicData objectForKey:@"msg"] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil,nil];
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
        
    }];
}

- (NSDictionary *)encodeWithModel{
    /*
     declareid		报建编号
     cardnum		回收出入证数量
     cardimg		回收照片
     */
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.temporaryModel.declareId,@"declareid", @"0",@"cardnum",self.temporaryModel.declareId,@"cardimg",nil];
    return dic;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)upload:(id)sender{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    //[self.uploadImages setObject:image forKey:[NSNumber numberWithInteger:self.curButton.tag]];;
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
