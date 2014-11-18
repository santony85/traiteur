//
//  pdfGeneratorView.h
//  traiteur
//
//  Created by Antony on 31/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFService.h"
#import "NSCommande.h"
#import "NSClient.h"



@interface pdfGeneratorView : UIViewController<PDFServiceDelegate,UIPrintInteractionControllerDelegate>{
    
    UIWebView *webView;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)createPDFFile;
- (IBAction)loadPDFFile;

-(IBAction)printdoc;

@property (strong, nonatomic) NSCommande *commande;
@property (strong, nonatomic) NSClient *client;
@property (strong, nonatomic) NSMutableArray *lstLigneCommande;

- (IBAction)affRetour:(id)sender;

@end
