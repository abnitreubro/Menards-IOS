//
//  AboutViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UINavigationBar *navigationBar;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
