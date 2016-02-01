//
//  PDFService.m
//  PDF
//
//  Created by Masashi Ono on 09/10/25.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "PDFService.h"
#import "NSLigneCommande.h"
#import "NSProduithc.h"
#import "NSFavoris.h"
#import "dataBase.h"

#import "NKDEAN13Barcode.h"
#import "NKDEAN8Barcode.h"


#import "UIImage-NKDBarcode.h"

///!!!!!!!!! attention AJOUTER CODE "RAYON CAISSE 1277"

static inline double radians (double degrees) {return degrees * M_PI/180;}
static PDFService *_instance;


void PDFService_defaultErrorHandler(HPDF_STATUS   error_no,
                                    HPDF_STATUS   detail_no,
                                    void         *user_data)
{
    PDFService_userData *userData = (PDFService_userData *)user_data;
    HPDF_Doc pdf = userData->pdf;
    PDFService *service = userData->service;
    NSString *filePath = userData->filePath;
    
    //  HPDF_ResetError(pdf)
    HPDF_Free(pdf);
    
    if (service.delegate) {
        [service.delegate service:service
         didFailedCreatingPDFFile:filePath
                          errorNo:error_no
                         detailNo:detail_no];
    }
}


@implementation PDFService{
    NSMutableArray *lstLigneCommandetmp;
    float prixTotalTTC;
    float prixTotalBrut;
    
    
    
    
    
    
}

