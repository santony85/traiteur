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
#import "NSFavoris.h"
#import "dataBase.h"


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


@implementation PDFService

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

    HPDF_Page_SetFontAndSize(page1, fontEn, 26.0);
    HPDF_Page_TextOut(page1, 350, 800.00, "Bon de Commande");
    
    
    HPDF_Page_SetFontAndSize(page1, fontEn, 12.0);
    HPDF_Page_TextOut(page1, 24, 726, "Emetteur :");
    HPDF_Page_TextOut(page1, 314, 726, "Adresse a :");
    HPDF_Page_EndText(page1);
    

    
    HPDF_Page_SetLineWidth(page1, 1.0);
    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    HPDF_Page_Rectangle(page1, 20, 640, 260, 80);
    HPDF_Page_Stroke(page1);
    
    HPDF_Page_SetLineWidth(page1, 1.0);
    HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
    //HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
    HPDF_Page_Rectangle(page1, 310, 640, 260, 80);
    //HPDF_Page_Fill(page1);
    HPDF_Page_Stroke(page1);
    
    float prixTotalTTC = 0.0;
    
    
    for(int i=0;i<17;i++){
       if(i==0){
            HPDF_Page_SetRGBFill(page1, 0.3, 0.6, 0.4);
            HPDF_Page_Rectangle(page1, 20,            610-(i*20), 340, 20);
            HPDF_Page_Rectangle(page1, 20+340,        610-(i*20), 80, 20);
            HPDF_Page_Rectangle(page1, 20+340+80,     610-(i*20), 60,  20);
            HPDF_Page_Rectangle(page1, 20+340+80+60,  610-(i*20), 80, 20);
            HPDF_Page_Fill(page1);
           
           
           HPDF_Page_SetRGBFill(page1, 0, 0, 0);
           HPDF_Page_BeginText(page1);
           HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
           HPDF_Page_TextOut(page1, 24,            615-(i*20), "Designation");
           HPDF_Page_TextOut(page1, 24+340,        615-(i*20), "P. Unitaire");
           HPDF_Page_TextOut(page1, 24+340+80,     615-(i*20), "Qte.");
           HPDF_Page_TextOut(page1, 24+340+80+60,  615-(i*20), "P. Total");
           HPDF_Page_EndText(page1);
           HPDF_Page_SetRGBFill(page1, 0, 0, 0);
           HPDF_Page_SetLineWidth(page1, 1.0);
           HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
           //HPDF_Page_Rectangle(page1, 20, 550-(i*24), 550, 24);
           HPDF_Page_Rectangle(page1, 20,            610-(i*20), 340, 20);
           HPDF_Page_Rectangle(page1, 20+340,        610-(i*20), 80, 20);
           HPDF_Page_Rectangle(page1, 20+340+80,     610-(i*20), 60,  20);
           HPDF_Page_Rectangle(page1, 20+340+80+60,  610-(i*20), 80, 20);
           HPDF_Page_Stroke(page1);
        }
       else {
            NSString *qte=@"";
            const char *desc=NULL;
            const char *com= NULL;
            const char *pu= NULL;
            const char *pt= NULL;
            //NSString *pu=@"";
            NSLigneCommande *ln;
           
           //char str[20] = {0};
           //sprintf(str, "%.2f %c %d",123.50,120+i,120+i);
          
           if(i-1 < [_lstLigneCommande count]){
             ln = [_lstLigneCommande objectAtIndex:i-1];
             qte = ln.qte;
             dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
             NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
             NSFavoris *fav = [lfav objectAtIndex:0];
             desc = [fav.tDesc cStringUsingEncoding:NSISOLatin1StringEncoding];
             com  = [ln.commentaire cStringUsingEncoding:NSISOLatin1StringEncoding];
             
             //NSString *prixu
             NSString *prixu  =  [NSString stringWithFormat:@"%@",fav.tPrix];
             pu = [prixu cStringUsingEncoding:NSASCIIStringEncoding];
               
               
            float pptot = [ln.qte intValue] * [fav.tPrix  floatValue];
            NSString *prixt  =  [NSString stringWithFormat:@"%.2f",pptot];
            pt = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
               
               prixTotalTTC += pptot;
               
             }
           
           
        HPDF_Page_SetRGBFill(page1, 0, 0, 0);
        HPDF_Page_SetLineWidth(page1, 1.0);
        HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
        //HPDF_Page_Rectangle(page1, 20, 550-(i*24), 550, 24);
        HPDF_Page_Rectangle(page1, 20,            610-(i*32), 340, 32);
        HPDF_Page_Rectangle(page1, 20+340,        610-(i*32), 80, 32);
        HPDF_Page_Rectangle(page1, 20+340+80,     610-(i*32), 60,  32);
        HPDF_Page_Rectangle(page1, 20+340+80+60,  610-(i*32), 80, 32);
        HPDF_Page_Stroke(page1);
        
        HPDF_Page_BeginText(page1);
        HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
        HPDF_Page_SetTextLeading (page1,8.0);
           
        HPDF_Page_TextOut(page1, 24,             631-(i*32),  desc);
           
        HPDF_Page_SetFontAndSize(page1, fontEn, 7.0);
        HPDF_Page_TextRect(page1,
                              28,
                              628-(i*32),
                              340+20,
                              628-(i*32)-40,
                              com ,
                              HPDF_TALIGN_LEFT, NULL
                           );
        HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
        HPDF_Page_TextRect(page1,
                          22+340,
                          631-(i*32),
                          24+340+70,
                          631-(i*32)-32,
                          pu,
                          HPDF_TALIGN_RIGHT, NULL);
           
           
        HPDF_Page_TextRect(page1,
                          24+340+80,
                          631-(i*32),
                          24+340+70+60,
                          631-(i*32)-32,
                          [qte cStringUsingEncoding:NSASCIIStringEncoding],
                          HPDF_TALIGN_RIGHT, NULL
                          
                          );
           
           
        HPDF_Page_TextRect(page1,
                          24+340+80+60,
                          631-(i*32),
                          24+340+70+60+80,
                          631-(i*32)-32,
                          pt,
                          HPDF_TALIGN_RIGHT, NULL
                          );
        HPDF_Page_EndText(page1);

        }
        NSLog(@"%d",610-(i*32));
    }

    const char *pttc=NULL;
    const char *pht= NULL;
    const char *tva= NULL;
    
    NSString *prixt  =  [NSString stringWithFormat:@"%.2f",prixTotalTTC];
    pttc   = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    prixt  =  [NSString stringWithFormat:@"%.2f",prixTotalTTC/1.206];
    pht    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    float res = prixTotalTTC - (prixTotalTTC/1.206);
    prixt  =  [NSString stringWithFormat:@"%.2f",res];
    tva    = [prixt cStringUsingEncoding:NSASCIIStringEncoding];
    
    for(int i=0;i<3;i++){
        const char *tmp=NULL;
             if(i==0)tmp = pttc;
        else if(i==1)tmp = pht;
        else if(i==2)tmp = tva;
        
        HPDF_Page_SetLineWidth(page1, 1.0);
        HPDF_Page_SetRGBStroke(page1, 0, 0, 0);
        HPDF_Page_Rectangle(page1, 20+340+80+60, 78-(i*20), 80, 20);
        HPDF_Page_Stroke(page1);

        HPDF_Page_BeginText(page1);
        HPDF_Page_SetFontAndSize(page1, fontEn, 10.0);
        HPDF_Page_SetTextLeading (page1,8.0);
        
        HPDF_Page_TextRect(page1,
                           20+340+80+60,
                           94-(i*20),
                           
                           24+340+70+60+80,
                           94-(i*20)-20,
                           tmp,
                           HPDF_TALIGN_RIGHT, NULL
                           );

        //HPDF_Page_TextOut(page1, 20+340+80+60,   84-(i*20),  "12000.00");
        
        HPDF_Page_EndText(page1);
        }
    
    //logo
    path = [[NSBundle mainBundle] pathForResource:@"logoprnt" ofType:@"png"];
    pathCString = [path cStringUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"[libharu] LoadPngImageFromFile path:%@\n pathCString:%s", path, pathCString);
    HPDF_Image image = HPDF_LoadPngImageFromFile(pdf, pathCString);
    HPDF_Page_DrawImage(page1, image, 20, 750, 242, 61);
    
    

    
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
