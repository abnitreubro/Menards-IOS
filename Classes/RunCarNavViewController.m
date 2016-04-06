//
//  RunCarNavViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-19.
//
//

#import "RunCarNavViewController.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
#import "RemoteRecordFileListViewController.h"
#import "SettingViewController.h"

@interface RunCarNavViewController ()

@end

@implementation RunCarNavViewController
@synthesize btn_preview;
@synthesize btn_recordvideo;
@synthesize btn_udisc;
@synthesize acIndicatorView;
@synthesize navigationBar;
@synthesize label_mode;
@synthesize label_status;
@synthesize label_pre;
@synthesize label_rec;
@synthesize label_udi;
@synthesize did;
@synthesize user;
@synthesize pwd;
@synthesize pChannelMgt;
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
    NSLog(@"RunCar viewDidLoad");
    [super viewDidLoad];
    timeout=15;
  
    CGRect rx=[UIScreen mainScreen].bounds;
    NSInteger screenWidth=rx.size.width;
    
        UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    navigationBar=[[UINavigationBar alloc]init];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.frame=CGRectMake(0.0f, 0.0f, screenWidth, 42.0f);
    self.navigationBar.delegate=self;

    UINavigationItem *backItem=[[UINavigationItem alloc]initWithTitle:@"返回"];
    UINavigationItem *navItem=[[UINavigationItem alloc]initWithTitle:NSLocalizedStringFromTable(@"runcar_title", @STR_LOCALIZED_FILE_NAME, nil)];
    UIBarButtonItem *btnBack=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(btnBack)];
    //navItem.leftBarButtonItem=btnBack;
    [btnBack release];
    NSArray *array=[NSArray arrayWithObjects:backItem,navItem, nil];
    [navigationBar setItems:array];
    [navItem release];
    //[backItem release];
    [self.view addSubview:navigationBar];
    
    label_mode=[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 60.0f, screenWidth, 40.0f)];
    label_mode.textAlignment=UITextAlignmentCenter;
    label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_default", @STR_LOCALIZED_FILE_NAME, nil);
    label_mode.textColor=[UIColor blueColor];
    [self.view addSubview:label_mode];
    
    btn_recordvideo=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_recordvideo.frame=CGRectMake(100.0f, 280.0f, 120.0f, 60.0f);
    [btn_recordvideo setTitle:NSLocalizedStringFromTable(@"runcar_sys_setting", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
   
    [btn_recordvideo addTarget:self action:@selector(btnVideoMode) forControlEvents:UIControlEventTouchUpInside];
    [btn_recordvideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
	btn_preview=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_preview.frame=CGRectMake(100.0f, 120.0f, 120.0f, 60.0f);
    [btn_preview setTitle:NSLocalizedStringFromTable(@"runcar_mode_preview", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn_preview addTarget:self action:@selector(btnPreviewMode) forControlEvents:UIControlEventTouchUpInside];
    [btn_preview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    
    
    btn_udisc=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_udisc.frame=CGRectMake(100.0f, 200.0f,120.0f, 60.0f);
    [btn_udisc setTitle:NSLocalizedStringFromTable(@"runcar_mode_uplate", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn_udisc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_udisc addTarget:self action:@selector(btnUPlateMode) forControlEvents:UIControlEventTouchUpInside];
   
    
    label_status=[[UILabel alloc]initWithFrame:CGRectMake(100.0f, 360.0f, 120.0f, 60.0f)];
    label_status.text=NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
    label_status.textAlignment=UITextAlignmentCenter;
    label_status.textColor=[UIColor blueColor];
    
    [self.view addSubview:btn_preview];
    [self.view addSubview:btn_udisc];
    [self.view addSubview:btn_recordvideo];
    [self.view addSubview:label_status];
    

   // NSLog(@"user =%@ did=%@ pwd=%@",user,did,pwd);
    pChannelMgt->pCameraViewController = self;
   
    [self startPPPPThread];
   
}
-(void)btnBack{
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
    pChannelMgt->Stop([did UTF8String]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnVideoMode{
   // NSLog(@"btnVideoMode");
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
    
    
    if(mstatus==PPPP_STATUS_ON_LINE){
        
        //跳转画面
        SettingViewController *settingView = [[SettingViewController alloc] init];
        settingView.m_pPPPPChannelMgt = pChannelMgt;
        settingView.m_strDID = did;
        [self.navigationController pushViewController:settingView animated:YES];
        [settingView release];
        return;
    }
    if(mstatus==PPPP_STATUS_INVALID_ID){
        return;
    }
   
    
    //去连接设备
    [self startPPPPThread];
     
}

-(void)btnPreviewMode{
   // NSLog(@"btnPreviewMode ");
    if(mstatus==PPPP_STATUS_ON_LINE){
        
        pChannelMgt->CameraControl([did UTF8String], 200, 1);
        timeout=15;
        label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_preview", @STR_LOCALIZED_FILE_NAME, nil);
        label_mode.textColor=[UIColor blueColor];
        
        [btn_preview setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn_udisc setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_udisc setEnabled:NO];
        [btn_recordvideo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_recordvideo setEnabled:NO];
        if (timer!=nil) {
            [timer invalidate];
            timer=nil;
        }
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(preview) userInfo:nil repeats:YES];
        return;
    }
    if(mstatus==PPPP_STATUS_INVALID_ID){
        return;
    }
    
   
    //去连接设备
   [self startPPPPThread];
     
}

-(void)preview{
    label_mode.text=[NSString stringWithFormat:@"%@ %d",NSLocalizedStringFromTable(@"runcar_entering_preview_mode", @STR_LOCALIZED_FILE_NAME, nil),timeout];
    timeout--;
   
    NSLog(@"timeout=%d",timeout);
    if (timeout==0) {
        NSLog(@"111111   timeout=%d",timeout);
        timeout=15;
        [btn_udisc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_udisc setEnabled:YES];
        [btn_recordvideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_recordvideo setEnabled:YES];
        label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_preview", @STR_LOCALIZED_FILE_NAME, nil);
        label_mode.textColor=[UIColor blueColor];
        //跳转画面
        [timer invalidate];
        timer=nil;
        
        [self playPPPView:did Param:2] ;
        return;
    }
       
}

-(void)btnUPlateMode{
    //NSLog(@"btnUPlateMode ");
    if(mstatus==PPPP_STATUS_ON_LINE){
        //跳转画面
         pChannelMgt->CameraControl([did UTF8String], 200, 2);
        timeout=15;
        label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_uplate", @STR_LOCALIZED_FILE_NAME, nil);
        label_mode.textColor=[UIColor blueColor];
        [btn_udisc setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn_preview setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_preview setEnabled:NO];
        [btn_recordvideo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_recordvideo setEnabled:NO];
        if (timer!=nil) {
            [timer invalidate];
            timer=nil;
        }
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uplate) userInfo:nil repeats:YES];
        
        
        return;
    }
    if(mstatus==PPPP_STATUS_INVALID_ID){
        return;
    }
    //去连接设备
    [self startPPPPThread];
    
     
}
-(void)uplate{
   label_mode.text=[NSString stringWithFormat:@"%@ %d",NSLocalizedStringFromTable(@"runcar_entering_uplate_mode", @STR_LOCALIZED_FILE_NAME, nil),timeout];
    timeout--;
    if (timeout==0) {
        label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_uplate", @STR_LOCALIZED_FILE_NAME, nil);
        label_mode.textColor=[UIColor blueColor];
        timeout=15;
        [timer invalidate];
        timer=nil;
        [btn_preview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_preview setEnabled:YES];
        [btn_recordvideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_recordvideo setEnabled:YES];
        
        RemoteRecordFileListViewController *remoteFileView = [[RemoteRecordFileListViewController alloc] init];
        remoteFileView.m_pPPPPChannelMgt =pChannelMgt;
        remoteFileView.m_strName = @"ipcam";
        remoteFileView.m_strDID = did;
        [self.navigationController pushViewController:remoteFileView animated:YES];
        [self.navigationController setNavigationBarHidden:YES];
        [remoteFileView release];
    }
}

-(void)playPPPView:(NSString *)strDiD Param:(NSInteger) param{
    IpCameraClientAppDelegate *ipClientAppDlg=[[UIApplication sharedApplication]delegate];
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.m_pPPPPChannelMgt=pChannelMgt;
    playViewController.strDID = did;
    NSLog(@"did =%@",did);
    playViewController.cameraName = @"IpCam";
    playViewController.m_nP2PMode = 1;
    [ipClientAppDlg switchPlayView:playViewController];
    [playViewController release];

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
-(void)stopPPPPByDID:(NSString *)did{

}
-(void)refreshLabelStatus{
  
    NSString *strPPPPStatus = nil;
    switch (mstatus) {
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
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    
    label_status.text=strPPPPStatus;
  
}
-(void)refreshCameraMode:(NSString *)mode{
    NSLog(@"mode=%@",mode);
    int mod=[mode intValue];
    switch (mod) {
        case 0:
            label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_default", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 1:
            label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_preview", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 2:
            label_mode.text=NSLocalizedStringFromTable(@"runcar_mode_uplate", @STR_LOCALIZED_FILE_NAME, nil);
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark  RunCarProtocol
-(void)runcarModeResult:(NSString *)sdid Mode:(int)mode{
    NSLog(@"runCarModeResult did=%@  mode=%d",sdid,mode);
    NSString *m=[NSString stringWithFormat:@"%d",mode];
    [self performSelectorOnMainThread:@selector(refreshCameraMode:) withObject:m waitUntilDone:NO];
    //[self refreshCameraMode:mode];
}

#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    
    NSLog(@"PPPPStatus() strDID:%@",strDID);
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        //先刷新状态
        
        mstatus=status;
        
        [self performSelectorOnMainThread:@selector(refreshLabelStatus) withObject:nil waitUntilDone:NO];
        
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED) {
            [self performSelectorOnMainThread:@selector(stopPPPPByDID:) withObject:strDID waitUntilDone:NO];
            return;
        }

        
        return;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
   // [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"viewDidAppear======");
    if (mstatus==PPPP_STATUS_ON_LINE) {
          NSLog(@"appear getCameraStatus");
       pChannelMgt->PPPPSetSystemParams((char *)[did UTF8String], MSG_TYPE_GET_STATUS, NULL, 0);
    }
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:nil name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
   // NSLog(@"disappear");
    //pChannelMgt->Stop([did UTF8String]);
}

-(void)dealloc{
    NSLog(@"RunCar  dealloc");
    
    [label_status release];
    label_status = nil;
    [navigationBar release];
    navigationBar=nil;
    [label_mode release];
    label_mode=nil;
    [label_pre release];
    label_pre=nil;
    [label_rec release];
    label_rec=nil;
    [label_udi release];
    label_udi=nil;
    [super dealloc];
    
   
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
    
    return NO;
}

@end
