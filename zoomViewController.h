//
//  zoomViewController.h
//  traiteur
//
//  Created by Antony on 31/03/2016.
//  Copyright © 2016 planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zoomViewController : UIViewController


- (IBAction)affImg:(NSString *)image;
@property (weak, nonatomic) IBOutlet UIImageView *zoomImg;


@end
