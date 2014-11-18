//
//  dataBase.h
//  LeclercOlonne
//
//  Created by 2B on 05/12/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSFavoris.h"
#import "NSClient.h"
#import "NSCommande.h"
#import "NSLigneCommande.h"



@interface dataBase : NSObject<NSStreamDelegate>{
  sqlite3   *favDB;
  NSString  *databasePath;
  }



- (id)initDatabase:(int)isGet; //Constructeur

- (int) saveData :(NSString *)mid;
- (void) delData:(int)val;
- (NSMutableArray *) findAllFavoris;
- (NSMutableArray *) findFavoris :(NSString *)idProd;
- (NSMutableArray *) findFavorisId :(NSString *)idProd;

- (NSMutableArray *) findAllCat;
- (int) saveDataCat :(NSString *)mid;
- (void) delDataCat;

-(int)addToDatabase :(NSFavoris *)favoris;
- (void) resetId;

- (NSMutableArray *) findHeader;
- (NSMutableArray *) findLine:(NSString *)nom;

/*********************/
-(int)addClient:(NSClient *)client;
-(NSMutableArray *)findClient:(NSString *)client:(int)mode;
/*-------------------*/

/*********************/
-(int)addCommande:(NSCommande *)commande;
-(NSMutableArray *)findCommande:(NSString *)idclient:(int)mode;
-(int)lastCommande;
/*-------------------*/

/*********************/
-(int)addLigneCommande:(NSLigneCommande *)lignecommande;
-(NSMutableArray *)findLigneCommande:(NSString *)commande;
-(void)deleteLigneCommande:(NSString *)commande;
/*-------------------*/

@end