@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self != nil) {
        //init code
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

+ (PDFService *)instance
{
    if (!_instance) {
        _instance = [[PDFService alloc] init];
    }
    return _instance;
}


- (UIImage*)unrotateImage:(UIImage*)image {
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width ,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)createTabPage2 :(HPDF_Doc)pdf :(int)numBase :(int)isPrix :(int)nbPageTotal :(int)PageAtuel{
    NSLog(@"[libharu] Adding page 1");
    HPDF_Page page1 = HPDF_AddPage(pdf);
    NSLog(@"[libharu] SetSize page 1");
    HPDF_Page_SetSize(page1, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT);
    
    
    
    NSLog(@"[libharu] TextOut page 1");
    HPDF_Page_BeginText(page1);
    //HPDF_UseUTFEncodings(pdf);
    //HPDF_SetCurrentEncoder(pdf, "UTF-8");
    HPDF_Font fontEn = HPDF_GetFont(pdf, "Helvetica", "ISO8859-9");
    //HPDF_Font fontEn = HPDF_GetFont(pdf, "Helvetica", "MacRomanEncoding");
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 18.0);
    
    
    const char *com=NULL;
    NSString *comtx  =  [NSString stringWithFormat:@"Bon de Commande no: %@",_commande.numcommande];
    com = [comtx cStringUsingEncoding:NSASCIIStringEncoding];
    
    HPDF_Page_TextOut(page1, 280, 805.00, com);
    
    
    //HPDF_Page_SetFontAndSize(page1, fontEn, 12.0);
    //HPDF_Page_TextOut(page1, 24, 726, "Emetteur :");
    //HPDF_Page_TextOut(page1, 314, 726, "Adresse a :");
    HPDF_Page_EndText(page1);
    
    
    
    //HPDF_Page_SetLineWidth(page1, 1.0);
    //HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    //HPDF_Page_Rectangle(page1, 20, 640, 260, 80);
    //HPDF_Page_Stroke(page1);
    
    HPDF_Page_SetLineWidth(page1, 1.0);
    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    //HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
    HPDF_Page_Rectangle(page1, 276, 685, 302, 104);
    //HPDF_Page_Fill(page1);
    HPDF_Page_Stroke(page1);
    
    //coordonnés client
    HPDF_Page_BeginText(page1);
    HPDF_Page_SetFontAndSize(page1, fontEn, 14.0);
    
    const char *nom=NULL;
    const char *add=NULL;
    
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 14.0);
    NSString *prixu  =  [NSString stringWithFormat:@"Nom : %@ %@",_client.nom,_client.prenom];
    nom = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 286, 772, nom);//316//706
    
    //prixu  =  [NSString stringWithFormat:@"Adresse : %@",_client.adresse];
    //add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    //HPDF_Page_TextOut(page1, 316, 692, add);
    
    //prixu  =  [NSString stringWithFormat:@"CP : %@   Ville : %@",_client.cp,_client.ville];
    //add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    //HPDF_Page_TextOut(page1, 316, 678, add);
    
    prixu  =  [NSString stringWithFormat:@"Tel. : %@",_client.tel];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 286, 752, add);
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 16.0);
    prixu  =  [NSString stringWithFormat:@"A retirer le : %@  a : %@ ",_commande.dateliv,_commande.heureliv];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 286, 732, add);
    HPDF_Page_SetFontAndSize(page1, fontEn, 11.0);
    prixu  =  [NSString stringWithFormat:@"Enregistre par : %@",_commande.vendeur];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 286, 712, add);
    HPDF_Page_SetFontAndSize(page1, fontEn, 12.0);
    prixu  =  [NSString stringWithFormat:@"Date de commande : %@",_commande.datecommande];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 286, 692, add);
    
    //prixu  =  [NSString stringWithFormat:@"Email : %@",_client.numcarte];
    //add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    //HPDF_Page_TextOut(page1, 316, 650, add);
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 11.0);
    //info leclerc
    prixu  =  [NSString stringWithFormat:@"E-Leclerc Fontenay"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 760, add);
    
    prixu  =  [NSString stringWithFormat:@"Avenue du General de Gaulle"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 745, add);
    
    prixu  =  [NSString stringWithFormat:@"85200 Fontenay-le-Comte"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 730, add);
    
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
    
    prixu  =  [NSString stringWithFormat:@"Aucune commande ne sera remise"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 710, add);
    
    prixu  =  [NSString stringWithFormat:@"sans presentation de ce bon"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 700, add);
    
    //prixu  =  [NSString stringWithFormat:@"SUSHIS-PIZZAS-ROTISSERIE"];
    //add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    //HPDF_Page_TextOut(page1, 20, 694, add);
    prixu  =  [NSString stringWithFormat:@"Tel.: 02.51.50.13.13"];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 20, 678, add);
    
    
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
    HPDF_Page_TextOut(page1, 80, 36, [@"INFO CAISSE" cStringUsingEncoding:NSASCIIStringEncoding]);
    HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
    HPDF_Page_TextOut(page1, 80, 26, [@"TOUS LES GENCODES DE CETTE PAGE DOIVENT ETRE SCANNES" cStringUsingEncoding:NSASCIIStringEncoding]);
    HPDF_Page_TextOut(page1, 80, 16, [@"VERIFIEZ BIEN LE NOMBRE DE PAGES" cStringUsingEncoding:NSASCIIStringEncoding]);
    
    
    NSString *pages  =  [NSString stringWithFormat:@"Page %d/%d",PageAtuel,nbPageTotal];
    
    HPDF_Page_TextOut(page1, 20, 16, [pages cStringUsingEncoding:NSASCIIStringEncoding]);
    
    
    //if(isPrix==1)HPDF_Page_TextOut(page1, 300 ,40, "Code rayon : 12667");
    HPDF_Page_EndText(page1);
    
    int nbLigne=8;
    
    if(isPrix==1){nbLigne=8;}
    
    
    //prixTotalTTC = 0.0;
    
    
    for(int i=0;i<nbLigne;i++){
        int posi = i*2;
        if(i==0){
            HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
            HPDF_Page_Rectangle(page1, 20,               640-(i*20), 300, 20);//610
            HPDF_Page_Rectangle(page1, 20+300,           640-(i*20), 40 , 20);
            HPDF_Page_Rectangle(page1, 20+300+40,        640-(i*20), 100, 20);
            HPDF_Page_Rectangle(page1, 20+300+40+100,    640-(i*20), 60,  20);
            HPDF_Page_Rectangle(page1, 20+300+40+100+60, 640-(i*20), 60,  20);

            HPDF_Page_Fill(page1);
            
            
            HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_BeginText(page1);
            HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
            HPDF_Page_TextOut(page1, 24,                645-(i*20), "Designation");//615
            
            HPDF_Page_TextOut(page1, 24+300,            645-(i*20), "Qte.");
            
            HPDF_Page_TextOut(page1, 24+300+40,        645-(i*20), "Gencode");
            
            
            
            
            HPDF_Page_TextOut(page1, 24+300+40+100,     645-(i*20), "P. Unitaire");
            HPDF_Page_TextOut(page1, 24+300+40+100+60,  645-(i*20), "P. Total");
            
            HPDF_Page_EndText(page1);
            HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_SetLineWidth(page1, 1.0);
            HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
            
            //HPDF_Page_Rectangle(page1, 20, 550-(i*24), 550, 24);
            HPDF_Page_Rectangle(page1, 20,              640-(i*20), 300, 20);
            HPDF_Page_Rectangle(page1, 20+300,          640-(i*20), 40,  20);
            HPDF_Page_Rectangle(page1, 20+300+40,       640-(i*20), 100,  20);
            HPDF_Page_Rectangle(page1, 20+300+40+100,   640-(i*20), 60 , 20);
            HPDF_Page_Rectangle(page1, 20+300+40+100+60,640-(i*20), 60 , 20);
            HPDF_Page_Stroke(page1);
        }
        else {
            NSString   *qte     = @"";
            const char *desc    = NULL;
            const char *com     = NULL;
            const char *pu      = NULL;
            const char *pt      = NULL;
            const char *gencode = NULL;
            NSString   *tmpcom  = @"";
            NSString   *gencd=@"";
            //NSString *pu=@"";
            NSLigneCommande *ln;
            NSString *tt=@"";
            
            //char str[20] = {0};
            //sprintf(str, "%.2f %c %d",123.50,120+i,120+i);
            
            if((i-1)+numBase < ([_lstLigneCommande count])){
                ln = [_lstLigneCommande objectAtIndex:numBase+i-1];
                
                if ([[_lstLigneCommande objectAtIndex:numBase+i-1] isKindOfClass:[NSLigneCommande class]]){
                    
                    
                    qte = [NSString stringWithFormat:@"%@ X",ln.qte];
                    
                    
                    dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
                    NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
                    NSFavoris *fav = [lfav objectAtIndex:0];
                    tt=fav.tDesc;
                    gencd=fav.tGencode;
                    if([tt length] > 58) tt = [NSString stringWithFormat:@"%@...",[tt substringWithRange:NSMakeRange(0, 58)]];
                    
                    
                    tmpcom=ln.commentaire;
                    desc = [tt cStringUsingEncoding:NSISOLatin1StringEncoding];
                    com  = [ln.commentaire cStringUsingEncoding:NSISOLatin1StringEncoding];
                    
                    
                    
                    float prixrem = [fav.tPrix  floatValue]*[_commande.remise floatValue]/100.0;
                    float npu = [fav.tPrix  floatValue]-prixrem;
                    
                    
                    //NSString *prixu
                    NSString *prixu  =  [NSString stringWithFormat:@"%.2f",npu];//fav.tPrix
                    pu = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
                    
                    
                    float pptot = [ln.qte intValue] * [prixu  floatValue];
                    NSString *prixt  =  [NSString stringWithFormat:@"%.2f",pptot];
                    pt = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
                    
                    prixTotalTTC += pptot;
                }
                
            }
            
            if([tt length] > 0){
                NSString *gc;
                UIImage * generatedImage;
                
                if([gencd length] > 8){
                    NKDEAN13Barcode * code = [[NKDEAN13Barcode alloc] initWithContent:gencd];
                    gc=code.caption;
                    generatedImage = [UIImage imageFromBarcode:code]; // ..or as a less accurate UIImage
                }
                else if([gencd length] !=0){
                    NKDEAN8Barcode * code = [[NKDEAN8Barcode alloc] initWithContent:gencd];
                    gc=code.caption;
                    generatedImage = [UIImage imageFromBarcode:code]; // ..or as a less accurate UIImage
                }
                else{
                    generatedImage = [[UIImage alloc]init];
                }
                
                
                NSLog(@"%f %f",generatedImage.size.height,generatedImage.size.width);
                
                UIImage *scaledImage =
                [UIImage imageWithCGImage:[generatedImage CGImage]
                                    scale:(generatedImage.scale * 20)
                              orientation:(generatedImage.imageOrientation)];
                
                //NSString *gc=code.caption;
                gencode = [gencd cStringUsingEncoding:NSASCIIStringEncoding];
                HPDF_Page_BeginText(page1);
                HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
                HPDF_Page_SetTextLeading (page1,8.0);
                if([gencd length] > 8)
                  HPDF_Page_TextOut(page1, 20+300+20 +45,642-(posi*42), gencode);
                else
                  HPDF_Page_TextOut(page1, 20+300+33 +45,642-(posi*42), gencode);
                
                
                HPDF_Page_EndText(page1);
                
                
                
                
           // NSData * generatedPdf = [UIImage pdfFromBarcode:code]; // Generate the barcode as a PDF
            
            NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            [self saveImage:scaledImage withFileName:[NSString stringWithFormat:@"temp"] ofType:@"png" inDirectory:documentsDirectoryPath];
                
            NSString *txtPath = [documentsDirectoryPath stringByAppendingPathComponent:@"temp.png"];
            const char *pathCString = [txtPath cStringUsingEncoding:NSASCIIStringEncoding];
                
                
                
            HPDF_Image image = HPDF_LoadPngImageFromFile(pdf, pathCString);
                
            //HPDF_Page_DrawImage(page1, image, 20+300+10+45, 652-(i*42), 80, 30);
                HPDF_Page_DrawImage(page1, image, 300+49, 652-(posi*42), 70, 50);
                
            }
            
            /*HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_SetLineWidth(page1, 1.0);
            HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
            //HPDF_Page_Rectangle(page1, 20, 550-(i*24), 550, 24);
            
            HPDF_Page_Rectangle(page1, 20,               640-(posi*42), 300, 42);
            HPDF_Page_Rectangle(page1, 20+300,           640-(posi*42), 140, 42);
            
            //*****HPDF_Page_Rectangle(page1, 20+300+40,        640-(i*42), 100,  42);
            
            HPDF_Page_Rectangle(page1, 20+300+40+100,    640-(posi*42), 60,  42);
            HPDF_Page_Rectangle(page1, 20+300+40+100+60, 640-(posi*42), 60,  42);
            
            HPDF_Page_Stroke(page1);*/
            
            HPDF_Page_BeginText(page1);
            HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
            HPDF_Page_SetTextLeading (page1,8.0);

            if([tmpcom length]>0){
              HPDF_Page_TextOut(page1, 24, 661-(posi*42),  desc);
              }
            
            else{
               HPDF_Page_TextOut(page1, 24, 658-(posi*42),  desc);
            }
            
            
            HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
            

            
            
            
            
            HPDF_Page_TextRect(page1,
                               28,
                               654-(posi*42),
                               340+20,
                               658-(posi*42)-40,
                               com ,
                               HPDF_TALIGN_LEFT, NULL
                               );
               
            HPDF_Page_SetFontAndSize(page1, fontEn, 12.0);
            
            HPDF_Page_TextRect(page1,
                               10+300,//24+300
                               670-(posi*42),
                               10+300+47,
                               670-(posi*42)-42,
                               [qte cStringUsingEncoding:NSASCIIStringEncoding],
                               //pu,
                               HPDF_TALIGN_RIGHT, NULL);
            
            HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
            HPDF_Page_TextRect(page1,
                               24+300+100+40,
                               666-(posi*42),
                               24+300+100+40+50,
                               666-(i*42)-42,
                               //[qte cStringUsingEncoding:NSASCIIStringEncoding],
                               pu,
                               HPDF_TALIGN_RIGHT, NULL
                               
                               );
            
            
            HPDF_Page_TextRect(page1,
                               24+340+80+60,
                               666-(posi*42),
                               24+340+70+60+80,
                               666-(posi*42)-42,
                               pt,
                               HPDF_TALIGN_RIGHT, NULL
                               );
            HPDF_Page_EndText(page1);
            
        }
        NSLog(@"%d",610-(i*32));
    }
    
    const char *pttc=NULL;
    const char *pttcb=NULL;
    const char *pht= NULL;
    const char *tva= NULL;
    const char *rem= NULL;
    
    //const char *txtrem= NULL;
    
    int remise = [_commande.remise integerValue];
    
    prixTotalBrut = prixTotalTTC;
    
    prixTotalTTC = prixTotalTTC-(prixTotalTTC * ([_commande.remise floatValue]/100.0));
    dataBase *sqlManager;
    sqlManager = [[dataBase alloc] initDatabase:0];
    
    
    float ttb=0.0;
    float ttt=0.0;
     
     NSLog(@"nb  prod %d",_lstLigneCommande.count);
     for(int i=0;i<_lstLigneCommande.count;i++){
     if ([[_lstLigneCommande objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
     NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:i];
     
     NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
     NSFavoris *fav = [lfav objectAtIndex:0];
     
     ttb+= [fav.tPrix floatValue]*[ln.qte integerValue];
     
     NSLog(@"%@ %@ %f",fav.tPrix,ln.qte,[fav.tPrix floatValue]*[ln.qte integerValue]);
     //NSFavoris *fav = [lfav objectAtIndex:0];
     }
     }
     
     float tmpRem = ttb * [_commande.remise floatValue]/100.0;
     ttt = ttb-tmpRem;
     NSLog(@"total brut %f rem %f net %f",ttb,tmpRem,ttt);
    /* _hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
     _totalTTC.text = [NSString stringWithFormat: @"%.2f €",ttt];
     _pht.text = [NSString stringWithFormat: @"%.2f €",ttt/1.206];
     _ptva.text = [NSString stringWithFormat: @"%.2f €",ttt-(ttt/1.206)];*/
    
    
    
    NSString *prixt  =  [NSString stringWithFormat:@"%.2f",ttt];
    pttc   = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *prixb  =  [NSString stringWithFormat:@"%.2f",ttb];
    pttcb   = [prixb cStringUsingEncoding:NSASCIIStringEncoding];
    
    prixt  =  [NSString stringWithFormat:@"%.2f",prixTotalTTC/1.206];
    pht    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    float res = prixTotalTTC - (prixTotalTTC/1.206);
    prixt  =  [NSString stringWithFormat:@"%.2f",res];
    tva    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    
    
    prixt  =  [NSString stringWithFormat:@"%.2f",tmpRem];
    rem    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *txtrm  =  [NSString stringWithFormat:@"Remise %d %@",[_commande.remise integerValue],@"%"];
    const char *txtrem= [txtrm cStringUsingEncoding:NSASCIIStringEncoding];
    
    if(remise>0){

        
        for(int i=0;i<3;i++){
            const char *tmp=NULL;
            
                 if(i==2)tmp = pttc;
            else if(i==0)tmp = rem;
            else if(i==1)tmp = pttcb;
            //else if(i==2)tmp = tva;
            
            
            
            if(isPrix==1){
                HPDF_Page_SetLineWidth(page1, 1.0);
                HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
                HPDF_Page_Rectangle(page1, 0, 0, 0, 0);
                HPDF_Page_Stroke(page1);
                
                HPDF_Page_BeginText(page1);
                HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
                HPDF_Page_SetTextLeading (page1,8.0);
                
                
                
                if(i==0)HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), txtrem);
                if(i==1)HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), "Total Brut");
                if(i==2){
                HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), "Guide traiteur");
                // HPDF_Page_TextOut(page1, 20+340+80 ,35, "Guide traiteur");
                //HPDF_Page_TextOut(page1, 20+340+53 ,38-(i*12)-10, "+ etiquettes balance");
                }

               // if(i==3)HPDF_Page_TextOut(page1, 20+340+90 ,81-(i*20), "Total TTC");
                
                HPDF_Page_TextRect(page1,
                                   20+340+80+60,
                                   48-(i*12),
                                   
                                   24+340+70+60+80,
                                   48-(i*12)-12,
                                   tmp,
                                   HPDF_TALIGN_RIGHT, NULL
                                   );
                
                //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
                
                HPDF_Page_EndText(page1);
            }
            

        }
    }
    else{
        if(isPrix==1){
        const char *tmp=NULL;
        tmp = pttc;
        
        HPDF_Page_SetLineWidth(page1, 1.0);
        HPDF_Page_SetRGBStroke(page1, 1, 1, 1);
        HPDF_Page_Rectangle(page1, 0, 0, 0, 20);//78
        HPDF_Page_Stroke(page1);
        
        HPDF_Page_BeginText(page1);
        HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
        HPDF_Page_SetTextLeading (page1,8.0);
        
        
        
        //if(i==0)HPDF_Page_TextOut(page1, 20+340+100,83-(i*20), "Remise");
        
        //if(i==0)HPDF_Page_TextOut(page1, 20+340+96 ,81-(i*20), "Total HT");
        //if(i==1)HPDF_Page_TextOut(page1, 20+340+92 ,81-(i*20), "Dont TVA");
            HPDF_Page_TextOut(page1, 20+340+80 ,30, "Guide traiteur");
            //HPDF_Page_TextOut(page1, 20+340+53 ,25, "+ etiquettes balance");
            HPDF_Page_SetFontAndSize(page1, fontEn, 13.0);
            HPDF_Page_TextOut(page1, 20+340+160 ,26, tmp);
            
          
       
        /*HPDF_Page_TextRect(page1,
                           20+340+80+60,
                           37,
                           
                           24+340+70+60+80,
                           33-20,
                           tmp,
                           HPDF_TALIGN_RIGHT, NULL
                           );*/
        
        
        
        //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
        
        HPDF_Page_EndText(page1);
        }

    }
    
    //logo
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"logoprnt" ofType:@"png"];
    const char *pathCString = [path cStringUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"[libharu] LoadPngImageFromFile path:%@\n pathCString:%s", path, pathCString);
    HPDF_Image image = HPDF_LoadPngImageFromFile(pdf, pathCString);
    HPDF_Page_DrawImage(page1, image, 20, 780, 200, 51);
    
    //return prixTotalTTC;
    
}

