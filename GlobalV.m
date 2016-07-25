#import "GlobalV.h"
#import "planbAppDelegate.h"

planbAppDelegate *mappDelegate;

NSString *idMagasin;
NSString *catalogue;

NSString *nomMagasin;
NSString *nomcatalogue;


@implementation GlobalV
-(void)setVar{
mappDelegate = (planbAppDelegate *)[[UIApplication sharedApplication] delegate];



    /*idMagasin    = @"";
    catalogue    = @"";
    nomMagasin   = @"";
    nomcatalogue = @"Appli Non Configurée";*/
    
    	//fromagerie,fruitleg,poissonnerie,boucherie,patisserie,traiteur
    
    idMagasin    = @"577bc98f605f4ff06da127eb";
    catalogue    = @"traiteur";
    nomMagasin   = @"AUXERRE";
    nomcatalogue = @"Appli Traiteur";
    
    
    //catalogue = @"traiteur";
    //idMagasin = @"56130420cdd9e59b3d733219";// atlantis
    //idMagasin = @"56a64d0d8812991f3b33a310";//demo //code 0003
    
    


    
}
@end
