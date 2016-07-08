//
//  MoreViewController.m
//  VideoScope
//
//  Created by reubro on 04/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "MoreViewController.h"
#import "Constant.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISRECORDAUDIO]intValue]==1) {
        self.recordAudioSwitch.on=YES;
    }
    else
    self.recordAudioSwitch.on=NO;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:RECORDINGTIME]intValue]>0) {
        self.lblRecordingTime.text=[NSString stringWithFormat:@"Record: %@ min",[[NSUserDefaults standardUserDefaults]objectForKey:RECORDINGTIME]];
        self.recordingTimeStepper.value=[[[NSUserDefaults standardUserDefaults]objectForKey:RECORDINGTIME]doubleValue];
    }
    else{
        self.lblRecordingTime.text=[NSString stringWithFormat:@"Record: 1 min"];
        self.recordingTimeStepper.value=1.0;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 2;
    }
    else if(section== 1){
        
        return 1;
    }
    else if(section==2){
        
        return 1;
        
    }
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    AboutViewController *about = segue.destinationViewController;
//    about.hidesBottomBarWhenPushed=YES;

   // segue.destinationViewController.hidesBottomBarWhenPushed=YES;
}

#pragma mark- Actions from View
- (IBAction)actionRecordingTimeStepper:(UIStepper*)sender {
    
    self.lblRecordingTime.text=[NSString stringWithFormat:@"Record: %d min",(int)sender.value];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",(int)sender.value] forKey:RECORDINGTIME];
    
}

- (IBAction)actionRecordSwitch:(UISwitch*)sender {
    
    if ([sender isOn]) {
        
       /// NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:ISRECORDAUDIO];
    } else{
       // NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:ISRECORDAUDIO];

    }

}
@end