-(void)createTabPage :(HPDF_Doc)pdf :(int)numBase :(int)isPrix :(int)nbPageTotal :(int)PageAtuel{
    NSLog(@"[libharu] Adding page 1");
    HPDF_Page page1 = HPDF_AddPage(pdf);
    NSLog(@"[libharu] SetSize page 1");
    HPDF_Page_SetSize(page1, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT);
    
    
    
    NSLog(@"[libharu] TextOut page 1");
    HPDF_Page_BeginText(page1);
    //HPDF_UseUTFEncodings(pdf);
    //HPDF_SetCurrentEncoder(pdf, "UTF-8");
    HPDF_Font fontEn = HPDF_GetFont(pdf, "Helvetica", "ISO8859-9");
    //HPDF_Font fontEn = HPDF_GetFont(pdf, "Helvetica", "MacRomanEncoding");
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 18.0);
    //HPDF_Page_TextOut(page1, 350, 800.00, "Bon de Commande");
    
    const char *com=NULL;
    NSString *comtx  =  [NSString stringWithFormat:@"Bon de Commande no: %@",_commande.numcommande];
    com = [comtx cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 280, 805.00, com);
    
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 12.0);
    HPDF_Page_TextOut(page1, 24, 726, "");
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
    HPDF_Page_TextOut(page1, 80, 36, [@"INFO CAISSE" cStringUsingEncoding:NSASCIIStringEncoding]);
    HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
    HPDF_Page_TextOut(page1, 80, 26, [@"TOUS LES GENCODES DE CETTE PAGE DOIVENT ETRE SCANNES" cStringUsingEncoding:NSASCIIStringEncoding]);
    HPDF_Page_TextOut(page1, 80, 16, [@"VERIFIEZ BIEN LE NOMBRE DE PAGES" cStringUsingEncoding:NSASCIIStringEncoding]);
    
    NSString *pages  =  [NSString stringWithFormat:@"Page %d/%d",PageAtuel,nbPageTotal];
    HPDF_Page_TextOut(page1, 20, 16, [pages cStringUsingEncoding:NSASCIIStringEncoding]);
    
   // HPDF_Page_TextOut(page1, 320 ,40, "Code rayon : 12667");
    
    HPDF_Page_EndText(page1);
    
    /*
    
    HPDF_Page_SetLineWidth(page1, 1.0);
    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    HPDF_Page_Rectangle(page1, 20, 640, 260, 80);
    HPDF_Page_Stroke(page1);
    
    HPDF_Page_SetLineWidth(page1, 1.0);
    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    //HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
    HPDF_Page_Rectangle(page1, 310, 640, 270, 80);
    //HPDF_Page_Fill(page1);
    HPDF_Page_Stroke(page1);
    
    //coordonnés client
    HPDF_Page_BeginText(page1);
    HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
    
    const char *nom=NULL;
    const char *add=NULL;
    
    
    
    NSString *prixu  =  [NSString stringWithFormat:@"Nom : %@ %@",_client.nom,_client.prenom];
    nom = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 316, 706, nom);
    
    prixu  =  [NSString stringWithFormat:@"Adresse : %@",_client.adresse];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 316, 692, add);
    
    prixu  =  [NSString stringWithFormat:@"CP : %@   Ville : %@",_client.cp,_client.ville];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 316, 678, add);
    
    prixu  =  [NSString stringWithFormat:@"Tel. : %@",_client.tel];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 316, 664, add);
    
    prixu  =  [NSString stringWithFormat:@"Email : %@",_client.numcarte];
    add = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
    HPDF_Page_TextOut(page1, 316, 650, add);

    HPDF_Page_EndText(page1);

     */
    
    
    
    
    //float prixTotalTTC = 0.0;
    
    int oldX=750-136;
    int zz=1;
    for(int i=0;i<11;i++){
        if(i==0){
            HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
            /*HPDF_Page_Rectangle(page1, 20,            750-(i*20), 340, 20);
            HPDF_Page_Rectangle(page1, 20+340,        750-(i*20), 60, 20);
            HPDF_Page_Rectangle(page1, 20+340+60,     750-(i*20), 60+80+20,  20);
            //HPDF_Page_Rectangle(page1, 20+340+80+60,  710-(i*20), 80, 20);*/
            
            
            HPDF_Page_Rectangle(page1, 20,             750-(i*20), 130, 20);
            HPDF_Page_Rectangle(page1, 20+130,         750-(i*20), 150, 20);
            HPDF_Page_Rectangle(page1, 20+130+150,     750-(i*20), 130, 20);
            HPDF_Page_Rectangle(page1, 20+130+150+130, 750-(i*20), 150, 20);
            
            
            //HPDF_Page_Rectangle(page1, 20,            780-(i*20), 560, 20);
            
            
            HPDF_Page_Fill(page1);
            
            
            HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_BeginText(page1);
            HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
            HPDF_Page_TextOut(page1, 24,                 755-(i*20), "Designation");
            HPDF_Page_TextOut(page1, 24+130,             755-(i*20), "GENCODE");
            
            HPDF_Page_TextOut(page1, 24+130+150,         755-(i*20), "Designation");
            HPDF_Page_TextOut(page1, 24+130+150+130,     755-(i*20), "GENCODE");
            

            HPDF_Page_EndText(page1);
            HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_SetLineWidth(page1, 1.0);
            
            
            
            HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
            //HPDF_Page_Rectangle(page1, 20, 550-(i*24), 550, 24);
            HPDF_Page_Rectangle(page1, 20,            750-(i*20), 130, 20);
            HPDF_Page_Rectangle(page1, 20+130,        750-(i*20), 150, 20);
            
            HPDF_Page_Rectangle(page1, 20+130+150,    750-(i*20), 130, 20);
            HPDF_Page_Rectangle(page1, 20+130+150+130,750-(i*20), 150, 20);
            //HPDF_Page_Rectangle(page1, 20+340+80+60,  710-(i*20), 80, 20);
            HPDF_Page_Stroke(page1);
        }
        else {
            NSString   *qte = @"";
            const char *desc= NULL;
            const char *mid = NULL;
            const char *com = NULL;
            const char *pu  = NULL;
            const char *pt  = NULL;
            //NSString *pu=@"";
            NSLigneCommande *ln;
            
           // if ([[_lstLigneCommande objectAtIndex:numBase+i-1] isKindOfClass:[NSProduithc class]]){
            
            
            //char str[20] = {0};
            //sprintf(str, "%.2f %c %d",123.50,120+i,120+i);
            
            if(i-1 < [_lstLigneCommande count]){
                ln = [_lstLigneCommande objectAtIndex:numBase+i-1];
                if ([[_lstLigneCommande objectAtIndex:numBase+i-1] isKindOfClass:[NSProduithc class]]){
                  NSProduithc *fav = [_lstLigneCommande objectAtIndex:numBase+i-1];
                  qte = fav.qte;
                    
                  NSArray* items = [fav.designation componentsSeparatedByString:@" - "];
                    
                    NSString *tt = [items objectAtIndex:1];
                    if([tt length] > 24) tt = [NSString stringWithFormat:@"%@...",[tt substringWithRange:NSMakeRange(0, 24)]];
                    
                    
                  //desc = [fav.designation cStringUsingEncoding:NSISOLatin1StringEncoding];
                  mid  = [[items objectAtIndex:0] cStringUsingEncoding:NSISOLatin1StringEncoding];
                  desc = [tt cStringUsingEncoding:NSISOLatin1StringEncoding];
                  com  = [fav.commentaire cStringUsingEncoding:NSISOLatin1StringEncoding];
                  }
                
            }
            
            int addval=0;
            
            if(i%2==0){
                
                addval=280;
                
            }
            else{
               oldX = 750-(zz*136);
                zz++;
            }
            
            
            HPDF_Page_SetRGBFill(page1, 0, 0, 0);
            HPDF_Page_SetLineWidth(page1, 1.0);
            HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
            
            HPDF_Page_Rectangle(page1, addval+20,            oldX, 130, 136);//750-(i*136)
            HPDF_Page_Rectangle(page1, addval+20+130,        oldX, 150, 136);
            
            //HPDF_Page_Rectangle(page1, 20+120+160,    750-(i*136), 120, 136);
            //HPDF_Page_Rectangle(page1, 20+120+160+120,750-(i*136), 160, 136);
            
            

            HPDF_Page_Stroke(page1);
            
            HPDF_Page_BeginText(page1);
            HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
            HPDF_Page_SetTextLeading (page1,8.0);
            
            HPDF_Page_TextOut(page1, addval+24,             oldX+106,  mid);
            
            HPDF_Page_TextOut(page1, addval+24,             oldX+80,  desc);
            
            HPDF_Page_SetFontAndSize(page1, fontEn, 8.0);
            HPDF_Page_TextRect(page1,
                               28,
                               708-(i*136),
                               340+20,
                               708-(i*136)-40,
                               com ,
                               HPDF_TALIGN_LEFT, NULL
                               );
            HPDF_Page_SetFontAndSize(page1, fontEn, 14.0);
            
            
            
            HPDF_Page_TextOut(page1, addval+24+170,             oldX+65,  [qte cStringUsingEncoding:NSASCIIStringEncoding]);
           /* HPDF_Page_TextRect(page1,
                               22+130,
                               oldX+116,
                               24+130+50,
                               718-(i*136)-136,
                               [qte cStringUsingEncoding:NSASCIIStringEncoding],
                               //pu,
                               HPDF_TALIGN_RIGHT, NULL);*/
            
            HPDF_Page_EndText(page1);
            
        }
      // }
        
        NSLog(@"%d",710-(i*32));
    }
    
    
    const char *pttc=NULL;
    const char *pttcb=NULL;
    const char *pht= NULL;
    const char *tva= NULL;
    const char *rem= NULL;
    
    int remise = [_commande.remise integerValue];
    
    //prixTotalBrut = prixTotalTTC;
    
    //prixTotalTTC = prixTotalTTC-(prixTotalTTC * ([_commande.remise floatValue]/100.0));
    
    
    dataBase *sqlManager;
    sqlManager = [[dataBase alloc] initDatabase:0];
    
    
    float ttb=0.0;
    float ttt=0.0;
    
    NSLog(@"nb  prod %d",lstLigneCommandetmp.count);
    for(int i=0;i<lstLigneCommandetmp.count;i++){
        if ([[lstLigneCommandetmp objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
            NSLigneCommande *ln = [lstLigneCommandetmp objectAtIndex:i];
            
            NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
            NSFavoris *fav = [lfav objectAtIndex:0];
            
            ttb+= [fav.tPrix floatValue]*[ln.qte integerValue];
            
            NSLog(@"%@ %@ %f",fav.tPrix,ln.qte,[fav.tPrix floatValue]*[ln.qte integerValue]);
            //NSFavoris *fav = [lfav objectAtIndex:0];
        }
    }
    
    float tmpRem = ttb * [_commande.remise floatValue]/100.0;
    ttt = ttb-tmpRem;
    NSLog(@"total brut %f rem %f net %f",ttb,tmpRem,ttt);
    /* _hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
     _totalTTC.text = [NSString stringWithFormat: @"%.2f €",ttt];
     _pht.text = [NSString stringWithFormat: @"%.2f €",ttt/1.206];
     _ptva.text = [NSString stringWithFormat: @"%.2f €",ttt-(ttt/1.206)];*/
    
    
    
    NSString *prixt  =  [NSString stringWithFormat:@"%.2f",ttt];
    pttc   = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *prixb  =  [NSString stringWithFormat:@"%.2f",ttb];
    pttcb   = [prixb cStringUsingEncoding:NSASCIIStringEncoding];
    
    prixt  =  [NSString stringWithFormat:@"%.2f",prixTotalTTC/1.206];
    pht    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    float res = prixTotalTTC - (prixTotalTTC/1.206);
    prixt  =  [NSString stringWithFormat:@"%.2f",res];
    tva    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    //prixt  =  [NSString stringWithFormat:@"%@ %@",_commande.remise,@"%"];
    //rem    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    prixt  =  [NSString stringWithFormat:@"%.2f",tmpRem];
    rem    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
     NSString *txtrm  =  [NSString stringWithFormat:@"Remise %d %@",[_commande.remise integerValue],@"%"];
    const char *txtrem= [txtrm cStringUsingEncoding:NSASCIIStringEncoding];
    
    

    
    
    if(remise>0){
        for(int i=0;i<3;i++){
            
            
            for(int i=0;i<3;i++){
                const char *tmp=NULL;
                
                if(i==2)tmp = pttc;
                else if(i==0)tmp = rem;
                else if(i==1)tmp = pttcb;
                //else if(i==2)tmp = tva;
                
                
                
                if(isPrix==1)
                {
                    HPDF_Page_SetLineWidth(page1, 1.0);
                    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
                    HPDF_Page_Rectangle(page1, 0, 0, 0, 0);
                    HPDF_Page_Stroke(page1);
                    
                    HPDF_Page_BeginText(page1);
                    HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
                    HPDF_Page_SetTextLeading (page1,8.0);
                    
                    
                    
                    if(i==0)HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), txtrem);
                    if(i==1)HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), "Total Brut");
                    if(i==2)HPDF_Page_TextOut(page1, 20+340+90 ,38-(i*12), "Total TTC");
                    // if(i==3)HPDF_Page_TextOut(page1, 20+340+90 ,81-(i*20), "Total TTC");
                    
                    HPDF_Page_TextRect(page1,
                                       20+340+80+60,
                                       48-(i*12),
                                       
                                       24+340+70+60+80,
                                       48-(i*12)-12,
                                       tmp,
                                       HPDF_TALIGN_RIGHT, NULL
                                       );
                    
                    //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
                    
                    HPDF_Page_EndText(page1);
                }
                
                
            }

            
            /*const char *tmp=NULL;
            if(i==2)tmp = pttc;
            else if(i==0)tmp = rem;
            else if(i==1)tmp = pttcb;

            
            //if(isPrix==1)
            {
               /* HPDF_Page_SetLineWidth(page1, 1.0);
                HPDF_Page_SetRGBStroke(page1, 1, 1, 1);
                HPDF_Page_Rectangle(page1, 20+340+80+60, 45-(i*18), 80, 18);
                HPDF_Page_Stroke(page1);
                
                HPDF_Page_BeginText(page1);
                HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
                HPDF_Page_SetTextLeading (page1,8.0);
                
                
                
                if(i==0)HPDF_Page_TextOut(page1, 20+340+100,50-(i*18), "Remise");
                if(i==1)HPDF_Page_TextOut(page1, 20+340+93 ,50-(i*18), "Total Brut");
                if(i==2)HPDF_Page_TextOut(page1, 20+340+92 ,50-(i*18), "Total TTC");
                int pss =63;
                if(i==2) {HPDF_Page_SetFontAndSize(page1, fontEn, 13.0);pss=61;}
                else HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
                
                HPDF_Page_TextRect(page1,
                                   20+340+80+60,
                                   pss-(i*18),
                                   
                                   24+340+70+60+80,
                                   pss-(i*18)-18,
                                   tmp,
                                   HPDF_TALIGN_RIGHT, NULL
                                   );
                
                //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
                
                HPDF_Page_EndText(page1);
            }*/
            
            
        }
    }
    else{
        const char *tmp=NULL;
        tmp = pttc;
        
        /*HPDF_Page_SetLineWidth(page1, 1.0);
        HPDF_Page_SetRGBStroke(page1, 1, 1, 1);
        HPDF_Page_Rectangle(page1, 20+340+80+60, 46, 80, 20);//78
        HPDF_Page_Stroke(page1);*/
        
        HPDF_Page_BeginText(page1);
        HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
        HPDF_Page_SetTextLeading (page1,8.0);
        
        
        
        //if(i==0)HPDF_Page_TextOut(page1, 20+340+100,83-(i*20), "Remise");
        
        //if(i==0)HPDF_Page_TextOut(page1, 20+340+96 ,81-(i*20), "Total HT");
        //if(i==1)HPDF_Page_TextOut(page1, 20+340+92 ,81-(i*20), "Dont TVA");
        HPDF_Page_TextOut(page1, 20+340+80 ,35, "Guide traiteur");
        HPDF_Page_TextOut(page1, 20+340+53 ,25, "+ etiquettes balance");
        HPDF_Page_SetFontAndSize(page1, fontEn, 13.0);
        HPDF_Page_TextOut(page1, 20+340+160 ,26, tmp);
        
       /* HPDF_Page_SetFontAndSize(page1, fontEn, 13.0);
        HPDF_Page_TextRect(page1,
                           20+340+80+60,
                           62,
                           
                           24+340+70+60+80,
                           62-20,
                           tmp,
                           HPDF_TALIGN_RIGHT, NULL
                           );
        */
        
        
        //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
        
        HPDF_Page_EndText(page1);

        
        
        
        /*for(int i=0;i<3;i++){
            const char *tmp=NULL;
            if(i==2)tmp = pttc;
         
            else if(i==0)tmp = pht;
            else if(i==1)tmp = tva;
         
            //int isPrix=0;
            
            //if(isPrix==1)
            {
                HPDF_Page_SetLineWidth(page1, 1.0);
                HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
                HPDF_Page_Rectangle(page1, 20+340+80+60, 76-(i*20), 80, 20);//78
                HPDF_Page_Stroke(page1);
                
                HPDF_Page_BeginText(page1);
                HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
                HPDF_Page_SetTextLeading (page1,8.0);
                
                
                
                //if(i==0)HPDF_Page_TextOut(page1, 20+340+100,83-(i*20), "Remise");
                
                //if(i==0)HPDF_Page_TextOut(page1, 20+340+96 ,81-(i*20), "Total HT");
                //if(i==1)HPDF_Page_TextOut(page1, 20+340+92 ,81-(i*20), "Dont TVA");
                if(i==2)HPDF_Page_TextOut(page1, 20+340+90 ,81-(i*20), "Total TTC");
                
                HPDF_Page_TextRect(page1,
                                   20+340+80+60,
                                   92-(i*20),
                                   
                                   24+340+70+60+80,
                                   92-(i*20)-20,
                                   tmp,
                                   HPDF_TALIGN_RIGHT, NULL
                                   );
                
                //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
                
                HPDF_Page_EndText(page1);
            }
            
            
        }*/
    }

    
    
    
    //logo
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"logoprnt" ofType:@"png"];
    const char *pathCString = [path cStringUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"[libharu] LoadPngImageFromFile path:%@\n pathCString:%s", path, pathCString);
    HPDF_Image image = HPDF_LoadPngImageFromFile(pdf, pathCString);
    HPDF_Page_DrawImage(page1, image, 20, 780, 200, 51);
    
    
    
}


