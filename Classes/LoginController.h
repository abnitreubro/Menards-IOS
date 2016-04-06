//
//  LoginController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "SearchAddCameraInfoProtocol.h"
#import "PPPPStatusProtocol.h"
#import "AppEnterForegroundProtocol.h"
#import "PicPathManagement.h"
#import "RecPathManagement.h"
#import "CameraListMgt.h"
@interface LoginController : UIViewController<UITextFieldDelegate,SearchAddCameraInfoProtocol,PPPPStatusProtocol,AppEnterForegroundProtocol>{
    IBOutlet UIButton *btn_login;
    IBOutlet UIButton *btn_search;
    IBOutlet UIButton *btn_scanbarcode;
    IBOutlet UITextField *tf_id;
    IBOutlet UITextField *tf_user;
    IBOutlet UITextField *tf_pwd;
    UILabel *label_status;
    IBOutlet UIView *view;
    IBOutlet UINavigationBar *navigationBar;
    CPPPPChannelManagement *pChannelMgt;
     NSCondition *ppppChannelMgntCondition;
    NSString *user;
    NSString *pwd;
    NSString *did;
    NSString *tmptDid;
     NSString *tmptpwd;
     NSString *tmptuser;
    int status_change;
    
    BOOL isLoginBtnPressed;
    
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    CameraListMgt *m_pCameraListMgt;
}
@property (nonatomic,retain)UILabel *label_status;
@property (nonatomic,retain)IBOutlet UITextField *tf_id;
@property (nonatomic,retain)IBOutlet UITextField *tf_user;
@property (nonatomic,retain)IBOutlet UITextField *tf_pwd;
@property (nonatomic,retain)IBOutlet UIButton *btn_login;
@property (nonatomic,retain)IBOutlet UIButton *btn_search;
@property (nonatomic,retain)IBOutlet UIButton *btn_scanbarcode;
@property (nonatomic,retain) UINavigationBar *navigationBar;
@property (nonatomic,assign) CPPPPChannelManagement *pChannelMgt;
@property (nonatomic,assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic,assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic,assign) CameraListMgt *m_pCameraListMgt;
@end
