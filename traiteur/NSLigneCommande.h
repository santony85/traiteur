//
//  NSLigneCommande.h
//  traiteur
//
//  Created by Antony on 14/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLigneCommande : NSObject

@property (nonatomic, retain) NSString *idlignecommande;
@property (nonatomic, retain) NSString *idcommande;
@property (nonatomic, retain) NSString *idproduit;
@property (nonatomic, retain) NSString *qte;
@property (nonatomic, retain) NSString *commentaire;

@end
