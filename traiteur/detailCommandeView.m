//
//  detailCommandeView.m
//  traiteur
//
//  Created by Antony on 13/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "detailCommandeView.h"
#import "lstCommandeCell.h"
#import "dataBase.h"
#import "NSLigneCommande.h"
#import "MLAlertView.h"
#import "apiconnect.h"
#import "pdfGeneratorView.h"
#import "NSProduithc.h"
#import "prodhccell.h"
#import "GlobalV.h"
#import "UIColor+CreateMethods.h"

#import "videoViewController.h"
#import "accueilViewController.h"
#import "prohcView.h"

#import "Popup.h"



@interface detailCommandeView ()<MLAlertViewDelegate,PopupDelegate>{
    NSArray *headerTxt;
    dataBase *sqlManager;
    NSMutableArray *readlst;
    float prixTotalTTC;
    int tmpTag;
    UITextField *passwordTextField;
    int iimode;
    float tmpRem;
    int isNewProdUp;
    NSMutableArray *initial;
    NSArray  * typrodhc;
    
    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomingType;
    PopupOutgoingTransitionType outgoingType;
    
    Popup *popper;
    
    NSArray *phcArray;
    NSMutableArray *prodhclst;
    
}



@end

@implementation detailCommandeView


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    prixTotalTTC=0.0;
    tmpRem = 0.0;
    iimode = 0;
    
    isNewProdUp=0;
    
    headerTxt = [NSArray arrayWithObjects:
                 @"Qte.",
                 @"Produit",
                 @"P.U",
                 @"Total",
                 nil];
    
    typrodhc = [NSArray arrayWithObjects:@"Pieces",@"Kg",@"Tranches",@"Morceaux",nil];
    
    _hdNom.text     = [NSString stringWithFormat:@"%@ %@",_client.nom,_client.prenom];
    
    
    if([_commande.internet isEqualToString:@""]){
      _hdAdresse.text = _commande.numcommande;
    }
    else{
       _hdAdresse.text = [NSString stringWithFormat:@"%@ / %@",_commande.numcommande,_commande.internet];
    }
    
    
    _hdCp.text      = _commande.vendeur;
    
    
    _hdVille.text = _client.ville;
    _hdTel.text = _client.tel;
    _hdEmail.text = _client.numcarte;
    
    _hdacompte.text = [NSString stringWithFormat:@"%d %@",[_commande.acompte integerValue],@" €"];
    
    _dateL.text = _commande.dateliv;
    _heureL.text = _commande.heureliv;
    _hdRemise.text = [NSString stringWithFormat:@"%d %@",[_commande.remise integerValue],@"%"];
    readlst  = [[NSMutableArray  alloc] init];
    sqlManager = [[dataBase alloc] initDatabase:0];
    
    //readlst = [sqlManager findLigneCommande:_commande.idcommande];
    //readlst = _lstLigneCommande;
    //NSLog(@"%@",readlst);
    tmpTag =0;
    
    
    _btComment.layer.borderWidth = 1
    ;
    _btComment.layer.borderColor = [UIColor colorWithHex:@"#ff8000" alpha:1].CGColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Commande traiteur" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    self.tableView.tag =0;
    self.tableViewHC.tag =0;
    
    UIBarButtonItem *addAttachButton = [[UIBarButtonItem alloc] initWithTitle:(@"  Admin  ") style:UIBarButtonItemStyleBordered target:self action:@selector(modRem:)];
    
    UIBarButtonItem *spacedButton = [[UIBarButtonItem alloc] initWithTitle:(@"     ") style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:(@" Acompte ") style:UIBarButtonItemStyleBordered target:self action:@selector(modAcompte:)];
    
    UIBarButtonItem *prodButton = [[UIBarButtonItem alloc] initWithTitle:(@" Produit ") style:UIBarButtonItemStyleBordered target:self action:@selector(newHsProd:)];
    
    self.navigationItem.rightBarButtonItems = @[addAttachButton,spacedButton,sendButton,spacedButton,prodButton];
    
    //self.navigationItem.rightBarButtonItems = @[addAttachButton,spacedButton];
    [self getData];
    
    if( ![_commande.idcommande isEqualToString:@"" ]){
        _imgLiv.alpha  = 1.0f;
        _imgPrnt.alpha = 1.0f;
        _imgSup.alpha  = 1.0f;
        
        _btImp.enabled = TRUE;
        _btLiv.enabled = TRUE;
        _btSup.enabled = TRUE;
        
    }
    
    NSLog(@"nb  prod %d",_lstLigneCommande.count);
    NSLog(@"nb  prod %@",_lstLigneCommande);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",isNewProdUp);
    if(isNewProdUp ==0){
        prixTotalTTC=0.0;
        return [_lstLigneCommande count] ;
    }
    else{
        return [readlst count] ;
    }
    
}

