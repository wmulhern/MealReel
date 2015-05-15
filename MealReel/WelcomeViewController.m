//
//  WelcomeViewController.m
//  MealReel
//
//  Created by Whitney on 5/6/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "WelcomeViewController.h"
//#import "MiniAssociateViewController.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *skip;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *skipMessage;
@property (strong, nonatomic) IBOutlet UILabel *explainMessage;
@property (strong, nonatomic) IBOutlet UILabel *thankYou;
@property (weak, nonatomic) IBOutlet UIButton *done;

@end

@implementation WelcomeViewController

NSInteger page = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _skip.alpha = 0.0;
    _next.alpha = 0.0;
    _done.alpha = 0.0;
    [self welcome];
}

- (IBAction)nextClicked:(UIButton *)sender {
    if (page == 0){
        [self fadeWelcome];
        [self explain];
        page++;
    }
    else if (page == 1){
        [self fadeExplain];
        [self setUpComeBack];
        [self performSegueWithIdentifier:@"miniAssociateSegue" sender:nil];
    }
}

-(void)welcome{
    // create welcome
    _welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-250, 200, 100)];
    
    _welcomeLabel.text = @"Welcome to MealReal!";
    _welcomeLabel.textAlignment = NSTextAlignmentCenter;
    _welcomeLabel.textColor = [UIColor blackColor];
    _welcomeLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:36];
    _welcomeLabel.alpha = 0.0;
    _welcomeLabel.numberOfLines= 0;
    [self.view addSubview:_welcomeLabel];
    //end create welcome
    
    //end welcome fade in
    [UIView transitionWithView:_welcomeLabel
                      duration:2.0f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        _welcomeLabel.alpha = 1.0;
                    }
                    completion:^(BOOL finished) {
                        //do nothing
                    }];
    //end welcome fade in
    
    //create skip message
    _skipMessage = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150, [UIScreen mainScreen].bounds.size.height/2-100, 300, 200)];
    _skipMessage.text = @"Click next to continue this introduction. You can tap the skip button in the top left at anytime to skip this introduction. However, you may want to stick around for this, it will be fun, we promise.";
    _skipMessage.textAlignment = NSTextAlignmentCenter;
    _skipMessage.textColor = [UIColor blackColor];
    _skipMessage.font = [UIFont fontWithName:@"System - System" size:20];
    _skipMessage.alpha = 0.0;
    _skipMessage.numberOfLines= 0;
    [self.view addSubview:_skipMessage];
    
    //skip message fade in
    [UIView beginAnimations:@"SkipMessage" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:2.0f];
    _skipMessage.alpha = 1.0;
    
    [UIView commitAnimations];
    //end skip message fade in
    
    //skip button fade in
    [UIView beginAnimations:@"SkipButton" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:2.5f];
    
    // Make the animatable changes.
    _skip.alpha = 1.0;
    _next.alpha = 1.0;
    
    [UIView commitAnimations];
    //end skip button fade in
}

-(void)fadeWelcome{
    
    // welcome and skip message fade out
    [UIView beginAnimations:@"fadeWelcome" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:4.0f];
    
    _skipMessage.alpha = 0.0;
    _welcomeLabel.alpha = 0.0;
    
    [UIView commitAnimations];
    [_skipMessage removeFromSuperview];
    [_welcomeLabel removeFromSuperview];

}

-(void)explain{
    // create welcome
    _explainMessage = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150, [UIScreen mainScreen].bounds.size.height/2-350, 300, 400)];
    
    _explainMessage.text = @"Thank you for making us a part of your millennial experience. Let's get started by telling us a little bit about how you feel about some movies, TV shows, and foods";
    _explainMessage.textAlignment = NSTextAlignmentCenter;
    _explainMessage.textColor = [UIColor blackColor];
    _explainMessage.font = [UIFont fontWithName:@"System - System" size:55];
    _explainMessage.alpha = 0.0;
    _explainMessage.numberOfLines= 0;
    [self.view addSubview:_explainMessage];
    //end create welcome
    
    //end welcome fade in
    [UIView transitionWithView:_explainMessage
                      duration:2.0f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        _explainMessage.alpha = 1.0;
                    }
                    completion:^(BOOL finished) {
                        //do nothing
                    }];
    //end welcome fade in
}

-(void)fadeExplain{
    
    // welcome and skip message fade out
    [UIView beginAnimations:@"fadeExplain" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:4.0f];
    
    _explainMessage.alpha = 0.0;
    
    [UIView commitAnimations];
    [_explainMessage removeFromSuperview];
    
}

-(void)setUpComeBack{
    // create thank you
    _thankYou = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-250, 200, 100)];
    
    _thankYou.text = @"Well Done!";
    _thankYou.textAlignment = NSTextAlignmentCenter;
    _thankYou.textColor = [UIColor blackColor];
    _thankYou.font = [UIFont fontWithName:@"Apple Color Emoji" size:36];
    _thankYou.alpha = 1.0;
    _thankYou.numberOfLines= 0;
    [self.view addSubview:_thankYou];
    //end create welcome

    //create skip message
    _skipMessage = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150, [UIScreen mainScreen].bounds.size.height/2-100, 300, 200)];
    _skipMessage.text = @"Thanks for helping us set up. Click the Done button to continue onto the app. Enjoy!";
    _skipMessage.textAlignment = NSTextAlignmentCenter;
    _skipMessage.textColor = [UIColor blackColor];
    _skipMessage.font = [UIFont fontWithName:@"System - System" size:20];
    _skipMessage.alpha = 1.0;
    _skipMessage.numberOfLines= 0;
    [self.view addSubview:_skipMessage];
    
    
    // Make the animatable changes.
    [_next removeFromSuperview];
    [_skip removeFromSuperview];
    _done.alpha = 1.0;
    }


@end
