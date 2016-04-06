    //
//  StartViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "obj_common.h"

@implementation StartViewController

@synthesize versionLabel;
@synthesize imgView;

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strVersion = [NSString stringWithFormat:@"Ver %s", STR_VERSION_NO];    
    versionLabel.text = strVersion;
    versionLabel.hidden=YES;
    CGRect mainScreen=[[UIScreen mainScreen]bounds];
   
    imgView.frame=CGRectMake(0,0,mainScreen.size.width,mainScreen.size.height);
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [versionLabel release];
    [imgView release];
    [super dealloc];
}


@end
