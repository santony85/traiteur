//
//  infoclientViewContoller.m
//  traiteur
//
//  Created by Antony on 06/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "infoclientViewContoller.h"
#import "GlobalV.h"
#import "planbViewController.h"
#import "planbAppDelegate.h"
#import "NSClient.h"
#import "dataBase.h"
#import "apiconnect.h"
#import "clientCell.h"
#import "UIColor+CreateMethods.h"
#import "NSCommande.h"
#import "NSProduithc.h"

@implementation infoclientViewContoller{
    dataBase *sqlManager;
    NSMutableArray *readlst;
    NSString *idClientSel;
    NSString * idCommandeSel;
    int modeRecherche;
    NSCommande *tmpcommande;
    NSMutableArray *lstLigneCommande;
    NSArray *heures;
    NSArray *minutes;
    int isDateTime;
    UIAlertView *alert;
    int isInternet;
    NSString *internet;
    
}







- (void)viewDidLoad
  {
  [super viewDidLoad];
      
      heures  = [[NSArray alloc]         initWithObjects:@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21" , nil];
    
    minutes  = [[NSArray alloc]         initWithObjects:@"00",@"15",@"30",@"45", nil];

    sqlManager = [[dataBase alloc] initDatabase:0];
    readlst = [[NSArray alloc] init];


      isDateTime=0;
      idClientSel   = @"";
      idCommandeSel = @"";
      modeRecherche = 0;
      isInternet=0;
      internet=@"";
      
      [self becomeFirstResponder];
      [_nom becomeFirstResponder];
      [_nom addTarget:self action:@selector(updateLabelUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
      
      //self.datePicker = [[UIDatePicker alloc] init];
      //self.datePicker.datePickerMode = UIDatePickerModeDate;
      //[self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

      NSDate *currentTime = [NSDate date];
      [self.datePicker setMinimumDate:currentTime];
       //self.datePicker.minuteInterval = 30;

      
      self.datePicker.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
      self.timePicker.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
      self.dtPicker.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    
      [self.view endEditing:YES];
}

-(NSMutableArray *)setListTmpCli :(NSMutableArray *)impList{
    NSMutableArray * tmplst = [[NSMutableArray alloc] init];
    for(int i=0;i<[impList count];i++){
        
        NSClient *client = [[NSClient alloc] init];
        client.idclient = [[readlst objectAtIndex:i] objectForKey:@"_id"];
        client.nom      = [[readlst objectAtIndex:i] objectForKey:@"nom"];
        client.prenom   = [[readlst objectAtIndex:i] objectForKey:@"prenom"];
        //client.adresse  = [[readlst objectAtIndex:i] objectForKey:@"adresse"];
        //client.cp       = [[readlst objectAtIndex:i] objectForKey:@"cp"];
        //client.ville    = [[readlst objectAtIndex:i] objectForKey:@"ville"];
        client.tel      = [[readlst objectAtIndex:i] objectForKey:@"tel"];
        client.numcarte = [[readlst objectAtIndex:i] objectForKey:@"email"];
        
        [tmplst addObject:client];
    }
    
    return tmplst;
}
-(NSMutableArray *)setListTmpCom :(NSMutableArray *)impList{
    NSMutableArray * tmplst = [[NSMutableArray alloc] init];
    for(int i=0;i<[impList count];i++){
        
        NSCommande *commande = [[NSCommande alloc] init];

        commande.numcommande = [[readlst objectAtIndex:i] objectForKey:@"numcommande"];
        commande.datecommande = [[readlst objectAtIndex:i] objectForKey:@"datecommande"];
        commande.dateliv = [[readlst objectAtIndex:i] objectForKey:@"dateliv"];
        commande.heureliv =[[readlst objectAtIndex:i] objectForKey:@"heureliv"];
        commande.idmagasin = [[readlst objectAtIndex:i] objectForKey:@"idmagasin"];
        commande.idclient = idClientSel;
        commande.idcommande = [[readlst objectAtIndex:i] objectForKey:@"_id"];
        commande.status = [[readlst objectAtIndex:i] objectForKey:@"status"];
        commande.remise = [[readlst objectAtIndex:i] objectForKey:@"remise"];
        commande.vendeur = [[readlst objectAtIndex:i] objectForKey:@"vendeur"];
        commande.catalogue = [[readlst objectAtIndex:i] objectForKey:@"catalogue"];
        [tmplst addObject:commande];
    }
    
    return tmplst;
}
-(NSMutableArray *)setListTmpLigneCom :(NSMutableArray *)impList{
    NSMutableArray * tmplst = [[NSMutableArray alloc] init];
    for(int i=0;i<[impList count];i++){
        
        NSLigneCommande *lcom = [[NSLigneCommande alloc] init];

        lcom.commentaire = [[readlst objectAtIndex:i] objectForKey:@"commentaire"];
        lcom.idcommande  = [[readlst objectAtIndex:i] objectForKey:@"idcommande"];
        lcom.idproduit   = [[readlst objectAtIndex:i] objectForKey:@"idproduit"];
        lcom.qte         = [[readlst objectAtIndex:i] objectForKey:@"qte"];
        [tmplst addObject:lcom];

    }
    
    return tmplst;
}




NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter){
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if (textField == _tel){
        NSString *filter = @"##.##.##.##.##";
        if(!filter) return YES; // No filter provided, allow anything
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
        
        return NO;
        
    }
  /*else if (textField == _nom){
      
          readlst = [sqlManager findClient:textField.text];
          if([readlst count]>0){
              //afflist gauche
              [self affListClient:readlst];
          }
      else  [self cacheList];
          return YES;
          
      }*/
  else if (textField == _recnumcommande){
      NSString *filter = @"######";
      if(!filter) return YES; // No filter provided, allow anything
      NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
      if(range.length == 1 && // Only do for single deletes
         string.length < range.length &&
         [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
      {
          // Something was deleted.  Delete past the previous number
          NSInteger location = changedString.length-1;
          if(location > 0)
          {
              for(; location > 0; location--)
              {
                  if(isdigit([changedString characterAtIndex:location]))
                  {
                      break;
                  }
              }
              changedString = [changedString substringToIndex:location];
          }
      }
      
      textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
      if([changedString length]>1){
          _btreccomm.alpha =1.0f;
          _btreccomm.enabled = YES;
      }
      return NO;
      
  }
  else if (textField == _dateprepa){
        NSString *filter = @"##/##/####";
        if(!filter) return YES; // No filter provided, allow anything
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
      
      if(textField.text.length >=10)NSLog(@"Check Date");
        textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
        
        return NO;
        
    }
  else if (textField == _cp){
        NSString *filter = @"#####";
        if(!filter) return YES; // No filter provided, allow anything
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
        
        return NO;
        
    }
  else if (textField == _heureprepa){
        NSString *filter = @"##h##";
        if(!filter) return YES; // No filter provided, allow anything
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);

        return NO;
        
    }
  else return YES;
  }

- (void)updateLabelUsingContentsOfTextField:(id)sender{
    
    
    
    //readlst = [sqlManager findClient:((UITextField *)sender).text:0];
    
    apiconnect *connect = [[apiconnect alloc] init];
    //save client
    readlst = [connect getLike:@"client" :@"nom" :((UITextField *)sender).text];
    
    readlst = [self setListTmpCli:readlst];
    
    
    if([readlst count]>0){
        //afflist gauche
        [self affListClient];
    }
    else  [self cacheList];
    
}

-(void)affListClient{
    
    [self.tableView reloadData];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_formView setCenter:CGPointMake(513+90, 250)];
    [_tableView setCenter:CGPointMake(148, 237)];
    [UIView commitAnimations];
}

-(void)cacheList{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_formView setCenter:CGPointMake(513, 250)];
    [_tableView setCenter:CGPointMake(-276, 237)];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
  {
    if (textField == _dateprepa){
        //self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        isDateTime=1;
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [_dateView setCenter:CGPointMake(512, 593)];
        _timePicker.hidden = YES;
        _datePicker.hidden = YES;
        _dtPicker.hidden = NO;
        [UIView commitAnimations];
        return NO;
    }
    else if (textField == _heureprepa){
        isDateTime=2;
          //self.datePicker.datePickerMode = UIDatePickerModeTime;
          [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
          [UIView beginAnimations:NULL context:NULL];
          [UIView setAnimationDuration:0.4];
          [UIView setAnimationDelegate:self];
          [_dateView setCenter:CGPointMake(512, 593)];
          _timePicker.hidden = NO;
          _datePicker.hidden = YES;
          _dtPicker.hidden = YES;
          [UIView commitAnimations];
          return NO;
      }
    else{
        isDateTime=0;
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [_dateView setCenter:CGPointMake(512, 1000)];
        [UIView commitAnimations];
    }
      
    return YES;
  }


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nom) {
        [_prenom becomeFirstResponder];
    }
    else if (textField == _prenom) {
        [_nbPersonne becomeFirstResponder];
    }
    
    else if (textField == _nbPersonne) {
        [_tel becomeFirstResponder];
    }
    
   /* else if (textField == _cp) {
        [_ville becomeFirstResponder];
    }
    else if (textField == _ville) {
        [_tel becomeFirstResponder];
    }*/
    else if (textField == _tel) {

       // [_dateprepa becomeFirstResponder];
       // [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    else if (textField == _dateprepa) {
        [_heureprepa becomeFirstResponder];
    }
    /*else if (textField == _heureprepa) {
        [_nbPersonne becomeFirstResponder];
    }*/
    else{
        [textField resignFirstResponder];
        if(   (! [_nom.text isEqualToString:@""])
            &&(! [_prenom.text isEqualToString:@""])
            &&(! [_tel.text isEqualToString:@""])
            &&(! [_dateprepa.text isEqualToString:@""])
            &&(! [_heureprepa.text isEqualToString:@""])
           ){
            
            _btNext.alpha =1.0f;
        //alpha
            _btNext.enabled =YES;
        //enabled
        
        }
        
        
        
    }
    
    
    return YES;
}
- (IBAction)RechercheCommande:(id)sender {
    
}

-(NSMutableArray *)setListProdHC :(NSMutableArray *)impList :(NSMutableArray *)tmplst{
    //NSMutableArray * tmplst = [[NSMutableArray alloc] init];
    for(int i=0;i<[impList count];i++){
        NSProduithc *lcom = [[NSProduithc alloc] init];
        lcom.idproduit = [[readlst objectAtIndex:i] objectForKey:@"_id"];
        lcom.commentaire = [[readlst objectAtIndex:i] objectForKey:@"commentaire"];
        lcom.idcommande  = [[readlst objectAtIndex:i] objectForKey:@"idcommande"];
        lcom.designation = [[readlst objectAtIndex:i] objectForKey:@"designation"];
        lcom.prix        = [[readlst objectAtIndex:i] objectForKey:@"prix"];
        lcom.qte         = [[readlst objectAtIndex:i] objectForKey:@"qte"];
        [tmplst addObject:lcom];
        
    }
    
    return tmplst;
}
- (IBAction)affListProd:(id)sender {
    //create numero de commande
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyddMM"];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    NSString *dateInStringFormated2 = [dateFormatter2 stringFromDate:currentTime];
    lstLigneCommande = [[NSMutableArray alloc] init];
    
    
    NSClient *client = [[NSClient alloc] init];
    client.nom = _nom.text;
    client.prenom = _prenom.text;
    //client.adresse= _adresse.text;
    //client.cp= _cp.text;
    //client.ville= _ville.text;
    client.tel= _tel.text;
    client.numcarte= _nbPersonne.text;
    client.idclient = idClientSel;
    if([idClientSel isEqualToString:@""])NSLog(@"Nouveau Client");
    else NSLog(@"Client");
    
    NSString *numCom = [NSString stringWithFormat: @"%.4d",[sqlManager lastCommande]+1 ];
    NSLog(@"%@",numCom);
    
    NSCommande *commande = [[NSCommande alloc] init];
    if([idCommandeSel isEqualToString:@""]){
      commande.numcommande = numCom;
      commande.datecommande = dateInStringFormated2;
      commande.dateliv = _dateprepa.text;
      commande.heureliv =_heureprepa.text;
      commande.remise = @"0";
      //commande.catalogue = catalogue;

      commande.idclient = idClientSel;//[NSString stringWithFormat:@"%d",idClientSel];
      //int nb = [sqlManager addCommande:commande];
      commande.idcommande = @"";
      
      }
    else {
        
  
        //commande = tmpcommande;
        apiconnect *connect = [[apiconnect alloc] init];
        NSArray *tmpcomm = [connect getSpec:@"commande" :@"_id" :idCommandeSel ];
        
        commande.numcommande = [[tmpcomm objectAtIndex:0] objectForKey:@"numcommande"];
        commande.datecommande = [[tmpcomm objectAtIndex:0] objectForKey:@"datecommande"];
        
        //commande.dateliv = [[tmpcomm objectAtIndex:0] objectForKey:@"dateliv"];
        //commande.heureliv =[[tmpcomm objectAtIndex:0] objectForKey:@"heureliv"];
        
        commande.dateliv = _dateprepa.text;
        commande.heureliv =_heureprepa.text;
        
        commande.idmagasin = [[tmpcomm objectAtIndex:0] objectForKey:@"idmagasin"];
        commande.idclient = idClientSel;
        commande.idcommande = [[tmpcomm objectAtIndex:0] objectForKey:@"_id"];
        commande.status = [[tmpcomm objectAtIndex:0] objectForKey:@"status"];
        commande.remise = [[tmpcomm objectAtIndex:0] objectForKey:@"remise"];
        commande.vendeur = [[tmpcomm objectAtIndex:0] objectForKey:@"vendeur"];
        commande.catalogue = [[tmpcomm objectAtIndex:0] objectForKey:@"catalogue"];
        
        
        
        
        //apiconnect *connect = [[apiconnect alloc] init];
        readlst = [connect getSpec:@"lignecommande" :@"idcommande" :commande.idcommande];
        lstLigneCommande = [self setListTmpLigneCom:readlst];
        readlst = [connect getSpec:@"produithc" :@"idcommande" :commande.idcommande];
        lstLigneCommande = [self setListProdHC:readlst :lstLigneCommande];
        }
    
    
    commande.internet = internet;
    modeRecherche = 4;
    NSLog(@"%@",tmpcommande);
    planbViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"planbViewController"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myInt = [prefs stringForKey:@"vendeur"];
    
    
    commande.vendeur = myInt;
    
    dvc.client = client;
    dvc.commande = commande;
    dvc.lstLigneCommande = lstLigneCommande;
    
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:   dvc animated:YES];
}
- (IBAction)affListCommandesClient:(id)sender {
    
    apiconnect *connect = [[apiconnect alloc] init];
    //save client
    readlst = [connect getSpec:@"commande" :@"idclient" :idClientSel];
    readlst = [self setListTmpCom:readlst];
    NSLog(@"%@",readlst);
    //readlst = [sqlManager findCommande:[NSString stringWithFormat:@"%@",idClientSel]:0];
    if([readlst count]>0){
        modeRecherche = 1;
        //afflist gauche
        [self affListClient];
    }
    else  [self cacheList];
}
- (IBAction)delAll:(id)sender {
    _nom.text=@"";
    _prenom.text=@"";
    _adresse.text=@"";
    _cp.text=@"";
    _ville.text=@"";
    _tel.text=@"";
    _dateprepa.text=@"";
    _heureprepa.text=@"";
    _nbPersonne.text=@"";
    //_remise.text=@"";
    _btNext.alpha =.5f;
    //alpha
    _btNext.enabled =NO;
    idClientSel   = @"";
    idCommandeSel = 0;
    _btrecherchecom.alpha = .5f;
    _btrecherchecom.enabled = NO;
    modeRecherche =0;
    [self cacheList];
    
}

