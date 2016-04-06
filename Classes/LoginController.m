//
//  LoginController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-19.
//
//

#import "LoginController.h"
#import "obj_common.h"
#import "mytoast.h"
#import "RunCarNavViewController.h"
#import "CameraSearchViewController.h"
#import "PlayViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"
@interface LoginController ()

@end

@implementation LoginController
@synthesize label_status;
@synthesize tf_id;
@synthesize tf_pwd;
@synthesize tf_user;
@synthesize btn_login;
@synthesize btn_scanbarcode;
@synthesize btn_search;
@synthesize pChannelMgt;
@synthesize navigationBar;

@synthesize m_pPicPathMgt;
@synthesize m_pRecPathMgt;
@synthesize m_pCameraListMgt;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
   //[self.navigationController setNavigationBarHidden:YES];
    
    NSLog(@"viewWillAppear");
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}
-(void)dealloc{
    navigationBar=nil;
    if(tf_user!=nil){
        [tf_user release];
        tf_user=nil;
    }
    if(tf_id!=nil){
        [tf_id release];
        tf_id=nil;
    }
    if(btn_login!=nil){
        [btn_login release];
        btn_login=nil;
    }
    if(tf_pwd!=nil){
        [tf_pwd release];
        tf_pwd=nil;
    }
    [label_status release];
    label_status=nil;
    [ppppChannelMgntCondition release];
    ppppChannelMgntCondition=nil;
    
    user=nil;
    pwd=nil;
    did=nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");

    [super viewDidLoad];
    isLoginBtnPressed=NO;
    ppppChannelMgntCondition=[[NSCondition alloc]init];
    status_change=-100;
    CGRect rx=[UIScreen mainScreen].bounds;
    NSInteger screenWidth=rx.size.width;
    
    view=[[UIView alloc]init];
    view.frame=CGRectMake(0.0f, 0.0f, screenWidth, 340.0f);
    [self.view addSubview:view];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    navigationBar=[[UINavigationBar alloc]init];
    if (![IpCameraClientAppDelegate is43Version]) {
        [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];

    navigationBar.frame=CGRectMake(0.0f, 0.0f, screenWidth, 42.0f);
    [view addSubview:navigationBar];

    
    
    IpCameraClientAppDelegate  *appDelegate=[[UIApplication sharedApplication]delegate];
    appDelegate.appForegroudProtocol=self;
    
    
    label_status=[[UILabel alloc]init];
    label_status.frame=CGRectMake(80, 50, 160, 25);
    label_status.text=NSLocalizedStringFromTable(@"login_connect_status", @STR_LOCALIZED_FILE_NAME, nil);
    label_status.textColor=[UIColor blueColor];
    label_status.textAlignment=UITextAlignmentCenter;
    label_status.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:label_status];
    
    tf_id=[[UITextField alloc]init];
    tf_id.frame=CGRectMake(80.0f, 90.0f, 160.0f, 40.0f);
    [tf_id setBorderStyle:UITextBorderStyleRoundedRect];
    tf_id.secureTextEntry=NO;
    
    tf_id.delegate=self;
    tf_id.placeholder=NSLocalizedStringFromTable(@"login_id", @STR_LOCALIZED_FILE_NAME, nil);
    tf_id.autocorrectionType=UITextAutocorrectionTypeNo;
    tf_id.keyboardType=UIKeyboardTypeDefault;
    tf_id.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tf_id.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    tf_id.adjustsFontSizeToFitWidth=YES;
    tf_id.returnKeyType=UIReturnKeyDone;
    [view addSubview:tf_id];
    
    
    
    tf_user=[[UITextField alloc]initWithFrame:CGRectMake(80.0f, 140.0f, 160.0f, 40.0f)];
    [tf_user setBorderStyle:UITextBorderStyleRoundedRect];
    tf_user.secureTextEntry=NO;
    tf_user.delegate=self;
    tf_user.autocorrectionType=UITextAutocorrectionTypeNo;
    tf_user.placeholder=NSLocalizedStringFromTable(@"login_user", @STR_LOCALIZED_FILE_NAME, nil);
    tf_user.keyboardType=UIKeyboardTypeDefault;
    tf_user.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tf_user.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    tf_user.adjustsFontSizeToFitWidth=YES;
    tf_user.returnKeyType=UIReturnKeyDone;
    [view addSubview:tf_user];
    
    
    tf_pwd=[[UITextField alloc]initWithFrame:CGRectMake(80.0f, 190.0f, 160.0f, 40.0f)];
    [tf_pwd setBorderStyle:UITextBorderStyleRoundedRect];
    tf_pwd.secureTextEntry=YES;
    tf_pwd.delegate=self;
     tf_pwd.autocorrectionType=UITextAutocorrectionTypeNo;
    tf_pwd.placeholder=NSLocalizedStringFromTable(@"login_pwd", @STR_LOCALIZED_FILE_NAME, nil);
    tf_pwd.keyboardType=UIKeyboardTypeDefault;
    tf_pwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    tf_pwd.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    tf_pwd.adjustsFontSizeToFitWidth=YES;
    tf_pwd.returnKeyType=UIReturnKeyDone;
    [view addSubview:tf_pwd];
    
    btn_search=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_search.frame=CGRectMake(80.0f, 320.0f, 160.0f, 40.0f);
    
    [btn_search setTitle:NSLocalizedStringFromTable(@"LANSearch", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn_search addTarget:self action:@selector(btnSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_search];
    
    btn_scanbarcode=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_scanbarcode.frame=CGRectMake(80.0f, 370.0f, 160.0f, 40.0f);
    
    [btn_scanbarcode setTitle:NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn_scanbarcode addTarget:self action:@selector(btnScanBarCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_scanbarcode];
    
    
    btn_login=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_login.frame=CGRectMake(80.0f, 250.0f, 160.0f, 40.0f);
   
    [btn_login setTitle:NSLocalizedStringFromTable(@"login", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(btnLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
    
    pChannelMgt->pCameraViewController = self;
    //从实用属性列表中查数据
    NSString *filePath=[self dataFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
        NSArray *array=[[NSArray alloc]initWithContentsOfFile:filePath];
        NSLog(@"id=%@ user=%@ pwd=%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]);
        tf_id.text=[array objectAtIndex:0];
        tf_user.text=[array objectAtIndex:1];
        tf_pwd.text=[array objectAtIndex:2];
    }
}
-(void)setNavigationBarItem{
//    UINavigationItem *navItem=[[UINavigationItem alloc]initWithTitle:@"行车记录仪"];
//    NSArray *array=[NSArray arrayWithObjects:navItem, nil];
//    [self.navigationBar setItems:array];
//    [self.navigationController.navigationBar ];
}
-(void)btnScanBarCode{
  
}
-(void)btnSearch{
    CameraSearchViewController *cameraSearchView = [[CameraSearchViewController alloc] init];
    cameraSearchView.SearchAddCameraDelegate = self;
    [self.navigationController pushViewController:cameraSearchView animated:YES];
    [cameraSearchView release];
}
-(void)btnLogin{
    isLoginBtnPressed=YES;
    user=[tf_user text];
    pwd=[tf_pwd text];
    did=[tf_id text];
    
    if([did length]==0){
        [mytoast showWithText:NSLocalizedStringFromTable(@"login_inputid", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if([user length]==0){
        [mytoast showWithText:NSLocalizedStringFromTable(@"login_inputuser", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if([pwd length]==0){
      pwd=@"";
    }
//    NSLog(@"btnFinish ok");
//    RunCarNavViewController *runCarController=[[RunCarNavViewController alloc]init];
//    runCarController.did=did;
//    runCarController.pwd=pwd;
//    runCarController.user=user;
//    runCarController.title=NSLocalizedStringFromTable(@"runcar_title", @STR_LOCALIZED_FILE_NAME, nil);
//    runCarController.pChannelMgt=self.pChannelMgt;
//    [self.navigationController pushViewController:runCarController animated:YES];
//    [runCarController release];
//    //自定义返回按钮
//    UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleDone target:nil action:nil];
//    
//    self.navigationItem.backBarButtonItem=btnBack;
//    [btnBack release];
    
//    [self playPPPView:did strUser:user strPwd:pwd Param:1];
    //如果在线直接启动播放界面
    
   
    if (status_change==PPPP_STATUS_ON_LINE&&[tmptDid isEqualToString:did]&&[tmptuser isEqualToString:user]&&[tmptpwd isEqualToString:pwd]) {
        isLoginBtnPressed=NO;
        [self playPPPView];
        return;
    }
    tmptDid=did;
    tmptpwd=pwd;
    tmptuser=user;
    label_status.text=@"正在连接...";
    [self startPPPPThread];
    
    //did user pwd 保存到实用属性列表中
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:did];
    [array addObject:user];
    [array addObject:pwd];
    [array writeToFile:[self dataFilePath] atomically:YES];
}
-(void)startPPPPThread{
    [ppppChannelMgntCondition lock];
    if(pChannelMgt==nil){
        [ppppChannelMgntCondition unlock];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(startThreadRun) toTarget:self withObject:nil];
    [ppppChannelMgntCondition unlock];
    
}
-(void)startThreadRun{
    NSLog(@"startThreadRun");
    pChannelMgt->Stop([did UTF8String]);//先停止，不然它不会去连接，不知道原因？
    pChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
    pChannelMgt->SetRunCarDelegate((char *)[did UTF8String], self);
}
-(void)playPPPView{
    IpCameraClientAppDelegate *ipClientAppDlg=[[UIApplication sharedApplication]delegate];
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.m_pPPPPChannelMgt=pChannelMgt;
    playViewController.strDID = did;
    playViewController.strUser=user;
    playViewController.strPwd=pwd;
    playViewController.m_pRecPathMgt=m_pRecPathMgt;
    playViewController.m_pPicPathMgt=m_pPicPathMgt;
    playViewController.cameraName = @"IpCam";
    playViewController.m_nP2PMode = 1;
    [ipClientAppDlg switchPlayView:playViewController];
    [playViewController release];
    
}

-(NSString *)dataFilePath{
   NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                      , YES);
    NSString *paths=[path objectAtIndex:0];
    return[paths stringByAppendingPathComponent:@"runcar"];
    
}
#pragma mark -
#pragma mark SearchAddCameraInfoDelegate
- (void) AddCameraInfo:(NSString *)astrCameraName DID:(NSString *)strDID
{
    tf_id.text=strDID;
    tf_user.text=@"admin";
    
}
#pragma mark -
#pragma mark ZXingDelegateMethods



#pragma mark-
#pragma mark textfielddelegete
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    status_change=status;
    
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        //先刷新状态
        

        NSNumber *num=[NSNumber numberWithInt:status];
        [self performSelectorOnMainThread:@selector(refreshLabelStatus:) withObject:num waitUntilDone:NO];
        
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED) {
            
//            [self performSelectorOnMainThread:@selector(stopPPPPByDID:) withObject:strDID waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
            return;
        }

        return;
    }
    
}
- (void) StopPPPPByDID:(NSString*)sdid
{
    pChannelMgt->Stop([sdid UTF8String]);
}
-(void)refreshLabelStatus:(NSNumber *)sta{
    
    NSString *strPPPPStatus = nil;
    int status=[sta intValue];
    //NSLog(@"refreshLabelStatus.....status=%d",status);
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            
            // pChannelMgt->PPPPSetSystemParams((char *)[did UTF8String], MSG_TYPE_GET_STATUS, NULL, 0);
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case  PPPP_STATUS_INVALID_USER_PWD :
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;

        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    
    label_status.text=strPPPPStatus;
    
    if (isLoginBtnPressed) {
        if (status==PPPP_STATUS_ON_LINE) {
            isLoginBtnPressed=NO;
            [self playPPPView];
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)appForegroundNotify{
    NSLog(@"LoginController     appForegroundNotify");
    if (did!=nil) {
        isLoginBtnPressed=NO;
        label_status.text=@"正在连接...";
        [self startPPPPThread];
    }
    
}
@end
