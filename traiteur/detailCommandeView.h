//
//  detailCommandeView.h
//  traiteur
//
//  Created by Antony on 13/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSCommande.h"
#import "NSClient.h"
#import "APRoundedButton.h"

@interface detailCommandeView : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewHC;

@property (strong, nonatomic) IBOutlet UISearchBar *mchbar;

@property (strong, nonatomic) NSCommande *commande;
@property (strong, nonatomic) NSClient *client;
@property (strong, nonatomic) NSMutableArray *lstLigneCommande;
@property (strong, nonatomic) IBOutlet UILabel *hdNom;
@property (strong, nonatomic) IBOutlet UILabel *hdPrenom;
@property (strong, nonatomic) IBOutlet UILabel *hdAdresse;
@property (strong, nonatomic) IBOutlet UILabel *hdEmail;
@property (strong, nonatomic) IBOutlet UILabel *hdCp;
@property (strong, nonatomic) IBOutlet UILabel *hdVille;
@property (strong, nonatomic) IBOutlet UILabel *hdTel;
@property (strong, nonatomic) IBOutlet UILabel *totalTTC;
@property (strong, nonatomic) IBOutlet UILabel *dateL;
@property (strong, nonatomic) IBOutlet UILabel *heureL;
- (IBAction)delProduit:(id)sender;
- (IBAction)saveCommande:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *hsProdView;
- (IBAction)closePopup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btComment;
@property (weak, nonatomic) IBOutlet UITextField *deshc;
@property (weak, nonatomic) IBOutlet UITextField *commhc;
@property (weak, nonatomic) IBOutlet UITextField *qtehc;
@property (weak, nonatomic) IBOutlet UITextField *prixhc;

@property (weak, nonatomic) IBOutlet UILabel *hdacompte;

@property (weak, nonatomic) IBOutlet APRoundedButton *btNext;
- (IBAction)addHc:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *pht;
@property (strong, nonatomic) IBOutlet UILabel *ptva;



- (IBAction)livrerCommande:(id)sender;
- (IBAction)affPrint:(id)sender;
- (IBAction)modQte:(id)sender;
- (IBAction)modCom:(id)sender;
- (IBAction)modRem:(id)sender;
- (IBAction)modComGen:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hdRemise;
@property (weak, nonatomic) IBOutlet UILabel *hdSommeRemise;
- (IBAction)endAppli:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *popup;

@property (weak, nonatomic) IBOutlet UILabel *popupqte;
@property (weak, nonatomic) IBOutlet UILabel *popupprod;
@property (weak, nonatomic) IBOutlet UILabel *popupprodc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeProdQte;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrnt;
@property (weak, nonatomic) IBOutlet UIImageView *imgSup;
@property (weak, nonatomic) IBOutlet UIImageView *imgLiv;
@property (weak, nonatomic) IBOutlet UIButton *btImp;
@property (weak, nonatomic) IBOutlet UIButton *btSup;
@property (weak, nonatomic) IBOutlet UIButton *btLiv;


@end
