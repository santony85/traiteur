//
//  prohcView.m
//  traiteur
//
//  Created by Antony on 21/04/2016.
//  Copyright © 2016 planb. All rights reserved.
//

#import "prohcView.h"




@interface prohcView ()

@end

@implementation prohcView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.didDismiss)
        self.didDismiss(@"some extra data");
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
