//
//  accueilViewController.m
//  traiteur
//
//  Created by Antony on 17/11/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "accueilViewController.h"

#import "UIColor+HexValue.h"
#import "PPCircleButton.h"
#import "GlobalV.h"


#import "NSFavoris.h"
#import "dataBase.h"
#import "apiconnect.h"
#import "videoViewController.h"



@interface accueilViewController (){
    int isOk;
    int nbClick;
    NSString *tmpcode;
    //NSTimer * myTimer;
    dataBase *sqlManager;
    UIAlertView *alert;
    int ii;
    int numfunct;
}

@end

@implementation accueilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOk = 0;
    nbClick=0;
    tmpcode = @"";
    ii=0;
    _nommag.text = nomMagasin;
    
    UIFont *customFont = [UIFont fontWithName:@"Lobster 1.4" size:47];
    [_nomcata setFont:customFont];
    _nomcata.text = nomcatalogue;

    
}


- (void) resetTimer {
    //count = 0;
    [[self myTimer] invalidate];
    [self setMyTimer:nil];
    [self setMyTimer:[NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(hidePass:)
                                                    userInfo:nil
                                                     repeats:YES]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)affPad:(id)sender{
    [self resetTimer];
    [self affPopUp];
}


- (IBAction)padClick:(id)sender{
    [self resetTimer];
    PPCircleButton *tmp = (PPCircleButton *)sender;
    NSLog(@"%@.", tmp.currentTitle);
    if(nbClick==0)[_ini1 setTitle:tmp.currentTitle forState:UIControlStateNormal];
    else if(nbClick==1)[_ini2 setTitle:tmp.currentTitle forState:UIControlStateNormal];
    
    tmpcode = [NSString stringWithFormat:@"%@%@",tmpcode,tmp.currentTitle];
    
    nbClick++;
}


- (IBAction)delchar:(id)sender {
    [self resetTimer];
    [_ini1 setTitle:@"" forState:UIControlStateNormal];
    [_ini2 setTitle:@"" forState:UIControlStateNormal];
    tmpcode = @"";
    nbClick = 0;
}


-(void)affPopUp{
    [_ini1 setTitle:@"" forState:UIControlStateNormal];
    [_ini2 setTitle:@"" forState:UIControlStateNormal];
    tmpcode = @"";
    nbClick = 0;
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_popupView setAlpha:1.0];
    [UIView commitAnimations];
}


-(void)hidePopUp{
    [self.view endEditing:YES];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_popupView setAlpha:0.0];
    [UIView commitAnimations];
    
}


- (IBAction)hidePass:(id)sender {
    [self hidePopUp];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int myInt = [prefs integerForKey:@"fromvideo"];
    
    NSLog(@"%d",myInt);
    if(myInt==1){
        videoViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"videoViewController"];
        [self presentModalViewController:dvc animated:YES];
        //[prefs setInteger:0 forKey:@"fromvideo"];
    }

    
    
    
    
}


