//
//  DisplayFileListViewController.m
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "DisplayFileListViewController.h"

@interface DisplayFileListViewController (){
    
    
    NSMutableArray *allContentInFolder;
    UIBarButtonItem*deleteBtn;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;

    BOOL isEditing;
    
    NSMutableArray * arrayTodelete,*indexArrayTodelete;
    
}

@end

@implementation DisplayFileListViewController

static NSString * const reuseIdentifier = @"FileList";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editDoneButonAction:)] ;
    
    self.navigationItem.rightBarButtonItems = @[editButton];
    
    
    
    
    [self.navigationItem setTitle:self.cameraDetail.name];
    NSError*error=nil;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.cameraDetail.imageFolder]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Will Create folder

    allContentInFolder=[[NSMutableArray alloc]init];
    arrayTodelete=[[NSMutableArray alloc]init];
    indexArrayTodelete=[[NSMutableArray alloc]init];

    [allContentInFolder addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL]];
    
    NSLog(@"All Content in Selectted foleder is %@",allContentInFolder);
    
}

#pragma mark- UIBarButtonItem button Action

-(void)editDoneButonAction:(id)sender{
    
    if (isEditing) {
        
        editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editDoneButonAction:)] ;
        
        self.navigationItem.rightBarButtonItems = @[editButton];
        

        isEditing=NO;
        [arrayTodelete removeAllObjects];
        [indexArrayTodelete removeAllObjects];
        [self makeAllViewEditable:NO];
        
    }
    
    else{
        
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDoneButonAction:)] ;
        
        
        deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButonAction:)] ;
        deleteBtn.enabled=NO;
        self.navigationItem.rightBarButtonItems = @[doneButton,deleteBtn];
        isEditing=YES;
        [self makeAllViewEditable:YES];
    }
}
-(void)deleteButonAction:(id)sender{

    UIActionSheet *actionSheet= [[UIActionSheet alloc]initWithTitle:@"Are you sure to delete?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Confirm" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self.view];

}

