//
//  infoclientViewContoller.h
//  traiteur
//
//  Created by Antony on 06/10/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APRoundedButton.h"
#import "DayDatePickerView.h"



@interface infoclientViewContoller : UIViewController<UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate ,DayDatePickerViewDataSource, DayDatePickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nom;
@property (strong, nonatomic) IBOutlet UITextField *prenom;
@property (strong, nonatomic) IBOutlet UITextField *adresse;
@property (strong, nonatomic) IBOutlet UITextField *cp;
@property (strong, nonatomic) IBOutlet UITextField *ville;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UITextField *dateprepa;
@property (strong, nonatomic) IBOutlet UITextField *heureprepa;
@property (strong, nonatomic) IBOutlet UITextField *nbPersonne;

@property (strong, nonatomic) IBOutlet UITextField *remise;

- (IBAction)changeNom:(id)sender;
- (IBAction)tettt:(id)sender;


@property (strong, nonatomic) IBOutlet APRoundedButton *btNext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *formView;
- (IBAction)RechercheCommande:(id)sender;


- (IBAction)affListProd:(id)sender;
- (IBAction)affListCommandesClient:(id)sender;
@property (strong, nonatomic) IBOutlet APRoundedButton *btrecherchecom;

- (IBAction)delAll:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *reccommview;
- (IBAction)affRecComm:(id)sender;
@property (weak, nonatomic) IBOutlet DayDatePickerView *dtPicker;



@property (strong, nonatomic) IBOutlet APRoundedButton *closereccomm;
@property (strong, nonatomic) IBOutlet UITextField *recnumcommande;
@property (strong, nonatomic) IBOutlet APRoundedButton *btreccomm;

- (IBAction)hidereccomm:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dateView;
- (IBAction)ValidDate:(id)sender;

- (IBAction)recherchecommandenum:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@end
