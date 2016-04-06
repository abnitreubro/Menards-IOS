//
//  UPlateViewController.h
//  P2PCamera
//
//  Created by Tsang on 13-1-21.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "SDCardRecordFileSearchProtocol.h"
@interface UPlateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, SDCardRecordFileSearchProtocol>{
 IBOutlet UINavigationBar *navigationBar;
    NSString *pwd;
    NSString *user;
    NSString *did;
    CPPPPChannelManagement *pChannelMgt;
    UITableView *tableView;
    NSMutableArray *m_RecordFileList;
}
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic,copy)NSString *pwd;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *did;
@property (nonatomic,assign)CPPPPChannelManagement *pChannelMgt;
@property (nonatomic,retain)UITableView *tableView;
@end
