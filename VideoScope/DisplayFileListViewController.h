//
//  DisplayFileListViewController.h
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"
#import "DisplayFileListCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ShowImageViewController.h"
#import "PlayRecordedVideoViewController.h"
@interface DisplayFileListViewController : UICollectionViewController<UIActionSheetDelegate>
@property (atomic, strong)Camera *cameraDetail;
@property (strong, nonatomic) IBOutlet UICollectionView *FileListCollectionView;
@property UIImageView *imgvwThumb;

@end