-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}


- (void)createPDFFile:(NSString *)filePath
{
    // Creates a test PDF file to the specified path.
    // TODO: use UIImage to create non-optimized PNG rather than build target setting
    NSString *path = nil;
    const char *pathCString = NULL;
    
    NSLog(@"[libharu] PDF Creation START");
    PDFService_userData userData;
    HPDF_Doc pdf = HPDF_New(PDFService_defaultErrorHandler, &userData);
    userData.pdf = pdf;
    userData.service = self;
    userData.filePath = filePath;
    
    NSLog(@"%lu",([_lstLigneCommande count] / 8)+1);
    
    
    
    lstLigneCommandetmp = _lstLigneCommande;
    
    int nbHc = 0;
    int nbN  = 0;
    
    _lstLigneCommande = [[NSMutableArray alloc] init];
    for(int i =0;i<[lstLigneCommandetmp count];i++) {
        if ([[lstLigneCommandetmp objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
            [_lstLigneCommande addObject:[lstLigneCommandetmp objectAtIndex:i]];
            nbN++;
        }
        else if ([[lstLigneCommandetmp objectAtIndex:i] isKindOfClass:[NSProduithc class]]){
            nbHc++;
        }
        
        
        
    }
    
  /*  int isnbHc =0;
    if(nbHc>0){
        nbHc=20;
        isnbHc =0;
        
      }
    else{
        nbHc = 18;
        isnbHc =1;
    }*/
    
    int nbPageN =  (nbN/7)+1;
    int nbPageH=0;
    
    if(nbHc>0)nbPageH=(nbHc/10)+1;
    
    int nbPageTotal = nbPageN+nbPageH;
    
    prixTotalTTC = 0.0;
    
    for(int i =0;i<nbPageN;i++) {
        int isp =0;
        if((i==nbPageN-1)&&(nbPageH==0))isp=1;
        
        [self createTabPage2:pdf :(i*7) :isp :nbPageTotal :i+1];
    }
    
    
    _lstLigneCommande = [[NSMutableArray alloc] init];
    for(int i =0;i<[lstLigneCommandetmp count];i++) {
        if ([[lstLigneCommandetmp objectAtIndex:i] isKindOfClass:[NSProduithc class]]){
            [_lstLigneCommande addObject:[lstLigneCommandetmp objectAtIndex:i]];
        }
        
    }
 
    if(_lstLigneCommande.count>0){
        for(int i =0;i<nbPageH;i++) {
            int isp =0;
            if((i==nbPageH-1))isp=1;
            [self createTabPage:pdf :i*10 :isp :nbPageTotal :i+1+nbPageN];
        }
    }


    
    pathCString = [filePath cStringUsingEncoding:1];
    NSLog(@"[libharu] SaveToFile filePath:%@\n pathCString:%s", filePath, pathCString);
    HPDF_SaveToFile(pdf, pathCString);
    NSLog(@"[libharu] Freeing PDF object ");
    if (HPDF_HasDoc(pdf)) {
        HPDF_Free(pdf);
    }
    NSLog(@"[libharu] PDF Creation END");
}

@end
