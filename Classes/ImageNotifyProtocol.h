//
//  ImageNotifyProtocol.h
//  P2PCamera
//
//  Created by mac on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageNotifyProtocol <NSObject>

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp StreamID:(int)streamID;
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp StreamID:(int)streamID;
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp;

@end
