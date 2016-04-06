//
//  DateTimeController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateTimeController.h"
#import "obj_common.h"
#import "oDropListStruct.h"
#import "oDropController.h"
#import "oLableCell.h"
#import "oSwitchCell.h"



@interface DateTimeController ()

@end
static const double PageViewControllerTextAnimationDuration = 0.33;

@implementation DateTimeController

@synthesize m_strDID;
@synthesize m_pChannelMgt;

@synthesize m_timingSever;

@synthesize dateTime;
@synthesize timeZone;
@synthesize timing;
@synthesize timingServer;

@synthesize tableView;
@synthesize navigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // m_timingSever = @"ssssssss";
    }
    return self;
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetDatetime:(id)sender
{
    m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], 0, m_timeZone, m_Timing, (char*)[m_timingSever UTF8String]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];

    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(btnSetDatetime:)];
    
    item.rightBarButtonItem = rightButton;
   
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];    
    [self.navigationBar setItems:array];
    [rightButton release];
    [item release];
    [back release];
    
    
    m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], self);
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], nil);
}


- (void) dealloc
{
    m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], nil);
    self.m_strDID = nil;
    self.m_pChannelMgt = nil;
    self.m_timingSever = nil;
    self.dateTime = nil;
    self.timing = nil;
    self.timingServer = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"datetime";	
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTime", @STR_LOCALIZED_FILE_NAME, nil);
            
            time_t t = (m_dateTime-m_timeZone)*1000;
            cell.DescriptionLable.text = [NSString stringWithUTF8String:ctime(&t)];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 1: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimezone", @STR_LOCALIZED_FILE_NAME, nil);
            
            
            cell.DescriptionLable.text = [self get_time_zone_des:m_timeZone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            
        }
            break;
        case 2: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTiming", @STR_LOCALIZED_FILE_NAME, nil);
            //[cell.keySwitch setOn:NO];
            [cell.keySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 3: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimingServer", @STR_LOCALIZED_FILE_NAME, nil);
            // cell.textLabel.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);            
            cell.DescriptionLable.text = self.m_timingSever;
            //[cell.textLabel setEnabled: NO];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            break;
        }
        case 4: 
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimeLocal", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionlocal:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
    
	
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
//    [currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 102;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 101;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];    
            [dpView release];
        }
            break;
        default:
            break;
    }
    
}

- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 101) {
        m_timingSever = strDescription;
    }
    if (nType == 102) {
        m_timeZone = nID;
    }
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}
#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    [tableView reloadData];
}

- (NSString *) get_time_zone_des:(int) nID
{
    for (int i=0; i<29; i++) {
        if (time_zone[i].index == nID) {
            return time_zone[i].strTitle;
        }
    }
    return  @"";
}
- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        m_Timing = 1;
    }else {
        m_Timing = 0;
    }
}
- (void)switchActionlocal:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
       //设置时间 
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差

        m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], time(0)/1000, interval, m_Timing, (char*)[m_timingSever UTF8String]);
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) DateTimeProtocolResult:(int)now tz:(int)tz ntp_enable:(int)ntp_enable net_svr:(NSString*)ntp_svr
{
    m_timeZone = tz;
    m_dateTime = now;
    m_Timing = ntp_enable;
    self.m_timingSever = ntp_svr;
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}
@end