//*********************************
//*********************************

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#395771" alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 32)];
    NSString *sectionTitle;
    if(modeRecherche == 0)sectionTitle = @"Clients";
    else sectionTitle = @"Commandes";
    label.text = sectionTitle;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:label];
  return headerView;
  }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [readlst count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)indexPath{
    
    return 32.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"clientCell";
    
    clientCell *cell = (clientCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[clientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(modeRecherche == 0){
      NSClient *tmpcli = [readlst objectAtIndex:indexPath.row];
      cell.nom.text = [NSString stringWithFormat: @"%@ %@",tmpcli.nom,tmpcli.prenom];
      cell.adresse.text = tmpcli.tel;
      cell.cpville.text = @"";//[NSString stringWithFormat: @"%@ %@",tmpcli.,tmpcli.ville];
    }
    else if(modeRecherche == 1){
        NSCommande *tmpcli = [readlst objectAtIndex:indexPath.row];
        cell.nom.text      = [NSString stringWithFormat: @"%@ le : %@",tmpcli.numcommande,tmpcli.datecommande];
        cell.adresse.text  = [NSString stringWithFormat: @"Livr. le %@ a %@",tmpcli.dateliv,tmpcli.heureliv];
        cell.cpville.text  = [NSString stringWithFormat: @"status : %@  vendeur : %@",tmpcli.status,tmpcli.vendeur];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(modeRecherche == 0){
      NSClient *tmpcli = [readlst objectAtIndex:indexPath.row];
      
      _nom.text=tmpcli.nom;
      _prenom.text=tmpcli.prenom;
      //_adresse.text=tmpcli.adresse;
      //_cp.text=tmpcli.cp;
      //_ville.text=tmpcli.ville;
      _tel.text=tmpcli.tel;
      _nbPersonne.text = tmpcli.numcarte;
      [self cacheList];
      [_dateprepa becomeFirstResponder];
      idClientSel = tmpcli.idclient;
      _btrecherchecom.alpha = 1.0f;
      _btrecherchecom.enabled = YES;
    }
    else if(modeRecherche == 1){
        tmpcommande = [readlst objectAtIndex:indexPath.row];
        _dateprepa.text = tmpcommande.dateliv;
        _heureprepa.text=tmpcommande.heureliv;
        
        [self cacheList];
        [self.view endEditing:YES];
        _btNext.alpha =1.0f;
        _btNext.enabled =YES;
        idCommandeSel = tmpcommande.idcommande;

    }
}
- (IBAction)affRecComm:(id)sender {
    NSLog(@"%ld",[sender tag]);
    
    isInternet =[sender tag];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_reccommview setCenter:CGPointMake(512, 384)];
    [_recnumcommande becomeFirstResponder];
    [UIView commitAnimations];
}
- (IBAction)hidereccomm:(id)sender {
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_reccommview setCenter:CGPointMake(512, -384)];
    [_nom becomeFirstResponder];
    [UIView commitAnimations];
    _btreccomm.alpha =.5f;
    _btreccomm.enabled = NO;
    _recnumcommande.text = @"";
    
}
- (IBAction)ValidDate:(id)sender {
    if(isDateTime==1){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *convertedString = [dateFormatter stringFromDate:_dtPicker.date];
     _dateprepa.text = [NSString stringWithFormat:@"%@", convertedString];
    [_heureprepa becomeFirstResponder];
    }
    else if(isDateTime==2){
      NSInteger hour = [_timePicker selectedRowInComponent:0];
      NSInteger minute = [_timePicker selectedRowInComponent:1];
        NSString *convertedString = [NSString stringWithFormat:@"%@h%@",[heures objectAtIndex:hour],[minutes objectAtIndex:minute]];
        _heureprepa.text =convertedString;
    }
    
    if(   (! [_nom.text isEqualToString:@""])
       &&(! [_prenom.text isEqualToString:@""])
       &&(! [_tel.text isEqualToString:@""])
       &&(! [_dateprepa.text isEqualToString:@""])
       &&(! [_heureprepa.text isEqualToString:@""])
       ){
        [_heureprepa resignFirstResponder];
        _btNext.alpha =1.0f;
        //alpha
        _btNext.enabled =YES;
        //enabled
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [_dateView setCenter:CGPointMake(512, 1000)];
        [UIView commitAnimations];
    }

}

- (IBAction)recherchecommandenum:(id)sender {
    
    if(isInternet==0){
        
    
    
    NSLog(@"%@",_recnumcommande.text);
    apiconnect *connect = [[apiconnect alloc] init];
    //save client
    NSString *numCom = [NSString stringWithFormat: @"%.4d",[_recnumcommande.text intValue] ];
    NSArray *tmpcomm = [connect getSpecIdc:@"commande" :@"numcommande" :numCom];
   //NSArray *tmpcomm = [sqlManager findCommande:[NSString stringWithFormat:@"%@",_recnumcommande.text]:1];
   if([tmpcomm count]>0){
       tmpcommande = [tmpcomm objectAtIndex:0];
       NSLog(@"%@",[[tmpcomm objectAtIndex:0] objectForKey:@"idclient"]);
       NSArray *tcli = [connect getSpec:@"client" :@"_id" :[[tmpcomm objectAtIndex:0] objectForKey:@"idclient"]];
       //NSArray *tcli = [sqlManager findClient:tmpcommande.idclient:1];
       NSClient *tmpcli = [tcli objectAtIndex:0];
       _nom.text=[[tcli objectAtIndex:0] objectForKey:@"nom"];
       _prenom.text=[[tcli objectAtIndex:0] objectForKey:@"prenom"];
       
       //_adresse.text=tmpcli.adresse;
       //_cp.text=tmpcli.cp;
       //_ville.text=tmpcli.ville;
       
       _tel.text=[[tcli objectAtIndex:0] objectForKey:@"tel"];
       
       _dateprepa.text = [[tmpcomm objectAtIndex:0] objectForKey:@"dateliv"];
       _heureprepa.text= [[tmpcomm objectAtIndex:0] objectForKey:@"heureliv"];
       
       _nbPersonne.text = [[tcli objectAtIndex:0] objectForKey:@"email"];
       
       idCommandeSel = [[tmpcomm objectAtIndex:0] objectForKey:@"_id"];
       idClientSel   = [[tmpcomm objectAtIndex:0] objectForKey:@"idclient"];
       
       
       
      // tmpcommande = [readlst objectAtIndex:0];
       //_dateprepa.text = tmpcommande.dateliv;
       //_heureprepa.text=tmpcommande.heureliv;
       
       [self cacheList];
       //_btNext.alpha =1.0f;
       //_btNext.enabled =YES;
       //idCommandeSel = [tmpcommande.idcommande intValue];
       
       
       [self.view endEditing:YES];
       _btNext.alpha =1.0f;
       _btNext.enabled =YES;
       
    }
   else{
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Attention"
                                                       message: @"La commande n'existe pas !" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alert show];

   }
  [self hidereccomm:nil];
  [self.view endEditing:YES];
  }
    
    /// commande internet
    else{
        internet=_recnumcommande.text;
        NSLog(@"ici");
        [self hidereccomm:nil];
        [self.view endEditing:YES];
    }
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if(component==0){
        
        return heures.count;
    }
    else {

     return minutes.count;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    if(component==0)return [heures objectAtIndex:row];
    else return [minutes objectAtIndex:row];
    
}




@end
