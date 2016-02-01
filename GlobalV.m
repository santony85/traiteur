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



//idMagasin = @"564dd975f5cedf4653f8cd47";
//catalogue = @"traiteur";

    idMagasin = @"5617bce9cc2fa1664f32bb1d";
    catalogue = @"traiteur";
    
    nomMagasin = @"LECLERC DEMO";
    nomcatalogue = @"Appli Traiteur";

    
}
@end
