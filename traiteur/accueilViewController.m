//
//  accueilViewController.m
//  traiteur
//
//  Created by Antony on 17/11/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "accueilViewController.h"

#import "UIColor+HexValue.h"
#import "PPPinPadViewController.h"

@interface accueilViewController (){
    int isOk;
    PPPinPadViewController * pinViewController;
}

@end

@implementation accueilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOk = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pinPadDidHide{
if(isOk==1)[_validOK sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)pinPadSuccessPin; {
    isOk=1;
}

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
    //
}

- (NSInteger)pinLenght {
    return 4;
}

- (IBAction)affPad:(id)sender {
    pinViewController = [[PPPinPadViewController alloc] init];
    pinViewController.delegate = self;
    pinViewController.pinTitle = @"Entrez votre code";
    pinViewController.errorTitle = @"Code incorrect";
    pinViewController.cancelButtonHidden = NO; //default is False
    pinViewController.backgroundImage = [UIImage imageNamed:@"pinViewImage"]; //if you need remove the background set a empty UIImage ([UIImage new]) or set a background color
    //    pinViewController.backgroundColor = [UIColor blueColor]; //default is a darkGrayColor
    
    [self presentViewController:pinViewController animated:YES completion:NULL];

}


@end
