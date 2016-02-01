//
//  NSClient.h
//  traiteur
//
//  Created by Antony on 13/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSClient : NSObject

@property (nonatomic, retain) NSString *idclient;
@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *prenom;
@property (nonatomic, retain) NSString *adresse;
@property (nonatomic, retain) NSString *cp;
@property (nonatomic, retain) NSString *ville;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *numcarte;

@end