-(void)calculPrixTotal{
    float ttb=0.0;
    float ttt=0.0;
    
    NSLog(@"nb  prod %d",_lstLigneCommande.count);
    
    for(int i=0;i<_lstLigneCommande.count;i++){
        if ([[_lstLigneCommande objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:i];
            
            NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
            if(lfav.count != 0){
                NSFavoris *fav = [lfav objectAtIndex:0];
                
                ttb+= [fav.tPrix floatValue]*[ln.qte integerValue];
                
                NSLog(@"%@ %@ %f",fav.tPrix,ln.qte,[fav.tPrix floatValue]*[ln.qte integerValue]);
                //NSFavoris *fav = [lfav objectAtIndex:0];
            }
        }
        else{
           NSProduithc *ln = [_lstLigneCommande objectAtIndex:i];
            
           ttb+= [ln.qte floatValue]*[ln.prix floatValue];
        }
        
        
        
    }
    
    
    
    
    
    float tmpRem = ttb * [_commande.remise floatValue]/100.0;
    ttt = ttb-tmpRem;
    NSLog(@"total brut %f rem %f net %f",ttb,tmpRem,ttt);
    _hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
    _totalTTC.text = [NSString stringWithFormat: @"%.2f €",ttt];
    _pht.text = [NSString stringWithFormat: @"%.2f €",ttt/1.206];
    
    _ptva.text = [NSString stringWithFormat: @"%.2f €",ttt-(ttt/1.206)];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isNewProdUp ==0){
        
        
        static NSString *CellIdentifier = @"lstCommandeCell";
        
        lstCommandeCell *cell = (lstCommandeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[lstCommandeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if ([[_lstLigneCommande objectAtIndex:indexPath.row] isKindOfClass:[NSLigneCommande class]]) {
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:indexPath.row];
            cell.qte.text = ln.qte;
            
            
            NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
            if(lfav.count != 0){
                NSFavoris *fav = [lfav objectAtIndex:0];
                float prixrem = [fav.tPrix  floatValue]*[_commande.remise floatValue]/100.0;
                float npu = [fav.tPrix  floatValue]-prixrem;
            
                // NSLog(@"remise :%f",prixrem);
            
            
                cell.desc.text = fav.tDesc;
                cell.pu.text = [NSString stringWithFormat: @"%.2f €",npu];//[fav.tPrix floatValue]
                cell.commentaire.text = ln.commentaire;
            
            
            
            
                float pptot = [ln.qte intValue] * npu;
                //prixTotalTTC += pptot;
                //tmpRem = prixTotalTTC * [_commande.remise floatValue]/100.0;
                //_hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
                cell.ptot.text = [NSString stringWithFormat: @"%.2f €",pptot];
                // _totalTTC.text = [NSString stringWithFormat: @"%.2f €",prixTotalTTC - tmpRem];
            }
            
        } else {
            NSProduithc *ln = [_lstLigneCommande objectAtIndex:indexPath.row];
            cell.qte.text = ln.qte;
            cell.desc.text = ln.designation;
            cell.pu.text = [NSString stringWithFormat: @"%.2f €",[ln.prix floatValue]];
            cell.commentaire.text = ln.commentaire;
            cell.ptot.text = [NSString stringWithFormat: @"%.2f €",[ln.prix floatValue]*[ln.qte floatValue]];
            /* float pptot = [ln.qte intValue] * [ln.prix  floatValue];
             prixTotalTTC += pptot;
             tmpRem = prixTotalTTC * [_commande.remise floatValue]/100.0;
             _hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
             cell.ptot.text = [NSString stringWithFormat: @"%.2f €",pptot];
             _totalTTC.text = [NSString stringWithFormat: @"%.2f €",prixTotalTTC - tmpRem];*/
            
        }
        cell.delBut.tag = indexPath.row;//[ln.idlignecommande intValue];
        NSLog(@"%ld",cell.delBut.tag);
        cell.btQte.tag = indexPath.row;
        cell.btCom.tag = indexPath.row;
        return cell;
        
    }
    else{
        static NSString *CellIdentifier = @"prodhccell";
        prodhccell *cell = (prodhccell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[prodhccell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.code.text =[[readlst objectAtIndex:indexPath.row] objectForKey:@"code"];
        cell.desc.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"desc"];
        return cell;
    }
    
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(isNewProdUp ==1){
        //prodhccell *cell = (prodhccell*)[tableView dequeueReusableCellWithIdentifier:indexPath];
        
        _popupprod.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"desc"];
        _popupprodc.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"code"];
        
        [_prixhc becomeFirstResponder];
        [self affPopUpqt];
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@   %@",textField.text,string);
    
    
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        // is backspace
        NSLog(@"delete %@   %@",textField.text,string);
        //_popupqte.text = [textField.text substringToIndex:[textField.text length]-5];
        _popupqte.text  = [textField.text substringToIndex:[textField.text length]-1];
        
    }
    
    else _popupqte.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    return YES; //this make iOS not to perform any action
}




