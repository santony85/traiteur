//
//  Test.h
//  ExternVariable
//
//  Created by ashish on 08/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "apiconnect.h"
#import "dataBase.h"
#import "planbAppDelegate.h"

extern planbAppDelegate *mappDelegate;


extern NSString *idMagasin;
extern NSString *catalogue;

extern NSString *nomMagasin;
extern NSString *nomcatalogue;

@interface GlobalV : NSObject

- (void)setVar;

@end