- (IBAction)validBt:(id)sender {
    if((nbClick>1)&&(nbClick<3)){
        if(!sqlManager){
            sqlManager = [[dataBase alloc] initDatabase:0];
        }
        NSMutableArray *tmpHeader = [sqlManager findHeader];
        if(tmpHeader.count == 0){
            [self hidePopUp];
            alert = [[UIAlertView alloc] initWithTitle:@"MISE A JOUR NECESSAIRE"
                                               message:@"DEMARRER LA MISE A JOUR"
                                              delegate:self
                                     cancelButtonTitle:@"Annuler"
                                     otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else{
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *init=[NSString stringWithFormat:@"%@%@",_ini1.currentTitle,_ini2.currentTitle];
            [prefs setObject:init forKey:@"vendeur"];
            [_validOK sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    else {
        if([tmpcode isEqualToString:@"MAJPRO"]){
            numfunct=0;
            [self hidePopUp];
            alert = [[UIAlertView alloc] initWithTitle:@"ALERTE"
                                               message:@"DEMARRER LA MISE A JOUR"
                                              delegate:self
                                     cancelButtonTitle:@"Annuler"
                                     otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        if([tmpcode isEqualToString:@"CONFIG"]){
            numfunct=1;
            [self hidePopUp];
            alert = [[UIAlertView alloc] initWithTitle:@"ALERTE"
                                               message:@"DEMARRER CONFIGURATION"
                                              delegate:self
                                     cancelButtonTitle:@"Annuler"
                                     otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    
    
    
    
}


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
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


-(void)miseAJour{
    NSMutableArray *readlst  = [[NSMutableArray  alloc] init];
    NSMutableArray *produits = [[NSMutableDictionary  alloc] init];
    
    if(!sqlManager){
        sqlManager = [[dataBase alloc] initDatabase:0];
    }
    
    //mise a jour
    apiconnect *connect     = [[apiconnect alloc] init];
    [sqlManager delDataCat];
    [sqlManager resetId];
    NSString *getFirst;
    NSMutableArray *catlst  = [connect NewgetList :catalogue :idMagasin];
    
    

   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
        //_nbUpdFiles.text = [NSString stringWithFormat:@"%d / %lu",i,(unsigned long)[catlst count]];
        
        
            //@try {
                for (int i = 0; i < [catlst count]; i++){
                    _nbUpdFiles.text = [NSString stringWithFormat:@"%d / %lu",i,(unsigned long)[catlst count]];
                    NSLog(@"Nombre de fichier téléchargé : %@",_nbUpdFiles.text);
                    NSArray *cl =[catlst objectAtIndex: i];
                    NSFavoris *fav = [[NSFavoris alloc] init];
                    fav.tFam  = [[catlst objectAtIndex:i] objectForKey:@"Famille"];
                    fav.tTyp  = [[catlst objectAtIndex:i] objectForKey:@"Type"];
                    fav.tDesc = [[catlst objectAtIndex:i] objectForKey:@"Desc"];
                    fav.tPrix = [[catlst objectAtIndex:i] objectForKey:@"Prix"];
                    fav.tGencode = [[catlst objectAtIndex:i] objectForKey:@"Gencode"];
                    fav.tMin = [[catlst objectAtIndex:i] objectForKey:@"min"];
                    fav.tMax = [[catlst objectAtIndex:i] objectForKey:@"max"];
                    fav.tRes = [[catlst objectAtIndex:i] objectForKey:@"reservable"];
                    fav.tPval = [[catlst objectAtIndex:i] objectForKey:@"pval"];
                    NSLog(@"%@",fav.tPval);
                    NSString *tid =[[catlst objectAtIndex:i] objectForKey:@"_id"];
                    fav.tId = tid;
                    int zz = [sqlManager addToDatabase:fav];
                    NSLog(@"id->%@ gencode->%@",tid,fav.tGencode);
                    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://be-instore.fr/upload/catalogueg/%@.jpg",tid]];
                    [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%@",tid] ofType:@"jpg" inDirectory:documentsDirectoryPath];

        /*        }
            }
            @catch (NSException *e) {
                //NSLog(@"%@",e.description);

            }
            @finally {
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ii =ii+1;*/
                [_nbUpdFiles setText:[NSString stringWithFormat:@"%d / %lu",ii,(unsigned long)[catlst count]]];
                [_nbUpdFiles setNeedsDisplay];

          //  });
        
  //  });

        
        
        
        /*
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            // Perform long running process
            
            NSLog(@"Nombre de fichier téléchargé : %@",_nbUpdFiles.text);
            NSArray *cl =[catlst objectAtIndex: i];
            NSFavoris *fav = [[NSFavoris alloc] init];
            fav.tFam  = [[catlst objectAtIndex:i] objectForKey:@"Famille"];
            fav.tTyp  = [[catlst objectAtIndex:i] objectForKey:@"Type"];
            fav.tDesc = [[catlst objectAtIndex:i] objectForKey:@"Desc"];
            fav.tPrix = [[catlst objectAtIndex:i] objectForKey:@"Prix"];
            fav.tGencode = [[catlst objectAtIndex:i] objectForKey:@"Gencode"];
            fav.tMin = [[catlst objectAtIndex:i] objectForKey:@"min"];
            fav.tMax = [[catlst objectAtIndex:i] objectForKey:@"max"];
            fav.tRes = [[catlst objectAtIndex:i] objectForKey:@"reservable"];
            fav.tPval = [[catlst objectAtIndex:i] objectForKey:@"pval"];
            NSLog(@"%@",fav.tPval);
            NSString *tid =[[catlst objectAtIndex:i] objectForKey:@"_id"];
            fav.tId = tid;
            int zz = [sqlManager addToDatabase:fav];
            NSLog(@"id->%@ gencode->%@",tid,fav.tGencode);
            NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://be-instore.fr/upload/catalogueg/%@.jpg",tid]];
            [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%@",tid] ofType:@"jpg" inDirectory:documentsDirectoryPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_nbUpdFiles setText:[NSString stringWithFormat:@"%d / %lu",i,(unsigned long)[catlst count]]];
                [_nbUpdFiles setNeedsDisplay];
                
            });
        }); 

        
        

        */

        
        

        
        // NSLog(@"%d",i);
    }
    ///*mise a jour
    [self hidePopUp2];
}


-(void)affPopUp2{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [_majLoaderView setAlpha:1.0];
    [UIView commitAnimations];
}


-(void)hidePopUp2{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_majLoaderView setAlpha:0.0];
    [UIView commitAnimations];
}


-(void)affPopUp3{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [_configView setAlpha:1.0];
    [UIView commitAnimations];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if((long)buttonIndex==0){
        //cell.qte.text=@"";
    }
    else{
        if(numfunct==0){
            [self affPopUp2];
            [self performSelector:@selector(miseAJour) withObject:nil afterDelay:0.5];
        }
        else if(numfunct==1){
            [self affPopUp3];
            
        }

        //[self miseAJour];
    }
}

-(void)dismissAlert:(UIAlertView*)alertView
{
    [alert dismissWithClickedButtonIndex:1 animated:YES];
    [alert.delegate alertView:alertView clickedButtonAtIndex:1];
}
- (IBAction)hideConfig:(id)sender {
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_configView setAlpha:0.0];
    [UIView commitAnimations];
}
@end
