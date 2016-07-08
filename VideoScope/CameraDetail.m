//
//  CameraDetail.m
//  VideoScope
//
//  Created by Philip Abraham on 06/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "CameraDetail.h"

@implementation CameraDetail

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self.cameraName becomeFirstResponder];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction)];
    
    [self setManagedObjectContext:[AppDelegate instance].managedObjectContext];

    if (self.iSEditingDetail) {
        
        [self getCameraList];
    }
    else{
        
        
    }
}


// Button Action to handle done action from right Bar Button

-(void)doneButtonAction{
    
    if (self.cameraName.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter Camera name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (self.cameraUrl.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter Camera Url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    if (self.iSEditingDetail) {
        
        camera.name=self.cameraName.text;
        camera.url=self.cameraUrl.text;
        NSError*error;

        if (![camera.managedObjectContext save:&error]) {
            
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@,%@",error,error.localizedDescription);
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [errorAlert performSelector:@selector(show) withObject:nil];
            return;
            
        }
        else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        

        
    }
    else{
        [self addCameraNameURL];
        
    }

    
}

#pragma Core Data Communication

// Setting default camera name and URL for Steelman pro VideoScope
-(void)addCameraNameURL{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Camera" inManagedObjectContext:self.managedObjectContext];
    NSError*error=nil;
    
    Camera *camera1 = [[Camera alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    camera1.name= self.cameraName.text;
    camera1.url=self.cameraUrl.text;
    camera1.date=[NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMddHHmmss"];
    
    NSString *strDate = [formatter stringFromDate:[NSDate date]]; // Convert date to string
    NSLog(@"date :%@",strDate);
    camera1.imageFolder=strDate;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",strDate]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Will Create folder
    
    if (![camera1.managedObjectContext save:&error]) {
        
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@,%@",error,error.localizedDescription);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [errorAlert performSelector:@selector(show) withObject:nil];
        return;
        
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
    
    
}

// Get Camera List from Database

-(void)getCameraList{
    
    // Initialize Fetch Request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Camera" inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    else{
        // maybe some check before, to be sure results is not empty
        if (results) {
            camera = [results objectAtIndex:self.selectedIndexForEditing.row];

            self.cameraName.text=camera.name;
            self.cameraUrl.text=camera.url;
            
            
        }
    }

}
#pragma mark- end



#pragma mark- UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}
@end
