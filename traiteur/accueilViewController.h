//
//  accueilViewController.h
//  traiteur
//
//  Created by Antony on 17/11/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPinPadViewController.h"






@interface accueilViewController : UIViewController<PinPadPasswordProtocol>

- (IBAction)affPad:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *validOK;

@end
