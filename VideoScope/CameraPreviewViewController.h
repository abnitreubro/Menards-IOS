//
//  CameraPreviewViewController.h
//  VideoScope
//
//  Created by reubro on 07/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraPreviewViewController : UIViewController<AVPlayerViewControllerDelegate,AVAudioRecorderDelegate,UIScrollViewDelegate>{
    AVPlayer * liveVideoPlayer;
    
    AVPlayerItem *playerItem;
    
    BOOL isRecording;
    

    //video writing
    
    
    NSMutableArray *numberOfScreenshots;
    
    NSURL *AudioURl, *VideoURL;
    
    CFAbsoluteTime      _timeOfFirstFrame;
    NSTimer*recordingTimerVideo;
    
    
//    AVAssetWriter *videoWriter;
//    AVAssetWriterInput *videoWriterInput;
//    AVAssetWriterInputPixelBufferAdaptor *avAdaptor;

    NSDate* startedAt;
    BOOL isProcessing;
    
    //  AVAudioRecorder
    
    AVAudioRecorder *recorder;
    
    
    
}
@property (nonatomic) IBOutlet UIImageView *imageViewToDisplayLive;
@property (atomic, strong)Camera *cameraDetail;
@property (nonatomic, strong) MPMoviePlayerController *videoController;
@property (nonatomic,strong) NSMutableData *receivedData;

@property (weak, nonatomic) IBOutlet UIView *bottomButtonView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *imageScrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordingTime;
@property (weak, nonatomic) IBOutlet UIView *viewRecordingTime;


- (IBAction)actionResetButton:(id)sender;
- (IBAction)actionZoomIn:(id)sender;
- (IBAction)actionZoomOut:(id)sender;
- (IBAction)actionLeftRtate:(id)sender;
- (IBAction)actionRightRotate:(id)sender;
- (IBAction)moveImage:(UIPanGestureRecognizer*)recognizer;

@end
