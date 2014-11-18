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



@interface detailCommandeView ()<MLAlertViewDelegate>{
    NSArray *headerTxt;
    dataBase *sqlManager;
    //NSMutableArray *readlst;
    float prixTotalTTC;
    int tmpTag;
    UITextField *passwordTextField;
    int iimode;
    float tmpRem;
    int isNewProdUp;
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
    _hdNom.text = _client.nom;
    _hdPrenom.text = _client.prenom;
    _hdAdresse.text = _client.adresse;
    _hdCp.text = _client.cp;
    _hdVille.text = _client.ville;
    _hdTel.text = _client.tel;
    _hdEmail.text = _client.numcarte;
    
    _dateL.text = _commande.dateliv;
    _heureL.text = _commande.heureliv;
    _hdRemise.text = [NSString stringWithFormat:@"%@ %@",_commande.remise,@"%"];
    //readlst  = [[NSMutableArray  alloc] init];
    sqlManager = [[dataBase alloc] initDatabase:0];
    
    //readlst = [sqlManager findLigneCommande:_commande.idcommande];
    //readlst = _lstLigneCommande;
    //NSLog(@"%@",readlst);
    tmpTag =0;
    
     UIBarButtonItem *addAttachButton = [[UIBarButtonItem alloc] initWithTitle:(@"  Modifier la remise  ") style:UIBarButtonItemStyleBordered target:self action:@selector(modRem:)];
     
     UIBarButtonItem *spacedButton = [[UIBarButtonItem alloc] initWithTitle:(@"     ") style:UIBarButtonItemStyleBordered target:self action:nil];
     
     UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:(@"  Nouveau produit ") style:UIBarButtonItemStyleBordered target:self action:@selector(newHsProd:)];
     self.navigationItem.rightBarButtonItems = @[addAttachButton,spacedButton,sendButton];
    
    
    
  }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
prixTotalTTC=0.0;
    return [_lstLigneCommande count] ;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"lstCommandeCell";
    
    lstCommandeCell *cell = (lstCommandeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[lstCommandeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:indexPath.row];
    cell.qte.text = ln.qte;
    
    
    
    NSArray *lfav = [sqlManager findFavorisId:ln.idproduit];
    NSFavoris *fav = [lfav objectAtIndex:0];
    cell.desc.text = fav.tDesc;
    cell.pu.text = [NSString stringWithFormat: @"%.2f €",[fav.tPrix floatValue]];
    
    cell.commentaire.text = ln.commentaire;
    
    float pptot = [ln.qte intValue] * [fav.tPrix  floatValue];
    
    prixTotalTTC += pptot;
    
    
    tmpRem = prixTotalTTC * [_commande.remise floatValue]/100.0;
    
    _hdSommeRemise.text = [NSString stringWithFormat: @"%.2f €",tmpRem];
    
    cell.ptot.text = [NSString stringWithFormat: @"%.2f €",pptot];
    
    _totalTTC.text = [NSString stringWithFormat: @"%.2f €",prixTotalTTC - tmpRem];
    cell.delBut.tag = indexPath.row;//[ln.idlignecommande intValue];
    
    NSLog(@"%ld",cell.delBut.tag);
    cell.btQte.tag = indexPath.row;
    cell.btCom.tag = indexPath.row;
    return cell;
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
    
    if([_client.idclient isEqualToString:@""]){
      //save client
      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
      [dict setObject:_client.nom forKey:@"nom"];
      [dict setObject:_client.prenom forKey:@"prenom"];
      [dict setObject:_client.adresse forKey:@"adresse"];
      [dict setObject:_client.cp forKey:@"cp"];
      [dict setObject:_client.ville forKey:@"ville"];
      [dict setObject:_client.tel forKey:@"tel"];
      [dict setObject:_client.numcarte forKey:@"email"];
      _client.idclient=[connect postUnit :@"client" :dict];
      }
    NSLog(@"%@",_client.idclient);
    if([_commande.idcommande isEqualToString:@""]){
      //save commande
      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
      [dict setObject:_client.idclient forKey:@"idclient"];
      [dict setObject:_commande.numcommande forKey:@"numcommande"];
      [dict setObject:_commande.datecommande forKey:@"datecommande"];
      [dict setObject:_commande.dateliv forKey:@"dateliv"];
      [dict setObject:_commande.heureliv forKey:@"heureliv"];
      [dict setObject:_commande.remise forKey:@"remise"];
      [dict setObject:@"en cours" forKey:@"status"];
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
        [dict setObject:_commande.status forKey:@"status"];
        //_commande.idcommande=[connect postUnit :@"commande" :dict];
        [connect updateUnit:@"commande" :dict :_commande.idcommande];
        
    }
    //save ligne commane
    NSLog(@"%@",_commande.idcommande);
    [connect delUnit:@"lignecommande" :@"idcommande" :_commande.idcommande];
    for(int i=0;i<[_lstLigneCommande count];i++){
      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:4];
      NSLigneCommande *ln = [_lstLigneCommande objectAtIndex:i];
      [dict setObject:_commande.idcommande forKey:@"idcommande"];
      [dict setObject:ln.idproduit forKey:@"idproduit"];
      [dict setObject:ln.qte forKey:@"qte"];
      [dict setObject:ln.commentaire forKey:@"commentaire"];
      [connect postUnit :@"lignecommande" :dict];
      }
    
}

- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismiss];

    if((long)buttonIndex==0){
        //
    }
    else{

             if(iimode==0)[_lstLigneCommande removeObjectAtIndex:tmpTag];
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
                 _hdRemise.text = [NSString stringWithFormat:@"%@ %@",_commande.remise,@"%"];
                 
             }
        [self.tableView reloadData];
        
    }
}


- (IBAction)livrerCommande:(id)sender{
    apiconnect *connect = [[apiconnect alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:7];
    [dict setObject:_client.idclient forKey:@"idclient"];
    [dict setObject:_commande.numcommande forKey:@"numcommande"];
    [dict setObject:_commande.datecommande forKey:@"datecommande"];
    [dict setObject:_commande.dateliv forKey:@"dateliv"];
    [dict setObject:_commande.heureliv forKey:@"heureliv"];
    [dict setObject:_commande.remise forKey:@"remise"];
    [dict setObject:@"clos" forKey:@"status"];
    [connect updateUnit:@"commande" :dict :_commande.idcommande];
}

- (IBAction)affPrint:(id)sender {
    
    
    
    pdfGeneratorView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"pdfGeneratorView"];
    dvc.client = _client;
    dvc.commande = _commande;
    dvc.lstLigneCommande = _lstLigneCommande;
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
    iimode=3;
    tmpTag = [sender tag];
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

-(void)affPopUp{
    isNewProdUp =1;
    [_deshc becomeFirstResponder];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_hsProdView setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)hidePopUp{
    isNewProdUp =0;
    [self.view endEditing:YES];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_hsProdView setAlpha:0.0];
    [UIView commitAnimations];
}

- (IBAction)newHsProd:(id)sender {
    if(isNewProdUp==0)[self affPopUp];
}

- (IBAction)closePopup:(id)sender {
    
    [self hidePopUp];
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
    else{
        [textField resignFirstResponder];
        if(  (! [_deshc.text isEqualToString:@""])
           &&(! [_commhc.text isEqualToString:@""])
           &&(! [_qtehc.text isEqualToString:@""])
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



@end
