//
//  categorieViewCell.m
//  traiteur
//
//  Created by 2B on 17/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "categorieViewCell.h"

@implementation categorieViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
