//
//  planbViewController.h
//  traiteur
//
//  Created by 2B on 17/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSCommande.h"
#import "NSClient.h"


@interface planbViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backToPlayer:(id)sender;
- (IBAction)affCommande:(id)sender;

@property (strong, nonatomic) NSCommande *commande;
@property (strong, nonatomic) NSClient *client;
@property (strong, nonatomic) NSMutableArray *lstLigneCommande;

@property (weak, nonatomic) IBOutlet UIView *zoomview;

@property (weak, nonatomic) IBOutlet UILabel *popupprod;
@property (weak, nonatomic) IBOutlet UIView *popup;
@property (weak, nonatomic) IBOutlet UILabel *popupqte;
@property (weak, nonatomic) IBOutlet UILabel *qteMinMax;

@property (weak, nonatomic) IBOutlet UISegmentedControl *selType;
@property (weak, nonatomic) IBOutlet UISearchBar *mchbar;


@property (weak, nonatomic) IBOutlet UIImageView *zoomimg;
@end
