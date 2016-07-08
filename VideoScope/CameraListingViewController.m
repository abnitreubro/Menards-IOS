//
//  CameraListingViewController.m
//  VideoScope
//
//  Created by reubro on 04/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "CameraListingViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "Camera.h"
#import "CameraDetail.h"
#import "CameraPreviewViewController.h"
@interface CameraListingViewController (){
    
    NSMutableArray *H_allValueInDataBase;
    
}

@end

@implementation CameraListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCameraDetail)];
    
    
    [self setManagedObjectContext:[AppDelegate instance].managedObjectContext];
    
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:ISFIRSTTIME]) {
        
        [self setDefaultCameraNameURL];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:ISFIRSTTIME];
        
    }
    else{
        
        [self getCameraList];
    }

}


#pragma mark- Button Action

// Button Action for right Bar Button for adding new camera

-(void)addNewCameraDetail{
    CameraDetail *cameraDetail = [[AppDelegate instance].appStoryboard instantiateViewControllerWithIdentifier:@"CameraDetail"];
    [self.navigationController pushViewController:cameraDetail animated:YES];

}



#pragma Core Data Communication

// Setting default camera name and URL for Steelman pro VideoScope
-(void)setDefaultCameraNameURL{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Camera" inManagedObjectContext:self.managedObjectContext];
    NSError*error=nil;
    
    Camera *camera = [[Camera alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    camera.name= @"Steelman PRO Video Scope";
    camera.url=@"http://192.168.1.1:8080/?action=stream";
    camera.date=[NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMddHHmmss"];
    
    NSString *strDate = [formatter stringFromDate:[NSDate date]]; // Convert date to string
    NSLog(@"date :%@",strDate);
    camera.imageFolder=strDate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",strDate]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Will Create folder

    
    if (![camera.managedObjectContext save:&error]) {
        
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@,%@",error,error.localizedDescription);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [errorAlert performSelector:@selector(show) withObject:nil];
        return;
        
    }
    else{
        
        [self getCameraList];

        
    }

    
    
}


// Get Camera List from Database

-(void)getCameraList{
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Camera"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else{
        
        NSArray *fetchedResult = [self.fetchedResultsController fetchedObjects];
        H_allValueInDataBase = [[NSMutableArray alloc]init];
        
// Create Folder as per number of Camera in document directory for saving images under camera name
        for (Camera *camera in fetchedResult) {
            
//            NSMutableDictionary * H_allCameraData= [[NSMutableDictionary alloc]init];
//            [H_allCameraData setObject:camera.name forKey:@"name"];
//            [H_allCameraData setObject:camera.url forKey:@"url"];
            
            
            [H_allValueInDataBase addObject:camera];
            
        }
       // NSLog(@"All saved Data in database is %@",H_allValueInDataBase);
        
        [self.tableView reloadData];

    }
    
}
#pragma mark- end
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return H_allValueInDataBase.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CameraList" forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    Camera *camera=[H_allValueInDataBase objectAtIndex:indexPath.row];
    cell.textLabel.text=camera.name;
    
    // Configure the cell...
    
    return cell;
}



// UITableViewCell Accessory Button Action delegate method

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    CameraDetail *cameraDetail = [[AppDelegate instance].appStoryboard instantiateViewControllerWithIdentifier:@"CameraDetail"];
    cameraDetail.selectedIndexForEditing=indexPath;
    cameraDetail.iSEditingDetail=YES;
    [self.navigationController pushViewController:cameraDetail animated:YES];

    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return indexPath.row > 0;
;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSError*error=nil;
        Camera *camera=[H_allValueInDataBase objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",camera.imageFolder]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
            [[NSFileManager defaultManager] removeItemAtPath:dataPath error:&error]; //Will delete folder

        
        [H_allValueInDataBase removeObjectAtIndex:indexPath.row];

        [self.managedObjectContext deleteObject:camera];

        error=nil;
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@,%@",error,error.localizedDescription);
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [errorAlert performSelector:@selector(show) withObject:nil];
            return;
            
        }

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark- NSFetchedResultsControllerDelegate Implementation

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    

    
            UITableView *tableView = self.tableView;
            switch(type) {
                    
                case NSFetchedResultsChangeInsert:
                    [H_allValueInDataBase addObject:anObject];
                    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    //[H_allValueInDataBase removeObjectAtIndex:indexPath.row];
                   // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeUpdate:
                    [H_allValueInDataBase replaceObjectAtIndex:indexPath.row withObject:anObject];
                    
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                    
                case NSFetchedResultsChangeMove:
                    [tableView deleteRowsAtIndexPaths:[NSArray
                                                       arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView insertRowsAtIndexPaths:[NSArray
                                                       arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
            }
    
    
}
#pragma mark- end



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CameraPreviewViewController *cameraPreviewViewController = segue.destinationViewController;
    cameraPreviewViewController.hidesBottomBarWhenPushed=YES;
    cameraPreviewViewController.cameraDetail=[H_allValueInDataBase objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
}


@end
