//
//  AppDelegate.h
//  VideoScope
//
//  Created by reubro on 04/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIStoryboard *appStoryboard;

@property (nonatomic, strong)NSManagedObjectContext*managedObjectContext;
@property (nonatomic, strong)NSManagedObjectModel*managedObjectModel;
@property (nonatomic, strong)NSPersistentStoreCoordinator*persistentStoreCoordinator;

+(AppDelegate *)instance;

@end

