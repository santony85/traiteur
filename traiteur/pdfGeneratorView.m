//
//  pdfGeneratorView.m
//  traiteur
//
//  Created by Antony on 31/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "pdfGeneratorView.h"
#import "dataBase.h"
#import "apiconnect.h"
#import "GlobalV.h"
#import "UYLGenericPrintPageRenderer.h"
#import "MyPrintPageRenderer.h"

@interface pdfGeneratorView (){

    dataBase *sqlManager;
    apiconnect *connect;
     NSMutableArray *readlst;

}

@end

@implementation pdfGeneratorView

@synthesize webView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    connect = [[apiconnect alloc] init];
    
    NSLog(@"%@",_commande.idcommande);
    readlst  = [connect getPrint :_commande.idcommande :idMagasin :@"bdcu" :catalogue];
    NSLog(@"%@",readlst);
    //getPrint:(NSString *)collection :(NSString *)idname;
    //readlst = [connect getPrint:@"lignecommande" :@"idcommande" :commande.idcommande];
       // Create and open pdf file
    //[self createPDFFile];
    //[self loadPDFFile];
   

    NSString *urlString =  [NSString stringWithFormat:@"http://be-instore.fr/upload/pdf/%@.pdf",_commande.idcommande];
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView  loadRequest:urlRequest];
    
    
   }



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

-(IBAction)printdoc
{
    
    
    
   // NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"jpg"];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"test.pdf"];
    
    NSData *myData = [NSData dataWithContentsOfFile: path];
    
    
    NSString *urls =  [NSString stringWithFormat:@"http://be-instore.fr/upload/pdf/%@.pdf",_commande.idcommande];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urls]];
    [request setHTTPMethod: @"GET"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    

    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    //NSLog(@"%@",returnData);

    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: returnData] ) {
        
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = returnData;
        
        //UYLGenericPrintPageRenderer *renderer = [[UYLGenericPrintPageRenderer alloc] init];
        //renderer.headerText = @"";
        //renderer.footerText = @"";
        
        MyPrintPageRenderer *myRenderer = [[MyPrintPageRenderer alloc] init];
        
        
        UIViewPrintFormatter *formatter = [self.webView viewPrintFormatter];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
        CGSize titleSize = [myRenderer.jobTitle sizeWithFont:font];
        myRenderer.headerHeight = myRenderer.footerHeight = titleSize.height + HEADER_FOOTER_MARGIN_PADDING;

        [myRenderer addPrintFormatter:formatter startingAtPageAtIndex:0];
        // Set our custom renderer as the printPageRenderer for the print job.
        pic.printPageRenderer = myRenderer;
        
        
        //[renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
        //pic.printPageRenderer = renderer;
        

        
        
        [pic presentFromRect:CGRectMake(10, 10, 0, 0) inView:self.webView animated:YES completionHandler: ^(UIPrintInteractionController *ctrl, BOOL ok, NSError *e) {
           /* CDVPluginResult* pluginResult =
            [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            
            [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:_callbackId];*/
        }];
        
    }
    
}


- (IBAction)createPDFFile
{
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"test.pdf"];
    PDFService *service = [PDFService instance];
    service.client = _client;
    service.commande = _commande;
    service.lstLigneCommande =_lstLigneCommande;
    service.delegate = self;
    [service createPDFFile:path];
    service.delegate = nil;
}

- (IBAction)loadPDFFile
{
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"test.pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark -
#pragma mark delegate method


- (void)service:(PDFService *)service
didFailedCreatingPDFFile:(NSString *)filePath
        errorNo:(HPDF_STATUS)errorNo
       detailNo:(HPDF_STATUS)detailNo
{
    NSString *message = [NSString stringWithFormat:@"Couldn't create a PDF file at %@\n errorNo:0x%04lx detalNo:0x%04lx",
                         filePath,
                         errorNo,
                         detailNo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PDF creation error"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] ;
    [alert show];
}


- (IBAction)affRetour:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}
@end
