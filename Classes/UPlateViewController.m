//
//  UPlateViewController.m
//  P2PCamera
//
//  Created by Tsang on 13-1-21.
//
//

#import "UPlateViewController.h"
#import "PlayViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "obj_common.h"
#import "defineutility.h"
@interface UPlateViewController ()

@end

@implementation UPlateViewController
@synthesize pwd;
@synthesize user;
@synthesize did;
@synthesize pChannelMgt;
@synthesize navigationBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [navigationBar release];
    navigationBar=nil;
    pwd=nil;
    user=nil;
    did=nil;
    pChannelMgt=nil;
    [tableView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rx=[UIScreen mainScreen].bounds;
    NSInteger screenWidth=rx.size.width;
    NSInteger screenHeight=rx.size.height;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    navigationBar=[[UINavigationBar alloc]init];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.frame=CGRectMake(0.0f, 0.0f, screenWidth, 42.0f);
    //self.navigationBar.delegate=self;
    
    UINavigationItem *backItem=[[UINavigationItem alloc]initWithTitle:@"预览模式"];
    UINavigationItem *navItem=[[UINavigationItem alloc]initWithTitle:NSLocalizedStringFromTable(@"runcar_title", @STR_LOCALIZED_FILE_NAME, nil)];
    UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnBack)];
    //navItem.leftBarButtonItem=btnBack;
    [btnBack release];
    NSArray *array=[NSArray arrayWithObjects:backItem,navItem, nil];
    [navigationBar setItems:array];
    [navItem release];
    [self.view addSubview:navigationBar];
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 42, screenWidth, screenHeight-42) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
   
    pChannelMgt->SetSDCardSearchDelegate((char*)[did UTF8String], self);
    pChannelMgt->PPPPGetSDCardRecordFileList((char*)[did UTF8String], 0, 0);
}
-(void)playPPPView{
    IpCameraClientAppDelegate *ipClientAppDlg=[[UIApplication sharedApplication]delegate];
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.m_pPPPPChannelMgt=pChannelMgt;
    playViewController.strDID = did;
    //    playViewController.strUser=user;
    //    playViewController.strPwd=pwd;
    
    playViewController.cameraName = @"IpCam";
    playViewController.m_nP2PMode = 1;
    [ipClientAppDlg switchPlayView:playViewController];
    [playViewController release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark navigationbardelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    NSLog(@"navigationBar delegate");
    [self.navigationController popViewControllerAnimated:YES];
    [self playPPPView];
    return NO;
}


@end
