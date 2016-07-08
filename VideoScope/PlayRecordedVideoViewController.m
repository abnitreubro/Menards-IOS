//
//  PlayRecordedVideoViewController.m
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "PlayRecordedVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KSVideoPlayerView.h"

@interface PlayRecordedVideoViewController (){
//    AVPlayerItem*avPlayerItem;
//    AVPlayer*videoPlayer;
//    AVPlayerLayer *avPlayerLayer;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) KSVideoPlayerView* player;
@end

@implementation PlayRecordedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url=[NSURL fileURLWithPath:_strVideoPath];
//    _moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
//    _moviePlayer.backgroundView.backgroundColor=[UIColor whiteColor];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
//    _moviePlayer.controlStyle=MPMovieControlStyleDefault;
//    [_moviePlayer prepareToPlay];
//    _moviePlayer.view.frame=self.view.frame;
//    _moviePlayer.shouldAutoplay=YES;
//    [self.view addSubview:_moviePlayer.view];
//    [_moviePlayer setFullscreen:YES animated:YES];
//    [_moviePlayer play];
//    [_moviePlayer stop];
//    

//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
//    AVPlayer* avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
//    
//    avPlayerLayer.frame = self.view.frame;
//    [self.view.layer addSublayer:avPlayerLayer];
//    [avPlayer play];
    
    self.player = [[KSVideoPlayerView alloc] initWithFrame:self.view.frame contentURL:url];
    [self.view addSubview:self.player];
    self.player.tintColor = [UIColor redColor];
    [self.player play];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonAction:)] ;
    
    
    
    self.navigationItem.rightBarButtonItems = @[shareBtn];
    
}

-(void)shareButtonAction:(id)sender{
    
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    
    
    
    NSString *postText = [[NSString alloc] initWithFormat:@"%@ ",[_strVideoPath lastPathComponent] ];
    
    if (postText) {
        [sharingItems addObject:postText];
    }
    NSURL *url=[NSURL fileURLWithPath:_strVideoPath];

    [sharingItems addObject:url];
    
    
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
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
//    MPMoviePlayerController *player = [notification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
//    {
//        [player.view removeFromSuperview];
//    }

    NSLog(@"Movie Playing Finished");
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
