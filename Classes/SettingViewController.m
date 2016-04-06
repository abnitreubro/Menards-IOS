//
//  SettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "WifiSettingViewController.h"
#import "CameraViewController.h"
#import "UserPwdSetViewController.h"
#import "AlarmController.h"
#import "DateTimeController.h"
#import "FtpSettingViewController.h"
#import "MailSettingViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize m_pPPPPChannelMgt;
@synthesize m_strDID;
@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didEnterBackground
{
    //NSLog(@"didEnterBackground");
    [self.navigationController popToRootViewControllerAnimated:NO];
}    

- (void)willEnterForeground
{
    //NSLog(@"willEnterForeground");
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    // Do any additional setup after loading the view from its nib.
    NSString *strTitle = NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];

    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];    
    [self.navigationBar setItems:array];
    
    [item release];
    [back release];

    
    //把self添加到NSNotificationCenter的观察者中
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground) 
                                                 name:UIApplicationWillEnterForegroundNotification 
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    m_strDID = nil;
    self.navigationBar = nil;
    self.m_pPPPPChannelMgt = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"SettingCell";	
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell autorelease];
    }
    
    switch (anIndexPath.row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"UserSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;  
        case 2:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;        
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
            cell.textLabel.text = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);  
            break;
        case 4: //ftp setting
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 5: //mail setting
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedStringFromTable(@"MailSetting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            break;
    }
	
	return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //return NSLocalizedStringFromTable(@"Network", @STR_LOCALIZED_FILE_NAME, nil);
//}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    

    
    switch (anIndexPath.row) {
        case 0: //WIFI
        {
            WifiSettingViewController *wifiSettingView = [[WifiSettingViewController alloc] init];
            wifiSettingView.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
            wifiSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:wifiSettingView animated:YES];    
            [wifiSettingView release];
        }
            break;  
        case 1: //用户设置
        {
            UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];
            UserPwdSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            UserPwdSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:UserPwdSettingView animated:YES];    
            [UserPwdSettingView release];
        }
            break;
        case 2: //时间
        {
            DateTimeController *DateTimeSettingView = [[DateTimeController alloc] init];
            DateTimeSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            DateTimeSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:DateTimeSettingView animated:YES];    
            [DateTimeSettingView release];
        }
            break;
        case 3: //报警设置
        {
            AlarmController *AlarmSettingView = [[AlarmController alloc] init];
            AlarmSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            AlarmSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:AlarmSettingView animated:YES];    
            [AlarmSettingView release];
        }
            break;
        case 4: //ftp setting
        {
            FtpSettingViewController *ftpSettingView = [[FtpSettingViewController alloc] init];
            ftpSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            ftpSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:ftpSettingView animated:YES];
            [ftpSettingView release];
        }
            break;
        case 5://mail setting
        {
            MailSettingViewController *mailSettingView = [[MailSettingViewController alloc] init];
            mailSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
            mailSettingView.m_strDID = m_strDID;
            [self.navigationController pushViewController:mailSettingView animated:YES];
            [mailSettingView release];
        }
            break;

        default:
            break;
    }
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}



@end
