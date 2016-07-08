//
//  ShowImageViewController.m
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()<UIScrollViewDelegate>

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollViewImage=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollViewImage.delegate=self;
    
    [self.view addSubview:self.scrollViewImage];
    
    self.scrollViewImage.zoomScale=1.0f;
    self.scrollViewImage.minimumZoomScale=1.0f;
    self.scrollViewImage.maximumZoomScale=4.0f;
   // self.scrollViewImage.contentSize=self.scrollViewImage.frame.size;
    self.scrollViewImage.bounces=YES;
    self.scrollViewImage.bouncesZoom=YES;
    self.scrollViewImage.clipsToBounds = YES;
    //self.scrollViewImage.backgroundColor=[UIColor redColor];
   // self.imageVIew.frame=CGRectMake(0, 0, self.scrollViewImage.frame.size.width, self.scrollViewImage.frame.size.height);
    
    imageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollViewImage.frame.size.width, 200)];
    imageVIew.center=self.scrollViewImage.center;
    [self.scrollViewImage addSubview:imageVIew];
    imageVIew.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:self.strImagePath]];
    //imageVIew.contentMode=UIViewContentModeScaleAspectFit;
    //self.scrollViewImage.contentSize=CGSizeMake(imageVIew.frame.size.width, imageVIew.frame.size.height);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonAction:)] ;
    

    
    self.navigationItem.rightBarButtonItems = @[shareBtn];
    
}

-(void)shareButtonAction:(id)sender{
    
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    
    
    
    NSString *postText = [[NSString alloc] initWithFormat:@"%@ ",[self.strImagePath lastPathComponent] ];
    
    if (postText) {
        [sharingItems addObject:postText];
    }
        [sharingItems addObject:imageVIew.image];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    // NSArray *excludedActivities = @[
    //                                    UIActivityTypePrint,
    //                                    UIActivityTypeCopyToPasteboard,
    //                                    UIActivityTypeAssignToContact,
    //                                    UIActivityTypeSaveToCameraRoll,
    //                                    UIActivityTypeAddToReadingList,
    //                                    UIActivityTypePostToFlickr,
    //                                    UIActivityTypePostToVimeo,
    //                                    UIActivityTypePostToTencentWeibo,
    //                                    UIActivityTypeAirDrop];
    // activityController.excludedActivityTypes = excludedActivities;
    
    [self presentViewController: activityViewController animated:YES completion:nil];
    
    
    
}
- (void) hideShowNavigation
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{

    return imageVIew;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}


- (void)centerScrollViewContents {
    // This method centers the scroll view contents also used on did zoom
    CGSize boundsSize = self.scrollViewImage.bounds.size;
    CGRect contentsFrame = imageVIew.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageVIew.frame = contentsFrame;
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

@end
