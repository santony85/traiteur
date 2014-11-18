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

@interface detailCommandeView : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


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
@property (weak, nonatomic) IBOutlet UITextField *deshc;
@property (weak, nonatomic) IBOutlet UITextField *commhc;
@property (weak, nonatomic) IBOutlet UITextField *qtehc;
@property (weak, nonatomic) IBOutlet UITextField *prixhc;

@property (weak, nonatomic) IBOutlet APRoundedButton *btNext;





- (IBAction)livrerCommande:(id)sender;
- (IBAction)affPrint:(id)sender;
- (IBAction)modQte:(id)sender;
- (IBAction)modCom:(id)sender;
- (IBAction)modRem:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hdRemise;
@property (weak, nonatomic) IBOutlet UILabel *hdSommeRemise;
@end
