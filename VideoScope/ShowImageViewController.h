//
//  ShowImageViewController.h
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController{
    
    UIImageView *imageVIew;
    
}
@property ( nonatomic) IBOutlet UIScrollView *scrollViewImage;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (nonatomic, strong) NSString* strImagePath;

@end
