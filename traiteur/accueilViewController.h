//
//  accueilViewController.h
//  traiteur
//
//  Created by Antony on 17/11/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCircleButton.h"






@interface accueilViewController : UIViewController

- (IBAction)affPad:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *validOK;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet PPCircleButton *ini1;
@property (weak, nonatomic) IBOutlet PPCircleButton *ini2;
@property (weak, nonatomic) NSTimer * myTimer;

- (IBAction)padClick:(id)sender;
- (IBAction)delchar:(id)sender;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *popupView;
- (IBAction)hidePass:(id)sender;
- (IBAction)validBt:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *majLoaderView;
@property (weak, nonatomic) IBOutlet UILabel *nbUpdFiles;
@property (weak, nonatomic) IBOutlet UILabel *nommag;
@property (weak, nonatomic) IBOutlet UILabel *nomcata;
@property (weak, nonatomic) IBOutlet UIView *configView;
- (IBAction)hideConfig:(id)sender;

@end
