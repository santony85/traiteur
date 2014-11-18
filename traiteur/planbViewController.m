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
#import "MLAlertView.h"
#import "detailCommandeView.h"
#import "apiconnect.h"

@interface planbViewController ()<MLAlertViewDelegate>{
    NSMutableDictionary *produits;
    NSArray *produitsSectionTitles;
    NSMutableArray *readlst;
    
    int selectedId;
    int selectedRow;
    int selectedHd;
    dataBase *sqlManager;
    int numberOfCells;
    int thetag;
    UITextField *passwordTextField;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    readlst  = [[NSMutableArray  alloc] init];
    produits = [[NSMutableDictionary  alloc] init];
    

    
    sqlManager = [[dataBase alloc] initDatabase:0];
    /*
    //mise a jour
    apiconnect *connect     = [[apiconnect alloc] init];
    [sqlManager delDataCat];
    [sqlManager resetId];
    NSString *getFirst;
    NSMutableArray *catlst  = [connect getList :@"produit" :101];
    for (int i = 0; i < [catlst count]; i++){
      NSArray *cl =[catlst objectAtIndex: i];
      NSLog(@"%@",cl);
      NSFavoris *fav = [[NSFavoris alloc] init];
      fav.tFam  = [[catlst objectAtIndex:i] objectForKey:@"Famille"];
      fav.tTyp  = [[catlst objectAtIndex:i] objectForKey:@"Type"];
      fav.tDesc = [[catlst objectAtIndex:i] objectForKey:@"Desc"];
      fav.tPrix = [[catlst objectAtIndex:i] objectForKey:@"Prix"];
      [sqlManager addToDatabase:fav];
      if(i==0)getFirst=[[catlst objectAtIndex:i] objectForKey:@"Type"];
      
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //Get Image From URL
        UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://planb-apps.com/traiteur/%d.jpg",i]];
        //Save Image to Directory
        [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%d",i] ofType:@"png" inDirectory:documentsDirectoryPath];
      }
    ///*mise a jour
    */
    NSMutableArray *hd = [sqlManager findHeader];
    for (int i = 0; i < [hd count]; i++){
        NSArray *dataZZ = [sqlManager findLine:[hd objectAtIndex: i]];
        [produits setObject:dataZZ forKey:[hd objectAtIndex: i]];
    }
    
    //produitsSectionTitles = [[produits allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    produitsSectionTitles = hd;//[[produits allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    readlst = [sqlManager findFavoris:@"LES PAINS SURPRISES"];
    
    selectedId=0;
    selectedRow=0;
    selectedHd=0;
    
    /*UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editBarButtonItem, saveBarButtonItem, nil];*/
    
   /* UIBarButtonItem *addAttachButton = [[UIBarButtonItem alloc] initWithTitle:(@"  Valider  ") style:UIBarButtonItemStyleBordered target:self action:@selector(affCommande:)];
    
    UIBarButtonItem *spacedButton = [[UIBarButtonItem alloc] initWithTitle:(@"     ") style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:(@"  Nouveau  ") style:UIBarButtonItemStyleBordered target:self action:@selector(sendClicked:)];
    self.navigationItem.rightBarButtonItems = @[addAttachButton,spacedButton,sendButton];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [self hidePopUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [produitsSectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:section];
    NSArray *sectionAnimals = [produits objectForKey:sectionTitle];
    return [sectionAnimals count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [produitsSectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#1273B7" alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 32)];
    NSString *sectionTitle = [produitsSectionTitles objectAtIndex:section];
    label.text = sectionTitle;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
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
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)indexPath
{

    return 32.0;
}

//**********************************//
//**********************************//
//**********************************//
//**********************************//
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    
    //return 11;
    numberOfCells=[readlst count];
    return [readlst count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    produitcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"produitcell" forIndexPath:indexPath];
    NSFavoris * fav = [readlst objectAtIndex:indexPath.row];
    cell.desc.text = fav.tDesc;
    cell.prix.text = [NSString stringWithFormat: @"%.2f €",[fav.tPrix floatValue]];
    cell.qte.text=@"";
    cell.qte.tag=indexPath.row;
    
    
    cell.tag = [fav.idFav intValue];
    
    NSLog(@"%@",fav.idFav);
    cell.imgProd.image = [self loadImage:[NSString stringWithFormat:@"%@",fav.idFav] ofType:@"png" inDirectory:documentsDirectoryPath];
    //cell.addBt.enabled = NO;
    // Configure the cell...
    

    
    return cell;
}


-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1; // The number of sections we want
}

-(void)affPopUp{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];

    [_popup setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)hidePopUp{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [_popup setAlpha:0.0];
    [UIView commitAnimations];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

   // produitcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"produitcell" forIndexPath:indexPath];
    produitcell *cell = (produitcell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    _popupprod.text = cell.desc.text;
    
    if([cell.qte.text isEqualToString:@""])_popupqte.text = @"0";
    else _popupqte.text = cell.qte.text;
    NSLog(@"%d",cell.tag);
    
    
    
     cell.qte.enabled = YES;
    [cell.qte becomeFirstResponder];
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
    
    
    [self hidePopUp];
    
    if ([textField.text isEqualToString:@""]) {
        NSLog(@"vide");
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Commentaire"
                                                        message:[NSString stringWithFormat: @"%@ x %@\r\nAjouter un commentaire",cell.qte.text,cell.desc.text]
                                                        delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    passwordTextField = [alertView textFieldAtIndex:0];
    [alertView show];
    
    
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ajouter a la commande\r\n" message:
                          [NSString stringWithFormat: @"%@ x %@",cell.qte.text,cell.desc.text]
                                                   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Valider", nil];
    [alert show];*/

    thetag = textField.tag;
    [textField resignFirstResponder];
    return YES;
}



- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%li",(long)buttonIndex);
    [alertView dismiss];
    
NSLog(@"%@",passwordTextField.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:thetag inSection:0] ;
    produitcell *cell = (produitcell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if((long)buttonIndex==0){
      cell.qte.text=@"";
      }
    else{
        //addToCommand
        NSLigneCommande *lcom = [[NSLigneCommande alloc] init];
        
        if ([passwordTextField.text isKindOfClass:[NSString class]]) {
            lcom.commentaire = passwordTextField.text;
        } else {
            lcom.commentaire = @"";
        }
        

        lcom.idcommande = _commande.idcommande;
        lcom.idproduit  = [NSString stringWithFormat: @"%ld",cell.tag];
        lcom.qte        = cell.qte.text;
        [_lstLigneCommande addObject:lcom];
        //int idn = [sqlManager addLigneCommande:lcom];
        
    }
}


@end
