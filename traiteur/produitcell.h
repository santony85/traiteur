//
//  produitcell.h
//  traiteur
//
//  Created by Antony on 06/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"

@interface produitcell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *prix;
@property (strong, nonatomic) IBOutlet UITextField *qte;
@property (strong, nonatomic) IBOutlet BorderButton *addBt;
@property (weak, nonatomic) IBOutlet UIImageView *imgProd;

@end