- (IBAction)delProduit:(id)sender {
    
    iimode=0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Supprimer\r\n" message:
                          [NSString stringWithFormat: @"Voulez-vous supprimer ce produit"]
                                                   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Valider", nil];
    [alert show];
    
    
    NSLog(@"%ld",[sender tag]);
    
    tmpTag = [sender tag];
    
}

- (IBAction)saveCommande:(id)sender {
    
    
    apiconnect *connect = [[apiconnect alloc] init];
    
    NSString *numCom = [NSString stringWithFormat: @"%.4d",[sqlManager lastCommande]+1 ];
    NSLog(@"%@",numCom);
    

    
    if([_client.idclient isEqualToString:@""]){
        //save client
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:_client.nom forKey:@"nom"];
        [dict setObject:_client.prenom forKey:@"prenom"];
        [dict setObject:idMagasin forKey:@"idmagasin"];
        [dict setObject:catalogue forKey:@"catalogue"];
        //[dict setObject:_client.cp forKey:@"cp"];
        //[dict setObject:_client.ville forKey:@"ville"];
        [dict setObject:_client.tel forKey:@"tel"];
        [dict setObject:_client.numcarte forKey:@"email"];
        _client.idclient=[connect postUnit :@"client" :dict];
    }
    NSLog(@"%@",_client.idclient);
    if([_commande.idcommande isEqualToString:@""]){
        //save commande
        _commande.numcommande = numCom;
        
        if([_commande.internet isEqualToString:@""]){
            _hdAdresse.text = _commande.numcommande;
        }
        else{
            _hdAdresse.text = [NSString stringWithFormat:@"%@ / %@",_commande.numcommande,_commande.internet];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:idMagasin forKey:@"idmagasin"];
        [dict setObject:_client.idclient forKey:@"idclient"];
        [dict setObject:_commande.numcommande forKey:@"numcommande"];
        [dict setObject:_commande.datecommande forKey:@"datecommande"];
        [dict setObject:_commande.dateliv forKey:@"dateliv"];
        [dict setObject:_commande.heureliv forKey:@"heureliv"];
        [dict setObject:_commande.remise forKey:@"remise"];
        [dict setObject:_commande.acompte forKey:@"acompte"];
        [dict setObject:_commande.commentaire forKey:@"commentaire"];
        [dict setObject:@"en cours" forKey:@"status"];
        [dict setObject:_commande.vendeur forKey:@"vendeur"];
        [dict setObject:catalogue forKey:@"catalogue"];
        [dict setObject:_commande.internet forKey:@"internet"];
        
        //[dict setObject:@"20.00" forKey:@"accompte"];
        
        _commande.idcommande=[connect postUnit :@"commande" :dict];
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:_client.idclient forKey:@"idclient"];
        [dict setObject:_commande.numcommande forKey:@"numcommande"];
        [dict setObject:_commande.datecommande forKey:@"datecommande"];
        [dict setObject:_commande.dateliv forKey:@"dateliv"];
        [dict setObject:_commande.heureliv forKey:@"heureliv"];
        [dict setObject:_commande.remise forKey:@"remise"];
        [dict setObject:_commande.acompte forKey:@"acompte"];
        [dict setObject:_commande.commentaire forKey:@"commentaire"];
        [dict setObject:@"en cours" forKey:@"status"];
        [dict setObject:_commande.vendeur forKey:@"vendeur"];
        [dict setObject:_commande.idcommande forKey:@"idcommande"];
        [dict setObject:_commande.internet forKey:@"internet"];
        
        //[dict setObject:@"20.00" forKey:@"accompte"];
        
        [connect updateUnit:@"commande" :dict :_commande.idcommande];
        
    }
    //save ligne commane
    NSLog(@"%@",_commande.idcommande);
    
    [connect delUnit:@"lignecommande" :@"idcommande" :_commande.idcommande];
    [connect delUnit:@"produithc"     :@"idcommande" :_commande.idcommande];
    
    for(int i=0;i<[_lstLigneCommande count];i++){
        
        if ([[_lstLigneCommande objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:4];
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:i];
            [dict setObject:_commande.idcommande forKey:@"idcommande"];
            [dict setObject:ln.idproduit forKey:@"idproduit"];
            //[dict setObject:ln.id forKey:@"id"];
            [dict setObject:ln.qte forKey:@"qte"];
            [dict setObject:ln.commentaire forKey:@"commentaire"];
            [connect postUnit :@"lignecommande" :dict];
        }
        else{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:5];
            NSProduithc *ln = [_lstLigneCommande objectAtIndex:i];
            [dict setObject:_commande.idcommande forKey:@"idcommande"];
            [dict setObject:ln.designation forKey:@"designation"];
            [dict setObject:ln.qte forKey:@"qte"];
            [dict setObject:ln.commentaire forKey:@"commentaire"];
            [dict setObject:ln.prix forKey:@"prix"];
            [dict setObject:ln.total forKey:@"total"];
            
            [dict setObject:catalogue forKey:@"rayon"];
            [dict setObject:catalogue forKey:@"prepa"];
            
            //[dict setObject:ln.ref forKey:@"ref"];
            //[dict setObject:ln.nom forKey:@"nom"];
            
            [connect postUnit :@"produithc" :dict];
        }
    }
    
    _imgLiv.alpha  = 1.0f;
    _imgPrnt.alpha = 1.0f;
    _imgSup.alpha  = 1.0f;
    
    _btImp.enabled = TRUE;
    _btLiv.enabled = TRUE;
    _btSup.enabled = TRUE;
}

- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismiss];
    
    if((long)buttonIndex==0){
        //
    }
    else{
        
        if(iimode==0){
          [_lstLigneCommande removeObjectAtIndex:tmpTag];
        }
        else if(iimode==1){
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:tmpTag];
            ln.qte = passwordTextField.text ;
            
        }
        else if(iimode==2){
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:tmpTag];
            ln.commentaire = passwordTextField.text ;
            
        }
        else if(iimode==3){
            _commande.remise = passwordTextField.text ;
            _hdRemise.text = [NSString stringWithFormat:@"%d %@",[_commande.remise integerValue],@"%"];
            
        }
        else if(iimode==4){
            iimode=3;
            
            if([passwordTextField.text isEqualToString:@"85200"]){

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Modifier la remise"
                                                                message:[NSString stringWithFormat: @""]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Ok", nil];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            passwordTextField = [alertView textFieldAtIndex:0];
            [passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
            //NSCommande *ln = [_commande objectAtIndex:[sender tag]];
            passwordTextField.text = _commande.remise;
            [alertView show];
            
           }


        }
        else if(iimode==5){
            _commande.acompte = passwordTextField.text ;
            _hdacompte.text = [NSString stringWithFormat:@"%ld %@",[_commande.acompte integerValue],@" €"];
            
        }
        else if(iimode==6){
            _commande.commentaire = passwordTextField.text ;
            //_hdacompte.text = [NSString stringWithFormat:@"%ld %@",[_commande.acompte integerValue],@" €"];
            
        }
        [self.tableView reloadData];
        [self calculPrixTotal] ;
    }
}


