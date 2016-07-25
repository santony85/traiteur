//
//  lstCommandeCell.h
//  traiteur
//
//  Created by Antony on 13/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APRoundedButton.h"

@interface lstCommandeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *qte;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *pu;
@property (strong, nonatomic) IBOutlet UILabel *ptot;
@property (strong, nonatomic) IBOutlet UIButton *delBut;
@property (strong, nonatomic) IBOutlet UILabel *commentaire;
@property (weak, nonatomic) IBOutlet UIButton *btQte;
@property (weak, nonatomic) IBOutlet UIButton *btCom;

@end
