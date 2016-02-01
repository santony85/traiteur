//
//  NSFavoris.h
//  catalogue
//
//  Created by 2B on 30/07/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFavoris : NSObject
@property (nonatomic, retain) NSString *idFav;
@property (nonatomic, retain) NSString *tId;
@property (nonatomic, retain) NSString *tFam;
@property (nonatomic, retain) NSString *tTyp;
@property (nonatomic, retain) NSString *tDesc;
@property (nonatomic, retain) NSString *tPrix;
@property (nonatomic, retain) NSString *tGencode;

@property (nonatomic, retain) NSString *tMin;
@property (nonatomic, retain) NSString *tMax;
@property (nonatomic, retain) NSString *tRes;

@property (nonatomic, retain) NSString *tPval;

@end
