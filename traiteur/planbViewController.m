//
//  planbViewController.m
//  traiteur
//
//  Created by 2B on 17/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "planbViewController.h"
#import "categorieViewCell.h"
#import "UIColor+CreateMethods.h"
#import "NSFavoris.h"
#import "dataBase.h"
#import "produitcell.h"
#import "BorderButton.h"
//#import "MLAlertView.h"
#import "detailCommandeView.h"
#import "apiconnect.h"
#import "NSProduithc.h"

#import "zoomViewController.h"


@interface planbViewController (){
    NSMutableDictionary *produits;
    NSArray *produitsSectionTitles;
    NSMutableArray *readlst;
    
    int selectedId;
    NSInteger selectedRow;
    NSInteger selectedHd;
    dataBase *sqlManager;
    apiconnect *connect;
    NSInteger numberOfCells;
    NSInteger thetag;
    UITextField *passwordTextField;
    NSArray  * typrodhc;
    NSMutableArray *initial;
    NSMutableArray *allFav;
}

@end

@implementation planbViewController

//@synthesize delegate = _delegate;

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    readlst  = [[NSMutableArray  alloc] init];
    produits = [[NSMutableDictionary  alloc] init];
    allFav = [[NSMutableArray  alloc] init];
    
    typrodhc = [NSArray arrayWithObjects:@"Pieces",@"Kg",@"Tranches",@"Morceaux",nil];
    
    sqlManager = [[dataBase alloc] initDatabase:0];
    
    NSString *dep =@"";
    
    NSMutableArray *hd = [sqlManager findHeader];
   /* NSMutableArray *hd = [NSMutableArray array];
    [hd addObject:@"APERITIFS"];
    [hd addObject:@"BUFFETS"];
    [hd addObject:@"COCKTAIL DINATOIRE"];
    [hd addObject:@"PLATEAUX REPAS"];
    
    [hd addObject:@"MENUS"];
    [hd addObject:@"PLATEAUX FDM"];
    
    [hd addObject:@"ENTREES"];
    [hd addObject:@"PLATS PREPARES"];
    
    [hd addObject:@"ROTISSERIE"];
    [hd addObject:@"FROMAGES"];
    [hd addObject:@"BOULANGERIE"];
    [hd addObject:@"PATISSERIES"];*/
    
    dep = [hd objectAtIndex: 0];
    
    for (int i = 0; i < [hd count]; i++){
        NSArray *dataZZ = [sqlManager findLine:[hd objectAtIndex: i]];
        
        if(i==0)dep = [dataZZ objectAtIndex: 0];
        
        [produits setObject:dataZZ forKey:[hd objectAtIndex: i]];
    }
    
    produitsSectionTitles = hd;
    readlst = [sqlManager findFavoris:dep];
    allFav = [sqlManager findAllFavoris];
    initial = readlst;
    
    
    selectedId=0;
    selectedRow=0;
    selectedHd=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardDidHide: (NSNotification *) notif {
    [self hidePopUp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [produitsSectionTitles count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:section];
    NSArray *sectionAnimals = [produits objectForKey:sectionTitle];
    return [sectionAnimals count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [produitsSectionTitles objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"categorieViewCell";
    
    categorieViewCell *cell = (categorieViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[categorieViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [produits objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    cell.titre.text = animal;
    

    
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#ff8000" alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, tableView.bounds.size.width - 10, 32)];
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:section];
    label.text = sectionTitle;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    //label.font = [UIFont boldSystemFontOfSize:14];
    label.font = [UIFont fontWithName:@"SF-UI-Text-SemiBold" size:17];
    [headerView addSubview:label];
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    readlst  = [[NSArray  alloc] init];
    
    int nbTot =0;
    for(int i=0;i<indexPath.section;i++){
        NSString *sectionTitle = [produitsSectionTitles objectAtIndex:i];
        NSArray *sectionAnimals = [produits objectForKey:sectionTitle];
        nbTot +=[sectionAnimals count];
        //NSLog(@"%d",[sectionAnimals count]);
    }
    
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [produits objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    
    selectedId = nbTot;
    selectedRow=indexPath.row;
    selectedHd=indexPath.section;
    
    //NSLog(@"%d->%d=%d (%@)",indexPath.row,indexPath.section,indexPath.row+nbTot,animal);
    readlst = [sqlManager findFavoris:animal];
    NSLog(@"%@",readlst);
    [self.collectionView reloadData];
    
    _mchbar.text=@"";
    [_mchbar setShowsCancelButton:NO animated:YES];
    [_mchbar resignFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)indexPath {
    
    return 32.0;
}


//**********************************//
//**********************************//
//**********************************//
//**********************************//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //return 11;
    numberOfCells=[readlst count];
    return [readlst count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    produitcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"produitcell" forIndexPath:indexPath];
    NSFavoris * fav = [readlst objectAtIndex:indexPath.row];
    
    cell.desc.text = [NSString stringWithFormat:@"%@", fav.tDesc];//fav.tDesc;
    
    
    cell.prix.text = [NSString stringWithFormat: @"%.2f€",[fav.tPrix floatValue]];
    
    
    cell.qte.text=@"";
    
    for(int i=0;i<[_lstLigneCommande count];i++){
      NSLigneCommande *lcom = [_lstLigneCommande objectAtIndex:i];
        if([lcom.idproduit isEqualToString:fav.tId])cell.qte.text=lcom.qte;
    }
    
    
    cell.qte.tag=indexPath.row;
    
    
    
    
    cell.fav = fav;
    
    cell.id.text= fav.tId;
    
    //[self isInCommande:fav.tId];
    
    cell.tag = [fav.idFav intValue];
    
    NSLog(@"%@",fav.idFav);
    cell.imgProd.image = [self loadImage:[NSString stringWithFormat:@"%@",fav.tId] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    //cell.addBt.enabled = NO;
    // Configure the cell...
    cell.imgProd.tag = indexPath.row;//[fav.idFav intValue];
 
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onImageViewClicked:)];

    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [cell.imgProd addGestureRecognizer:singleTap];
    [cell.imgProd setUserInteractionEnabled:YES];
    
    return cell;
}


-(void)onImageViewClickedX:(id)sender{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_zoomview setAlpha:0.0];
    [UIView commitAnimations];
    
    
    
}

-(void)onImageViewClicked:(id)sender {
    
    NSFavoris * fav = [readlst objectAtIndex:((UIGestureRecognizer *)sender).view.tag];
   NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    _zoomimg.image = [self loadImage:[NSString stringWithFormat:@"%@",fav.tId] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    
    
    /*UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onImageViewClickedX:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_zoomimg addGestureRecognizer:singleTap];
    [_zoomimg setUserInteractionEnabled:YES];
    
    
    NSLog(@"clicked %ld", [fav.idFav intValue]);
    //NSString *imgName = [meimg image].accessibilityIdentifier;
    //NSLog(@"%@",imgName);
    
    /*[UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [_zoomview setAlpha:1.0];
    [UIView commitAnimations];*/
    
    
    
    zoomViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"zoomViewController"];
    [self presentModalViewController:dvc animated:YES];
    
    
    [dvc affImg:fav.tId];
    
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1; // The number of sections we want
}


-(void)affPopUp {
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [_popup setAlpha:1.0];
    [UIView commitAnimations];
}


-(void)hidePopUp {
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [_popup setAlpha:0.0];
    [UIView commitAnimations];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // produitcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"produitcell" forIndexPath:indexPath];
    produitcell *cell = (produitcell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    _popupprod.text = cell.desc.text;
    
    if([cell.qte.text isEqualToString:@""])_popupqte.text = @"0";
    else _popupqte.text = cell.qte.text;
    
    cell.qte.enabled = YES;
    [cell.qte becomeFirstResponder];
    
    NSFavoris * fav = cell.fav;
    
    if(([fav.tMin intValue] > 0) || ([fav.tMax intValue] > 0)) {
        _qteMinMax.hidden = NO;
        _qteMinMax.text = [NSString stringWithFormat:@"Attention quantité entre %@ et %@",fav.tMin,fav.tMax];
    }
    else _qteMinMax.hidden = YES;
    
    if([fav.tPval intValue] > 0) {
        _selType.hidden = NO;
    }
    else _selType.hidden = YES;
    
    [self affPopUp];
}


//**********************************//
//**********************************//
//**********************************//
//**********************************//
- (IBAction)backToPlayer:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)affCommande:(id)sender {
    
    detailCommandeView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailCommandeView"];
    dvc.client = _client;
    dvc.commande = _commande;
    dvc.lstLigneCommande = _lstLigneCommande;
    [self.navigationController pushViewController:   dvc animated:YES];
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0] ;
    produitcell *cell = (produitcell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.qte.enabled = NO;
    cell.addBt.enabled=YES;
    
    // [self hidePopUp];
    
    NSFavoris * fav = cell.fav;
    
    int iMin = [fav.tMin intValue];
    int iMax = [fav.tMax intValue];
    
    if([textField.text intValue] != 0 ) {
        if(iMin==0 && iMax==0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Commentaire"
                                                                message:[NSString stringWithFormat: @"%@ x %@\r\nAjouter un commentaire",cell.qte.text,cell.desc.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Ok", nil];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            passwordTextField = [alertView textFieldAtIndex:0];
            [alertView show];
            thetag = textField.tag;
            [textField resignFirstResponder];
            return YES;
        }
        else {
            
            NSLog(@"%@",_popupqte.text);
            int valLu = [_popupqte.text intValue];
            if((valLu >= iMin)&&(valLu <= iMax)){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Commentaire"
                                                                    message:[NSString stringWithFormat: @"%@ x %@\r\nAjouter un commentaire",cell.qte.text,cell.desc.text]
                                                                    delegate:self
                                                                    cancelButtonTitle:@"Cancel"
                                                                    otherButtonTitles:@"Ok", nil];
                
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                passwordTextField = [alertView textFieldAtIndex:0];
                [alertView show];
                thetag = textField.tag;
                [textField resignFirstResponder];
                return YES;
            }
            
            cell.qte.enabled = YES;
            [cell.qte becomeFirstResponder];
            [self affPopUp];
            
            return NO;
        }
        
    }
    else {
        return NO;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%li",(long)buttonIndex);
    //[alertView dismiss];
    
    NSLog(@"%@",passwordTextField.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:thetag inSection:0] ;
    produitcell *cell = (produitcell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if((long)buttonIndex==0) {
        cell.qte.text=@"";
    }
    else {
        
        if([cell.fav.tPval intValue] == 0) {
            
            //addToCommand
            NSLigneCommande *lcom = [[NSLigneCommande alloc] init];
            
            if ([passwordTextField.text isKindOfClass:[NSString class]]) {
                lcom.commentaire = passwordTextField.text;
            }
            else {
                lcom.commentaire = @"";
            }
            
            lcom.idcommande = _commande.idcommande;
            lcom.idproduit  = [NSString stringWithFormat: @"%@",cell.fav.tId];
            lcom.id = cell.id.text;
            lcom.qte        = cell.qte.text;
            [_lstLigneCommande addObject:lcom];
        }
        else {
            
            NSInteger selectedIndex = [_selType selectedSegmentIndex];
            
            NSProduithc *ln = [[NSProduithc alloc] init];
            ln.designation = [NSString stringWithFormat:@"%@ - %@",cell.fav.tGencode,cell.fav.tDesc];
            
            if ([passwordTextField.text isKindOfClass:[NSString class]]) {
                ln.commentaire = passwordTextField.text;
            }
            else {
                ln.commentaire = @"";
            }
            
            ln.idcommande = _commande.idcommande;
            ln.idproduit  = [NSString stringWithFormat: @"%@",cell.fav.tId];            
            ln.qte         = [NSString stringWithFormat:@"%@ %@",cell.qte.text,[typrodhc objectAtIndex:selectedIndex]];
            ln.prix        = [NSString stringWithFormat:@"%@",cell.prix.text];
            ln.idcommande  = _commande.idcommande;
            //ln.ref = _popupprodc.text;
            //ln.nom = _popupprod.text;
            
            ///???????????????????????????????????
            
            [_lstLigneCommande addObject:ln];
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
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
    if([searchText isEqualToString:@""]){
        readlst = initial;
        [self.collectionView reloadData];
    }
    else{
        NSString *uppercase = [searchBar.text uppercaseString];
        
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"(tGencode CONTAINS[cd] %@) or (tDesc CONTAINS[cd] %@)", uppercase,uppercase,uppercase];
        
        readlst = [allFav filteredArrayUsingPredicate:predicate];
        
        [searchBar setShowsCancelButton:NO animated:YES];
        //[searchBar resignFirstResponder];
        self.collectionView.allowsSelection = YES;
        self.collectionView.scrollEnabled = YES;
        [self.collectionView reloadData];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.collectionView.allowsSelection = YES;
    self.collectionView.scrollEnabled = YES;
    //[self getData];
    readlst = initial;
    [self.collectionView reloadData];
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

- (int)isInCommande:(NSString *) idProd {
    for( int i=0 ; i<_lstLigneCommande.count ; i++){
        if(_lstLigneCommande[i]['_idproduit'] == idProd){
            return i;
        }
    }
    
    return -1;
}

@end
