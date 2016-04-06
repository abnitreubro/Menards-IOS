//
//  AboutViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "obj_common.h"
#import "AboutCell.h"
#import "PPPP_API.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"about"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil)];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"AboutCell";	
    AboutCell *cell =  (AboutCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (anIndexPath.row) {
        case 0:
            cell.labelItem.text = @"Version";
            cell.labelVersion.text = @STR_VERSION_NO;
            break;
        case 1:
        {
            cell.labelItem.text = @"P2P";
            int nP2PVersion = PPPP_GetAPIVersion();     
            
            NSLog(@"nP2PVersion: %d", nP2PVersion);
            NSString *P2PVersion = [NSString stringWithFormat:@"%x.%x.%x.%x",
                                    nP2PVersion>>24, 
                                    (nP2PVersion & 0xffffff) >> 16, 
                                    (nP2PVersion & 0xffff) >> 8,
                                    nP2PVersion & 0xff];
            cell.labelVersion.text = P2PVersion;
        }
            break;
        case 2:
            cell.labelItem.text = @"P2PAPI";
            cell.labelVersion.text = @"1.0.0.0";
            break;
            
        default:
            break;
    }

    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   
//}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{


}

@end
