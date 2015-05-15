//
//  MatchViewController.m
//  MealReel
//
//  Created by Whitney on 5/3/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "MatchViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moreChoicesButton;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"popcorn_sound" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
