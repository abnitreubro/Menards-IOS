//
//  CameraDetail.h
//  VideoScope
//
//  Created by Philip Abraham on 06/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Camera.h"

@interface CameraDetail : UIViewController{
    
    Camera*camera;
    
}
@property BOOL iSEditingDetail;
@property (weak, nonatomic) IBOutlet UITextField *cameraName;
@property (weak, nonatomic) IBOutlet UITextField *cameraUrl;
@property NSIndexPath *selectedIndexForEditing;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
