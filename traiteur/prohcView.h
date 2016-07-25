//
//  prohcView.h
//  traiteur
//
//  Created by Antony on 21/04/2016.
//  Copyright © 2016 planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface prohcView : UIViewController


@property (nonatomic, copy) void (^didDismiss)(NSString *data);
- (IBAction)close:(id)sender;

@end
