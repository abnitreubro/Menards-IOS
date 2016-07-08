//
//  DisplayFileListCollectionViewCell.h
//  VideoScope
//
//  Created by reubro on 15/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayFileListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ThumbNailImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIImageView *imagePlayButton;
@property (weak, nonatomic) IBOutlet UIImageView *ButtonSelected;
@property (weak, nonatomic) IBOutlet UILabel *lblDurationSize;

@end
