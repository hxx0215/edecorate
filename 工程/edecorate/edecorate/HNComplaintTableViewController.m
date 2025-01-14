//
//  HNComplaintViewController.m
//  edecorate
//
//  Created by 刘向宏 on 14-9-20.
//
//

#import "HNComplaintTableViewController.h"
#import "HNComplaintTableViewCell.h"
#import "HNComplaintApplyViewController.h"
#import "HNComplaintDetailsViewController.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "NSString+Crypt.h"
#import "HNLoginData.h"
#import "HNComplaintData.h"
#import "HNRefundData.h"
#import "MJRefresh.h"

@interface HNComplaintTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tTableView;
@property (nonatomic, strong)NSMutableArray *modelList;
@property (nonatomic, strong)HNComplaintTableViewCell* complaintTableViewCell;

@property (nonatomic)BOOL isfirst;
@property (nonatomic) NSInteger pages;
@property (nonatomic) NSInteger lastTotal;
@end

@implementation HNComplaintTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tTableView.delegate = self;
    self.tTableView.dataSource = self;
    self.tTableView.height = self.view.height - self.navigationController.navigationBar.height-20;
    [self.view addSubview:self.tTableView];
    self.modelList = [[NSMutableArray alloc] init];
    
    __weak typeof(self) wself = self;
    [self.tTableView addHeaderWithCallback:^{
        typeof(self) sself = wself;
        sself.pages = 0;
        sself.lastTotal = 8;
        [sself loadMyData];
    }];
    [self.tTableView addFooterWithCallback:^{
        typeof(self) sself = wself;
        [sself loadMore];
    }];
    self.isfirst = YES;
    self.pages = 0;
    self.lastTotal = 8;
    
    self.navigationItem.title = NSLocalizedString(@"I have a complaint", nil);


    [self initNaviButton];
//    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"新增", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addButton_Clicked)];
//    self.navigationItem.rightBarButtonItem = barButtonItem;

    //[self loadMyData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isfirst) {
        self.pages = 0;
        self.lastTotal = 8;
        [self loadMyData];
        self.isfirst = NO;
    }
    
}

-(void)loadMore
{
    if (self.lastTotal!=8) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tTableView footerEndRefreshing];
        });
        return ;//已到最后。返回
    }
    self.pages ++;
    [self loadMyData];
}

- (void)initNaviButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"add_click.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addButton_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)addButton_Clicked
{
    HNComplaintApplyViewController* avc = [[HNComplaintApplyViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)loadMyData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //HNLoginModel *model = [[HNLoginModel alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[HNLoginData shared].mshopid,@"mshopid",@"8",@"pagesize",[NSString stringWithFormat:@"%ld",(self.pages+1)],@"pageindex", nil];
    NSString *jsonStr = [dic JSONString];
    request.URL = [NSURL URLWithString:[NSString createResponseURLWithMethod:@"get.user.complaints" Params:jsonStr]];
    NSString *contentType = @"text/html";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        [self performSelectorOnMainThread:@selector(didloadMyData:) withObject:data waitUntilDone:YES];
    }];
}
- (void)showBadServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"服务器出现错误，请联系管理人员", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
    });
}
- (void)didloadMyData:(NSData *)data
{
    [self.tTableView headerEndRefreshing];
    [self.tTableView footerEndRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (data)
    {
        NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!retStr){
            [self showBadServer];
            return ;
        }
        NSString *retJson =[NSString decodeFromPercentEscapeString:[retStr decryptWithDES]];
        NSLog(@"%@",retJson);
        NSDictionary* dic = [retJson objectFromJSONString];
        NSNumber* total = [dic objectForKey:@"total"];
        if (self.pages==0) {
            [self.modelList removeAllObjects];
        }
        self.lastTotal = total.intValue;
        if (total.intValue){//之后需要替换成status
            NSArray* array = [dic objectForKey:@"data"];
            for (int i = 0; i<total.intValue; i++) {
                NSDictionary *dicData = [array objectAtIndex:i];
                HNComplaintData *tModel = [[HNComplaintData alloc] init];
                [tModel updateData:dicData];
                [self.modelList addObject:tModel];
                
            }
            [self.tTableView reloadData];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error", nil) message:NSLocalizedString(@"Please check your network.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
    }
}



#pragma mark - tableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.modelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"complaintCell";
    HNComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell){
        
        cell = [[HNComplaintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    HNComplaintData *model =self.modelList[indexPath.row];
    [cell setRoomName:model.room];
    [cell setStatus:model.constructionTeam];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.complaintTableViewCell = (HNComplaintTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    HNComplaintData* model = self.modelList[row];
//    if([model.complainObject isEqualToString:@""])
//    {
//        HNComplaintApplyViewController* avc = [[HNComplaintApplyViewController alloc]initWithModel:model];
//        [self.navigationController pushViewController:avc animated:YES];
//    }
//    else
    {
        HNComplaintDetailsViewController* dac = [[HNComplaintDetailsViewController alloc]initWithModel:model];
        [self.navigationController pushViewController:dac animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
