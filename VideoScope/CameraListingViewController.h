//
//  CameraListingViewController.h
//  VideoScope
//
//  Created by reubro on 04/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Camera.h"
@interface CameraListingViewController : UITableViewController<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)NSFetchedResultsController*fetchedResultsController;

@end
