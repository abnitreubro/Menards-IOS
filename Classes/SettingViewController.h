//
//  SettingViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>{
    CPPPPChannelManagement *m_pPPPPChannelMgt;
    
    NSString *m_strDID;
    
    IBOutlet UINavigationBar *navigationBar;
    
}

@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (copy, nonatomic) NSString *m_strDID;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
