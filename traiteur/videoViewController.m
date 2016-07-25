//
//  videoViewController.m
//  traiteur
//
//  Created by Antony on 14/12/2015.
//  Copyright © 2015 planb. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "accueilViewController.h"

@interface videoViewController (){
    UIButton *btn;
}

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;

@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view from its nib.
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"noel-atlantis" ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:self.view.frame];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    //[btn setBackgroundColor:[UIColor orangeColor]];
    //adding action programatically
    [btn addTarget:self action:@selector(multipleTap:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    
    
    //UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTrice:)];
    //tapTrice.numberOfTapsRequired = 3;
    //[btn addGestureRecognizer:tapTrice];
    
    [self.view addSubview:btn];
   // [self.movieView addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];


}

-(IBAction)multipleTap:(id)sender withEvent:(UIEvent*)event {
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 4) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:1 forKey:@"fromvideo"];
        NSLog(@"%@",sender);
        
        
        accueilViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"accueilViewController"];
        [self presentModalViewController:dvc animated:YES];
        [dvc affPad:nil];
    }
}

- (IBAction)btnClicked:(id)sender
{
    NSLog(@"%@",sender);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.avplayer play];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
