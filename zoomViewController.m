//
//  zoomViewController.m
//  traiteur
//
//  Created by Antony on 31/03/2016.
//  Copyright © 2016 planb. All rights reserved.
//

#import "zoomViewController.h"

@interface zoomViewController ()

@end

@implementation zoomViewController


-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)onImageViewClickedX:(id)sender{
    //
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    
    
}

- (IBAction)affImg:(NSString *)image {
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSLog(@"%@",image);
    
    _zoomImg.image = [self loadImage:[NSString stringWithFormat:@"%@",image] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(onImageViewClickedX:)];
     
     singleTap.numberOfTapsRequired = 1;
     singleTap.numberOfTouchesRequired = 1;
     [_zoomImg addGestureRecognizer:singleTap];
     [_zoomImg setUserInteractionEnabled:YES];
     //_zoomImg.image = image;
}

@end