- (IBAction)addHc:(id)sender {
    [self hidePopUp];
    NSProduithc *ln = [[NSProduithc alloc] init];
    
    NSInteger selectedIndex = [_typeProdQte selectedSegmentIndex];
    
    ln.designation = [NSString stringWithFormat:@"%@ - %@",_popupprodc.text,_popupprod.text];
    ln.commentaire = @"";
    ln.qte         = [NSString stringWithFormat:@"%@ %@",_popupqte.text,[typrodhc objectAtIndex:selectedIndex]];//_popupqte.text;
    ln.prix        = @"";
    ln.idcommande  = _commande.idcommande;
    //ln.ref = _popupprodc.text;
    //ln.nom = _popupprod.text;
    
    ///???????????????????????????????????
    
    [_lstLigneCommande addObject:ln];
    [self.tableView reloadData];
    [self calculPrixTotal] ;
}


- (IBAction)livrerCommande:(id)sender{
    /*apiconnect *connect = [[apiconnect alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
    [dict setObject:_client.idclient forKey:@"idclient"];
    [dict setObject:_commande.numcommande forKey:@"numcommande"];
    [dict setObject:_commande.datecommande forKey:@"datecommande"];
    [dict setObject:_commande.dateliv forKey:@"dateliv"];
    [dict setObject:_commande.heureliv forKey:@"heureliv"];
    [dict setObject:_commande.remise forKey:@"remise"];
    [dict setObject:_commande.acompte forKey:@"acompte"];
    [dict setObject:@"clos" forKey:@"status"];
    [connect updateUnit:@"commande" :dict :_commande.idcommande];*/
    
    
    
    
    apiconnect *connect = [[apiconnect alloc] init];
    
    NSString *numCom = [NSString stringWithFormat: @"%.4d",[sqlManager lastCommande]+1 ];
    NSLog(@"%@",numCom);
    
    
    
    if([_client.idclient isEqualToString:@""]){
        //save client
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:_client.nom forKey:@"nom"];
        [dict setObject:_client.prenom forKey:@"prenom"];
        [dict setObject:idMagasin forKey:@"idmagasin"];
        [dict setObject:catalogue forKey:@"catalogue"];
        //[dict setObject:_client.cp forKey:@"cp"];
        //[dict setObject:_client.ville forKey:@"ville"];
        [dict setObject:_client.tel forKey:@"tel"];
        [dict setObject:_client.numcarte forKey:@"email"];
        _client.idclient=[connect postUnit :@"client" :dict];
    }
    NSLog(@"%@",_client.idclient);
    if([_commande.idcommande isEqualToString:@""]){
        //save commande
        _commande.numcommande = numCom;
        
        if([_commande.internet isEqualToString:@""]){
            _hdAdresse.text = _commande.numcommande;
        }
        else{
            _hdAdresse.text = [NSString stringWithFormat:@"%@ / %@",_commande.numcommande,_commande.internet];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:idMagasin forKey:@"idmagasin"];
        [dict setObject:_client.idclient forKey:@"idclient"];
        [dict setObject:_commande.numcommande forKey:@"numcommande"];
        [dict setObject:_commande.datecommande forKey:@"datecommande"];
        [dict setObject:_commande.dateliv forKey:@"dateliv"];
        [dict setObject:_commande.heureliv forKey:@"heureliv"];
        [dict setObject:_commande.remise forKey:@"remise"];
        [dict setObject:_commande.acompte forKey:@"acompte"];
        [dict setObject:_commande.commentaire forKey:@"commentaire"];
        [dict setObject:@"en cours" forKey:@"status"];
        [dict setObject:_commande.vendeur forKey:@"vendeur"];
        [dict setObject:catalogue forKey:@"catalogue"];
        [dict setObject:_commande.internet forKey:@"internet"];
        
        //[dict setObject:@"20.00" forKey:@"accompte"];
        
        _commande.idcommande=[connect postUnit :@"devis" :dict];
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
        [dict setObject:_client.idclient forKey:@"idclient"];
        [dict setObject:_commande.numcommande forKey:@"numcommande"];
        [dict setObject:_commande.datecommande forKey:@"datecommande"];
        [dict setObject:_commande.dateliv forKey:@"dateliv"];
        [dict setObject:_commande.heureliv forKey:@"heureliv"];
        [dict setObject:_commande.remise forKey:@"remise"];
        [dict setObject:_commande.acompte forKey:@"acompte"];
        [dict setObject:_commande.commentaire forKey:@"commentaire"];
        [dict setObject:@"en cours" forKey:@"status"];
        [dict setObject:_commande.vendeur forKey:@"vendeur"];
        [dict setObject:_commande.idcommande forKey:@"idcommande"];
        [dict setObject:_commande.internet forKey:@"internet"];
        
        //[dict setObject:@"20.00" forKey:@"accompte"];
        
        [connect updateUnit:@"devis" :dict :_commande.idcommande];
        
    }
    //save ligne commane
    NSLog(@"%@",_commande.idcommande);
    
    [connect delUnit:@"lignecommandedevis" :@"idcommande" :_commande.idcommande];
    [connect delUnit:@"produithcdevis"     :@"idcommande" :_commande.idcommande];
    
    for(int i=0;i<[_lstLigneCommande count];i++){
        
        if ([[_lstLigneCommande objectAtIndex:i] isKindOfClass:[NSLigneCommande class]]){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:4];
            NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:i];
            [dict setObject:_commande.idcommande forKey:@"idcommande"];
            [dict setObject:ln.idproduit forKey:@"idproduit"];
            //[dict setObject:ln.id forKey:@"id"];
            [dict setObject:ln.qte forKey:@"qte"];
            [dict setObject:ln.commentaire forKey:@"commentaire"];
            [connect postUnit :@"lignecommandedevis" :dict];
        }
        else{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:5];
            NSProduithc *ln = [_lstLigneCommande objectAtIndex:i];
            [dict setObject:_commande.idcommande forKey:@"idcommande"];
            [dict setObject:ln.designation forKey:@"designation"];
            [dict setObject:ln.qte forKey:@"qte"];
            [dict setObject:ln.commentaire forKey:@"commentaire"];
            [dict setObject:ln.prix forKey:@"prix"];
            
            //[dict setObject:ln.ref forKey:@"ref"];
            //[dict setObject:ln.nom forKey:@"nom"];
            
            [connect postUnit :@"produithcdevis" :dict];
        }
    }

    
    //print devis//
    
    pdfGeneratorView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pdfGeneratorView"];
    dvc.client = _client;
    dvc.commande = _commande;
    dvc.lstLigneCommande = _lstLigneCommande;
    dvc.typeb = @"bddu";
    [self presentModalViewController:dvc animated:YES];
    
    
}


