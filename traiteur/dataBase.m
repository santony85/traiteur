//
//  dataBase.m
//  LeclercOlonne
//
//  Created by 2B on 05/12/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "dataBase.h"
#import "NSFavoris.h"
#import "NSCommande.h"



@implementation dataBase{
    NSMutableArray *sqliteData;
    NSInputStream  *iStream ;

}

- (void)setUpStreamForFile:(NSString *)path {
    // iStream is NSInputStream instance variable
    iStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [iStream setDelegate:self];
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [iStream open];
}

-(id)initDatabase:(int)isGet{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"leclerctraiteur.db"]];
    [self  setUpStreamForFile:databasePath];
    
    
    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
      {
      const char *dbpath = [databasePath UTF8String];
          
      if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
        {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FAVORIS (ID INTEGER PRIMARY KEY AUTOINCREMENT, Famille TEXT,Type TEXT, Desc TEXT, Prix TEXT)";
        if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
        sql_stmt = "CREATE TABLE IF NOT EXISTS COMMANDE (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDCLIENT TEXT,NUMCOMMANDE TEXT, DATECREA TEXT, DATELIV TEXT,HEURELIV TEXT, NBPERSONNE TEXT, STATUS TEXT)";
        if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
         
        sql_stmt = "CREATE TABLE IF NOT EXISTS LIGNECOMMANDE (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDCOMMANDE TEXT, IDPRODUIT TEXT, QTE TEXT,COMMENTAIRE TEXT)";
        if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
        sql_stmt = "CREATE TABLE IF NOT EXISTS CLIENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOM TEXT, PRENOM TEXT, ADRESSE TEXT, CP TEXT, VILLE TEXT, TEL TEXT, NUMCARTE TEXT)";
        if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
            
        sqlite3_close(favDB);
    
        } else {
            //status.text = @"Failed to open/create database";
        }
    }
    return self;
}
//***************************************************
- (NSMutableArray *) findAllFavoris{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
                NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FAVORIS"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSFavoris *favoris = [[NSFavoris alloc] init];
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                favoris.idFav = idField;
                //favoris.idProd = idP;
                
                [sqliteData addObject:favoris];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (NSMutableArray *) findFavorisId :(NSString *)idProd{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FAVORIS WHERE ID=%@",idProd];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSFavoris *favoris = [[NSFavoris alloc] init];
                favoris.idFav = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                favoris.tFam  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                favoris.tTyp  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                favoris.tDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                favoris.tPrix = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                [sqliteData addObject:favoris];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (NSMutableArray *) findFavoris :(NSString *)idProd{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FAVORIS WHERE Type=\"%@\"",idProd];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
          {
          while (sqlite3_step(statement) == SQLITE_ROW)
            {
            NSFavoris *favoris = [[NSFavoris alloc] init];
            favoris.idFav = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            favoris.tFam  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            favoris.tTyp  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            favoris.tDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            favoris.tPrix = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            [sqliteData addObject:favoris];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (int) saveData :(NSString *)mid{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
      {
      NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO FAVORIS (IDPROD) VALUES (\"%@\")", mid];
      const char *insert_stmt = [insertSQL UTF8String];
      sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
        {
        //[self setFavOkB:1];
        lastRowId = sqlite3_last_insert_rowid(favDB);
        NSLog(@"%ld",lastRowId);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
}
//***************************************************
- (void) delData:(int)val{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
      {
      NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM FAVORIS WHERE ID=%d", val];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}
//***************************************************
- (NSMutableArray *) findAllCat{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM CATEGORIE"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //NSFavoris *favoris = [[NSFavoris alloc] init];
                //NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                //favoris.idFav = idField;
                //favoris.idProd = idP;
                
                [sqliteData addObject:idP];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (int) saveDataCat :(NSString *)mid{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CATEGORIE (IDPROD) VALUES (\"%@\")", mid];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
          {
          //[self setFavOkB:1];
          lastRowId = (int)sqlite3_last_insert_rowid(favDB);
           //NSLog(@"%ld",lastRowId);
          }
        else
          {
          //status.text = @"Failed to add contact";
          }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
}
//***************************************************
//***************************************************
- (void) delDataCat{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM FAVORIS"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}
//***************************************************
-(int)addToDatabase :(NSFavoris *)favoris{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO FAVORIS (Famille,Type,Desc,Prix) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")", favoris.tFam,favoris.tTyp,favoris.tDesc,favoris.tPrix];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self setFavOkB:1];
            lastRowId = sqlite3_last_insert_rowid(favDB);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;

}
//***************************************************
- (void) resetId{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"delete from sqlite_sequence where name='FAVORIS';"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}
//***************************************************
- (NSMutableArray *) findHeader{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT DISTINCT Famille FROM FAVORIS"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //NSFavoris *favoris = [[NSFavoris alloc] init];
                //NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                //favoris.idFav = idField;
                //favoris.idProd = idP;
                
                [sqliteData addObject:idP];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    
    
    
    return sqliteData;
   
}
//***************************************************
- (NSMutableArray *) findLine:(NSString *)nom{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT DISTINCT Type FROM FAVORIS WHERE Famille = \"%@\" ",nom];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //NSFavoris *favoris = [[NSFavoris alloc] init];
                //NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                                
                [sqliteData addObject:idP];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (int)addClient:(NSClient *)client{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CLIENT (NOM,PRENOM,ADRESSE,CP,VILLE,TEL,NUMCARTE) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", client.nom,client.prenom,client.adresse,client.cp,client.ville,client.tel,client.numcarte];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self setFavOkB:1];
            lastRowId = sqlite3_last_insert_rowid(favDB);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
   
}
//***************************************************
- (NSMutableArray *)findClient:(NSString *)client:(int)mode{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    if(! [client isEqualToString:@""]){
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL;
             if(mode==0)querySQL = [NSString stringWithFormat: @"SELECT * FROM CLIENT WHERE NOM like \"%@%@\" ",client,@"%"];
        else if(mode==1)querySQL = [NSString stringWithFormat: @"SELECT * FROM CLIENT WHERE ID = \"%@\" ",client];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSClient *client = [[NSClient alloc] init];

                client.idclient = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                client.nom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                client.prenom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                client.adresse = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                client.cp = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                client.ville = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                client.tel = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                client.numcarte = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                [sqliteData addObject:client];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
      }
    }
    return sqliteData;
    
}
//***************************************************
-(int)addCommande:(NSCommande *)commande{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
      {
      NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO COMMANDE (NUMCOMMANDE, IDCLIENT,DATECREA, DATELIV,HEURELIV, NBPERSONNE) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", commande.numcommande,commande.idclient,commande.datecommande,commande.dateliv,commande.heureliv,commande.nbpersonne];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self setFavOkB:1];
            lastRowId = sqlite3_last_insert_rowid(favDB);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
   
}
//***************************************************
-(NSMutableArray *)findCommande:(NSString *)idclient:(int)mode{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    if(! [idclient isEqualToString:@""]){
        if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
        {
            NSString *querySQL;
            if(mode==0)querySQL = [NSString stringWithFormat: @"SELECT * FROM COMMANDE WHERE IDCLIENT = \"%@\" ORDER BY ID DESC",idclient];
            else if(mode==1)querySQL = [NSString stringWithFormat: @"SELECT * FROM COMMANDE WHERE NUMCOMMANDE = \"%@\" ORDER BY ID DESC",idclient];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSCommande *client = [[NSCommande alloc] init];
                    
                    //NUMCOMMANDE TEXT, DATECREA TEXT, DATELIV TEXT,HEURELIV TEXT, NBPERSONNE TEXT
                    
                    client.idcommande = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    client.idclient = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    client.numcommande = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    client.datecommande = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    client.dateliv = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    client.heureliv = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    client.nbpersonne = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    
                    [sqliteData addObject:client];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(favDB);
        }
    }
    return sqliteData;
}
//***************************************************
-(int)lastCommande{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MAX(ID) FROM COMMANDE"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
          {
          if (sqlite3_step(statement) == SQLITE_ROW)
            {
            //NSString *resu = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                float tmp = sqlite3_column_double(statement, 0);
            lastRowId = tmp;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return lastRowId;
}
//***************************************************
-(int)addLigneCommande:(NSLigneCommande *)lignecommande{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO LIGNECOMMANDE (IDCOMMANDE, IDPRODUIT, QTE,COMMENTAIRE) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")", lignecommande.idcommande,lignecommande.idproduit,lignecommande.qte];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self setFavOkB:1];
            lastRowId = sqlite3_last_insert_rowid(favDB);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
    
}
//***************************************************
-(NSMutableArray *)findLigneCommande:(NSString *)commande{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    if(! [commande isEqualToString:@""]){
        if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM LIGNECOMMANDE WHERE IDCOMMANDE = \"%@\" ",commande];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSLigneCommande *client = [[NSLigneCommande alloc] init];
                    
                    client.idlignecommande = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    client.idcommande = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    client.idproduit = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    client.qte = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    client.commentaire = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    [sqliteData addObject:client];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(favDB);
        }
    }
    return sqliteData;
    
}
//***************************************************
-(void)deleteLigneCommande:(NSString *)commande{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM LIGNECOMMANDE WHERE ID=%@", commande];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}


@end
