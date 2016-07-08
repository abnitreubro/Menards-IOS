//
//  AboutViewController.m
//  VideoScope
//
//  Created by reubro on 31/03/16.
//  Copyright © 2016 Kumar Abnit. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    // Do any additional setup after loading the view.
}


-(void)viewWillLayoutSubviews
{
    [self.view layoutIfNeeded];

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