-(void)makeAllViewEditable:(BOOL)editable{
    
    if (editable) {
        for (int i=0; i<allContentInFolder.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            DisplayFileListCollectionViewCell *cell=[self.FileListCollectionView cellForItemAtIndexPath:indexPath];
            
            cell.ButtonSelected.hidden=NO;
            cell.ButtonSelected.image=[UIImage imageNamed:@"disSelect.png"];

        }
        
        
        
    }
    else{
        
        for (int i=0; i<allContentInFolder.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            DisplayFileListCollectionViewCell *cell=[self.FileListCollectionView cellForItemAtIndexPath:indexPath];
            
            cell.ButtonSelected.hidden=YES;
            cell.ButtonSelected.image=[UIImage imageNamed:@"disSelect.png"];
            
        }
        
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return allContentInFolder.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DisplayFileListCollectionViewCell *cell = [self.FileListCollectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
   // cell.backgroundColor=[UIColor redColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.cameraDetail.imageFolder]];
    NSString *savedImagePath = [dataPath stringByAppendingPathComponent:[allContentInFolder objectAtIndex:indexPath.item]];
    
    
    NSString *filePathExtenstion = [savedImagePath pathExtension];
    
   // NSLog(@"filePathExtenstion is %@",filePathExtenstion);
    
    if ([filePathExtenstion caseInsensitiveCompare:@"jpg"] == NSOrderedSame || [filePathExtenstion caseInsensitiveCompare:@"jpeg"] == NSOrderedSame|| [filePathExtenstion caseInsensitiveCompare:@"png"] == NSOrderedSame ||[filePathExtenstion caseInsensitiveCompare:@"gif"] == NSOrderedSame) {
        
        cell.ThumbNailImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:savedImagePath]];
        cell.imagePlayButton.hidden=YES;
        
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:savedImagePath error:nil] fileSize];
        float fileSizeKB = fileSize/1024;
        
        cell.lblDurationSize.text=[NSString stringWithFormat:@"%0.1f M",fileSizeKB/1024];

    }
    else{
        cell.imagePlayButton.hidden=NO;
        NSURL * url = [NSURL fileURLWithPath: savedImagePath];
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 1);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];

        cell.ThumbNailImageView.image=one;
            
        
        AVURLAsset *avUrl = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:savedImagePath]];
        CMTime timeTemp = [avUrl duration];
        int seconds = ceil(timeTemp.value/timeTemp.timescale);

        cell.lblDurationSize.text=[self formattedTime:seconds];
        
    }
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:savedImagePath error:nil];

    if (attrs != nil) {
        
        NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat: @"yyyyMMddHHmmss"];
        [formatter setDateFormat: @"MMM dd, yyyy, hh:mm:ss a"];

        NSString *strDate = [formatter stringFromDate:date]; // Convert date to string

        
        cell.dateLable.text=strDate;
        

    }
    
    if (isEditing) {
        cell.ButtonSelected.hidden=NO;
    }
    else
    cell.ButtonSelected.hidden=YES;
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DisplayFileListCollectionViewCell *cell=[self.FileListCollectionView cellForItemAtIndexPath:indexPath];

    if (isEditing) {
        
        if ([arrayTodelete containsObject:[allContentInFolder objectAtIndex:indexPath.row]]) {
            
            [indexArrayTodelete removeObject:indexPath];
            [arrayTodelete removeObject:[allContentInFolder objectAtIndex:indexPath.row]];
            cell.ButtonSelected.image=[UIImage imageNamed:@"disSelect.png"];
        }
        else{
            
            //tkContact_checkBox
            [indexArrayTodelete addObject:indexPath];
            [arrayTodelete addObject:[allContentInFolder objectAtIndex:indexPath.row]];
            cell.ButtonSelected.image=[UIImage imageNamed:@"tkContact_checkBox.png"];
        }
        if (arrayTodelete.count>0) {
            deleteBtn.enabled=YES;
        }
        else
            deleteBtn.enabled=NO;
        
    }
    else{

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.cameraDetail.imageFolder]];
        NSString *savedImagePath = [dataPath stringByAppendingPathComponent:[allContentInFolder objectAtIndex:indexPath.item]];
        
        
        NSString *filePathExtenstion = [savedImagePath pathExtension];
        

        if ([filePathExtenstion caseInsensitiveCompare:@"jpg"] == NSOrderedSame || [filePathExtenstion caseInsensitiveCompare:@"jpeg"] == NSOrderedSame|| [filePathExtenstion caseInsensitiveCompare:@"png"] == NSOrderedSame ||[filePathExtenstion caseInsensitiveCompare:@"gif"] == NSOrderedSame) {
            
            UIStoryboard * storyVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ShowImageViewController * showImageViewController = (ShowImageViewController *)[storyVC instantiateViewControllerWithIdentifier:@"ShowImageViewController"];
            showImageViewController.strImagePath=savedImagePath;
            
            [self.navigationController pushViewController:showImageViewController animated:YES];

            
        }
        
        else {
            
            UIStoryboard * storyVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PlayRecordedVideoViewController * playRecordedVideoViewController = (PlayRecordedVideoViewController *)[storyVC instantiateViewControllerWithIdentifier:@"PlayRecordedVideoViewController"];
            playRecordedVideoViewController.strVideoPath=savedImagePath;
            [self.navigationController pushViewController:playRecordedVideoViewController animated:YES];

            
        }


    }
    
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

//
//-(UIImageView*)getThumbnailImage :(NSString*)urlString{
//
//    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:urlString] options:nil];
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generator.appliesPreferredTrackTransform=TRUE;
//    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
//    
//    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//        if (result != AVAssetImageGeneratorSucceeded) {
//            NSLog(@"couldn't generate thumbnail, error:%@", error);
//        }
//        UIImage *thumbImg = [UIImage imageWithCGImage:im];
//        NSLog(@"%@", thumbImg);
//        
//        self.imgvwThumb.image = thumbImg;
//        
//    };
//    return self.imgvwThumb;
//    
//}

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld",(long)buttonIndex);
    
    if (buttonIndex==0) {
        
        

        for (NSString *itemname in arrayTodelete) {
            
            NSError *error;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.cameraDetail.imageFolder]];
            NSString *savedImagePath = [dataPath stringByAppendingPathComponent:itemname];

            
            [[NSFileManager defaultManager] removeItemAtPath:savedImagePath error:&error]; //Will delete file
            
            if (!error) {
                
                [allContentInFolder removeObject:itemname];

                }
            else{
                
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        
        [self.FileListCollectionView deleteItemsAtIndexPaths:indexArrayTodelete];
        [self editDoneButonAction:nil];

        
    }
    
}

#pragma mark- Time formatting

- (NSString *)formattedTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours==0) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

    }
else
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}



@end
