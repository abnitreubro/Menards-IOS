//
//  NavigationController.m
//  P2PCamera
//
//  Created by JS Products on 26/04/16.
//
//

#import "NavigationController.h"

#import <UIKit/UIKit.h>



@interface NavigationController ()

@end

@implementation NavigationController

- (BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

@end


