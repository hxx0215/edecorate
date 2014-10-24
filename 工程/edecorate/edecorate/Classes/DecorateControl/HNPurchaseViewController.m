//
//  HNPurchaseViewController.m
//  edecorate
//
//  Created by hxx on 10/24/14.
//
//

#import "HNPurchaseViewController.h"
#import "HNPurchaseItem.h"

@interface HNPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HNPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, view.width - 27, 14)];
    label.centerY = view.height / 2;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    if (0==section){
        view.backgroundColor = [UIColor colorWithRed:0 green:188.0/255.0 blue:125.0/255.0 alpha:1.0];
        label.text = NSLocalizedString(@"必交项目(单位:元)", nil);
    }
    else{
        view.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:155.0/255.0 blue:239.0/255.0 alpha:1.0];
        label.text = NSLocalizedString(@"可选项目(单位:元)", nil);
        UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath   {
    static NSString *identy = @"purchaseIdenty";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
    }
    if (indexPath.section == 0)
        cell.textLabel.text = [self.mustPay[indexPath.row] title];
    else
        cell.textLabel.text = [self.optionPay[indexPath.row] title];
    return cell;
}
@end
