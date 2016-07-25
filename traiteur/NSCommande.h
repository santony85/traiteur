//
//  NSCommande.h
//  traiteur
//
//  Created by Antony on 14/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCommande : NSObject

@property (nonatomic, retain) NSString *idcommande;
@property (nonatomic, retain) NSString *idmagasin;
@property (nonatomic, retain) NSString *idclient;
@property (nonatomic, retain) NSString *catalogue;
@property (nonatomic, retain) NSString *numcommande;
@property (nonatomic, retain) NSString *datecommande;
@property (nonatomic, retain) NSString *dateliv;
@property (nonatomic, retain) NSString *heureliv;
@property (nonatomic, retain) NSString *nbpersonne;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *remise;
@property (nonatomic, retain) NSString *vendeur;
@property (nonatomic, retain) NSString *internet;
@property (nonatomic, retain) NSString *acompte;
@property (nonatomic, retain) NSString *commentaire;
@end
