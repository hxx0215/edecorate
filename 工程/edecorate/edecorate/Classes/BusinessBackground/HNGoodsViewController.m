//
//  HNGoodsViewController.m
//  edecorate
//
//  Created by hxx on 9/27/14.
//
//

#import "HNGoodsViewController.h"
#import "HNLoginData.h"
#import "HNImageData.h"

@interface HNGoodsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *backView;
@property (strong, nonatomic) NSMutableDictionary *goodsDetail;
@property (strong, nonatomic) IBOutlet UILabel *goodsname;
@property (strong, nonatomic) IBOutlet UILabel *groupprice;
@property (strong, nonatomic) IBOutlet UILabel *stock;
@property (strong, nonatomic) IBOutlet UILabel *goodstype;
@property (strong, nonatomic) IBOutlet UILabel *goodsitem;
@property (strong, nonatomic) IBOutlet UILabel *returnintegral;
@property (strong, nonatomic) IBOutlet UILabel *isfreedelivery;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UILabel *maxbought;
@property (strong, nonatomic) IBOutlet UILabel *virtualcount;
@property (strong, nonatomic) IBOutlet UILabel *begintime;
@property (strong, nonatomic) IBOutlet UILabel *endtime;
@property (strong, nonatomic) IBOutlet UILabel *classid1;
@property (strong, nonatomic) IBOutlet UILabel *classid2;
@property (strong, nonatomic) IBOutlet UILabel *classid3;
@property (strong, nonatomic) IBOutlet UILabel *intro;
@property (strong, nonatomic) IBOutlet UIImageView *img;


@end

@implementation HNGoodsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backView.frame = self.view.bounds;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backView.frame = self.view.bounds;
    self.backView.contentSize = CGSizeMake(320, 935);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showData{
    self.img.image = [[HNImageData shared] imageWithLink:self.goodsDetail[@"imgurl"]];
    self.goodsname.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"goodsname"]];
    self.groupprice.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"groupprice"]];
    self.stock.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"stock"]];
    self.goodstype.text = [[NSString stringWithFormat:@"%@",self.goodsDetail[@"goodstype"]] isEqualToString:@"1"] ? NSLocalizedString(@"实体商品", nil) : NSLocalizedString(@"虚拟商品", nil);
    self.goodsitem.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"goodsitem"]];
    self.returnintegral.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"returnintegral"]];
    self.isfreedelivery.text = [[NSString stringWithFormat:@"%@",self.goodsDetail[@"isfreedelivery"]] isEqualToString:@"1"] ? NSLocalizedString(@"是", nil) : NSLocalizedString(@"否", nil);
    self.weight.text = [NSString stringWithFormat:@"%@%@",self.goodsDetail[@"weight"],self.goodsDetail[@"weightUnit"]];
    self.maxbought.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"maxbought"]];
    self.virtualcount.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"virtualcount"]];
    self.begintime.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"begintime"]];
    self.endtime.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"endtime"]];
    self.classid1.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"classid1"]];
    self.classid2.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"classid2"]];
    self.classid3.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"classid3"]];
    self.intro.text = [NSString stringWithFormat:@"%@",self.goodsDetail[@"intro"]];
}
- (void)loadData{
    NSDictionary *sendDic = @{@"mshopid": [HNLoginData shared].mshopid,@"goodsid" : self.goodsid,@"imgwidth" : @"89", @"imgheight" : @"89"};
    NSString *sendJson = [sendDic JSONString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:[NSString createResponseURLWithMethod:@"get.goods.detail" Params:sendJson]];
    NSString *contentType = @"text/html";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (data)
        {
            NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!retStr)
            {
                [self showBadServer];
                return ;
            }
            NSString *retJson =[NSString decodeFromPercentEscapeString:[retStr decryptWithDES]];
            NSDictionary *retDic = [retJson objectFromJSONString];
            NSInteger count = [[retDic objectForKey:@"total"] integerValue];
            if (0!=count){
                self.goodsDetail = [[retDic objectForKey:@"data"][0] mutableCopy];
                [self showData];
            }
            else
                [self showNoData];
        }
        else
            [self showNoNetwork];
    }];
}
- (void)showBadServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"服务器出现错误，请联系管理人员", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
    });
}
- (void)showNoNetwork{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error", nil) message:NSLocalizedString(@"Please check your network.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
    
}
- (void)showNoData{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"We don't get any data.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

@end