- (IBAction)affPrint:(id)sender {
    
    pdfGeneratorView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pdfGeneratorView"];
    dvc.client = _client;
    dvc.commande = _commande;
    dvc.lstLigneCommande = _lstLigneCommande;
    dvc.typeb = @"bdcu";
    [self presentModalViewController:dvc animated:YES];
    
    
    //[self.navigationController pushViewController:   dvc animated:YES];
    
}


- (IBAction)modQte:(id)sender {
    iimode=1;
    tmpTag = [sender tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Modifier la Quantité"
                                                        message:[NSString stringWithFormat: @""]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    [passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:[sender tag]];
    passwordTextField.text = ln.qte;
    
    [alertView show];
}


- (IBAction)modCom:(id)sender {
    iimode=2;
    tmpTag = [sender tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Modifier le commentaire"
                                                        message:[NSString stringWithFormat: @""]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    //[passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:[sender tag]];
    passwordTextField.text = ln.commentaire;
    
    [alertView show];
}


- (IBAction)modRem:(id)sender {
    iimode=4;
    tmpTag = [sender tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saisissez le mot de passe"
                                                        message:[NSString stringWithFormat: @""]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    [passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    //NSCommande *ln = [_commande objectAtIndex:[sender tag]];
    passwordTextField.text = @"";
    
    [alertView show];
}

- (IBAction)modAcompte:(id)sender {
    iimode=5;
    tmpTag = [sender tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Montant de l'acompte"
                                                        message:[NSString stringWithFormat: @""]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    [passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    //NSCommande *ln = [_commande objectAtIndex:[sender tag]];
    passwordTextField.text = @"";
    
    [alertView show];
}

- (IBAction)modComGen:(id)sender {
    iimode=6;
    tmpTag = [sender tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Commentaire"
                                                        message:[NSString stringWithFormat: @""]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    //[passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    //NSCommande *ln = [_commande objectAtIndex:[sender tag]];
    passwordTextField.text = @"";
    
    [alertView show];
}






-(void)affPopUp{
    _deshc.text = @"";
    _commhc.text = @"";
    _qtehc.text = @"";
    _prixhc.text = @"";
    _popupqte.text =@"0";
    isNewProdUp =1;
    [self.tableViewHC reloadData];
    //[_deshc becomeFirstResponder];
    [_mchbar becomeFirstResponder];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [_hsProdView setAlpha:1.0];
    [UIView commitAnimations];
    
}


- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);
    
    
    phcArray = [[NSMutableArray  alloc] init];
    phcArray = stringArray;

}


-(void)hidePopUp{
    isNewProdUp =0;
    [self.tableView reloadData];
    [self.view endEditing:YES];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [_hsProdView setAlpha:0.0];
    [UIView commitAnimations];
}

- (IBAction)newHsProd:(id)sender {
    
    popper = [[Popup alloc] initWithTitle:@"Ajouter un produit" subTitle:@"" textFieldPlaceholders:@[@"Désignation", @"Prix unitaire", @"Quantité"] cancelTitle:@"Annuler" successTitle:@"Valider" cancelBlock:^{
        NSLog(@"Cancel block 3");
    } successBlock:^{
        NSLog(@"Success block 3");
        NSString *textFromBox1 = [phcArray objectAtIndex:0];
        NSString *textFromBox2 = [phcArray objectAtIndex:1];
        NSString *textFromBox3 = [phcArray objectAtIndex:2];
        
        NSProduithc *ln = [[NSProduithc alloc] init];
        
        NSInteger selectedIndex = [_typeProdQte selectedSegmentIndex];
        
        ln.designation = [NSString stringWithFormat:@"%@",textFromBox1];
        ln.commentaire = @"";
        ln.qte         = [NSString stringWithFormat:@"%@",textFromBox3];//_popupqte.text;
        ln.prix        = [NSString stringWithFormat:@"%@",textFromBox2];
        ln.idcommande  = _commande.idcommande;
        float total = [ln.qte floatValue] * [ln.prix floatValue];
        ln.total       = [NSString stringWithFormat:@"%.2f",total];
        
        
        [_lstLigneCommande addObject:ln];
        [self.tableView reloadData];
        [self calculPrixTotal] ;
        
        
        
        
        
        
        
    }];
    
    
    [popper setKeyboardTypeForTextFields:@[@"DEFAULT", @"NUMBERSANDPUNCTUATION", @"NUMBERSANDPUNCTUATION"]];
    
    [popper setDelegate:self];
    [popper setBackgroundBlurType:blurType];
    [popper setIncomingTransition:incomingType];
    [popper setOutgoingTransition:outgoingType];
    [popper setRoundedCorners:YES];
    [popper showPopup];
    
    
    //if(isNewProdUp==0)[self affPopUp];
    
    /*prohcView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"prohcView"];
    
    dvc.didDismiss = ^(NSString *data) {
        // this method gets called in MainVC when your SecondVC is dismissed
        NSLog(@"%@",data);
    };
    
    
    //dvc.client = _client;
    //dvc.commande = _commande;
    //dvc.lstLigneCommande = _lstLigneCommande;
    //dvc.typeb = @"bddu";
    [self presentModalViewController:dvc animated:YES];*/
    
}

- (IBAction)closePopup:(id)sender {
    
    [self hidePopUp];
    [self hidePopUpqt];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _deshc) {
        [_commhc becomeFirstResponder];
    }
    else if (textField == _commhc) {
        [_qtehc becomeFirstResponder];
    }
    
    else if (textField == _qtehc) {
        [_prixhc becomeFirstResponder];
    }
    else if (textField == _prixhc) {
        [self hidePopUpqt];
        [self addHc:nil];
    }
    else{
        [textField resignFirstResponder];
        if(  (! [_deshc.text  isEqualToString:@""])
           &&(! [_commhc.text isEqualToString:@""])
           &&(! [_qtehc.text  isEqualToString:@""])
           &&(! [_prixhc.text isEqualToString:@""])
           ){
            
            _btNext.alpha =1.0f;
            //alpha
            _btNext.enabled =YES;
            //enabled
            
        }
    }
    
    
    
    return YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // called only once
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:NO];
    //self.tableViewHC.allowsSelection = NO;
    //self.tableViewHC.scrollEnabled = NO;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    if([searchText isEqualToString:@""])[self getData];
    else{
        NSString *uppercase = [searchBar.text uppercaseString];
        
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"(code CONTAINS[cd] %@) or (desc CONTAINS[cd] %@)",
                                  uppercase,uppercase,uppercase];
        
        
        readlst = [initial filteredArrayUsingPredicate:predicate];
        
        [searchBar setShowsCancelButton:NO animated:YES];
        //[searchBar resignFirstResponder];
        self.tableViewHC.allowsSelection = YES;
        self.tableViewHC.scrollEnabled = YES;
        [self.tableViewHC reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableViewHC.allowsSelection = YES;
    self.tableViewHC.scrollEnabled = YES;
    [self getData];
    [self.tableViewHC reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
    
    /* NSString *uppercase = [searchBar.text uppercaseString];
     
     NSPredicate *predicate = [NSPredicate
     predicateWithFormat:@"(code CONTAINS[cd] %@) or (desc CONTAINS[cd] %@)",
     uppercase,uppercase,uppercase];
     
     
     readlst = [initial filteredArrayUsingPredicate:predicate];
     
     [searchBar setShowsCancelButton:NO animated:YES];
     [searchBar resignFirstResponder];
     self.tableViewHC.allowsSelection = YES;
     self.tableViewHC.scrollEnabled = YES;
     [self.tableViewHC reloadData];*/
}


- (void)getData{
    
    NSString *sourceFileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phc" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *csvArray = [[NSMutableArray alloc] init];
    csvArray = [[sourceFileString componentsSeparatedByString:@"\r"] mutableCopy];
    NSLog(@"%@",csvArray);
    
    initial  = [[NSMutableArray  alloc] init];
    readlst  = [[NSMutableArray  alloc] init];
    for(int i=0;i<csvArray.count;i++){
        NSString *keysString = [csvArray objectAtIndex:i];
        NSArray *keysArray = [keysString componentsSeparatedByString:@";"];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
        [dict setObject:[keysArray objectAtIndex:0] forKey:@"code"];
        [dict setObject:[keysArray objectAtIndex:1] forKey:@"desc"];
        
        [initial  addObject:dict];
        [readlst  addObject:dict];
        
    }
    
    
    // NSString *keysString = [csvArray objectAtIndex:0];
    
    //NSArray *keysArray = [keysString componentsSeparatedByString:@";"];
    
    // [csvArray removeObjectAtIndex:0];
    
    /*readlst     = [connect getAllFile :@"vehicule"];
     initial     = [connect getAllFile :@"vehicule"];
     //marquelst   = [connect getListOf  :@"marque" :readlst];
     //energielst  = [connect getListOf  :@"EnergieLibelle" :readlst];
     
     
     [self.tableViewHC reloadData];
     //[mappDelegate unLoader];
     
     
     //_nbChoix.text = [NSString stringWithFormat:@"%d véhicules selectionnés",[readlst count] ];
     */
    
    [self calculPrixTotal] ;
    
    
}

-(void)affPopUpqt{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [_popup setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)hidePopUpqt{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [_popup setAlpha:0.0];
    [UIView commitAnimations];
}



- (IBAction)endAppli:(id)sender {
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int myInt = [prefs integerForKey:@"fromvideo"];
    NSLog(@"%d",myInt);
    if(myInt==1){
        videoViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"videoViewController"];
        [self presentModalViewController:dvc animated:YES];
        [prefs setInteger:0 forKey:@"fromvideo"];
    }
    else{
        accueilViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"accueilViewController"];
        [self presentModalViewController:dvc animated:YES];
        [prefs setInteger:0 forKey:@"fromvideo"];
    }
    

    
}
@end
