//
//  RunCarNavViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "PPPPStatusProtocol.h"

@interface RunCarNavViewController : UIViewController<PPPPStatusProtocol, UINavigationBarDelegate,RunCarModeProtocol>{
    NSString *did;
    NSString *user;
    NSString *pwd;
    NSInteger mstatus;
    IBOutlet UIButton *btn_preview;
    IBOutlet UIButton *btn_udisc;
    IBOutlet UIButton *btn_recordvideo;
    IBOutlet UILabel *label_status;
    IBOutlet UILabel *label_mode;
    IBOutlet UILabel *label_pre;
    IBOutlet UILabel *label_udi;
    IBOutlet UILabel *label_rec;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIActivityIndicatorView *acIndicatorView;
    CPPPPChannelManagement *pChannelMgt;
    NSCondition *ppppChannelMgntCondition;
    NSTimer *timer;
    NSInteger timeout;
    
}
@property (nonatomic ,retain)IBOutlet UIButton *btn_preview;
@property (nonatomic ,retain)IBOutlet UIButton *btn_udisc;
@property (nonatomic ,retain)IBOutlet UIButton *btn_recordvideo;
@property (nonatomic ,retain)IBOutlet UILabel *label_status;
@property (nonatomic,retain) IBOutlet UILabel *label_mode;
@property (nonatomic,retain) IBOutlet UILabel *label_pre;
@property (nonatomic,retain) IBOutlet UILabel *label_udi;
@property (nonatomic,retain) IBOutlet UILabel *label_rec;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic ,retain)IBOutlet UIActivityIndicatorView *acIndicatorView;
@property (nonatomic,assign)CPPPPChannelManagement *pChannelMgt;
@property (nonatomic,copy)NSString *did;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *pwd;


@end
