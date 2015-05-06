//
//  MediaSugViewController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "MediaSugViewController.h"

@interface MediaSugViewController ()
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (strong, nonatomic) UIPanGestureRecognizer *gesture;

@property (strong, nonatomic) PairingModel *model;

@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableArray *movieLabels;


@end

@implementation MediaSugViewController

//for moving suggestions
BOOL dragging;
float oldX, oldY;

//number of movies initially suggested
NSInteger numMovies;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [PairingModel sharedModel];
    
    // Underlying label for when we run out of suggestions
    UILabel *sorryLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-150, 200, 300)];
    sorryLabel.text = @"Sorry, we have no more suggestions for you";
    sorryLabel.textAlignment = NSTextAlignmentCenter;
    sorryLabel.textColor = [UIColor redColor];
    sorryLabel.font = [UIFont fontWithName:@"System - System" size:40];
    sorryLabel.numberOfLines= 0;
    [self.view addSubview:sorryLabel];
    
    
    // populate suggestion stack
    self.movies = [self.model getTop5MatchesForFood:[_chosenFood lowercaseString]];
    NSLog(@"you are eating %@", _chosenFood);
    
    //self.movies =@[@"The Lion King", @"Up", @"Big Hero 6", @"Cinderella", @"How To Train Your Dragon", @"Rio", @"A Bug's Life"];
    
    numMovies = [self.movies count];
    self.movieLabels = [[NSMutableArray alloc ] initWithCapacity:numMovies];
    
    if (numMovies != 0){
        NSInteger i = 0;
        
        for (i = 0; i<numMovies; i++){
            UILabel *movieLabel = [self createMovieLabel:[_movies objectAtIndex:i]];
            NSLog(@"created %@ label", [_movies objectAtIndex:i] );
            [self.movieLabels addObject:movieLabel];
        }
        for (i = numMovies-1;i >0; i--) {
            [self.view addSubview:[self.movieLabels objectAtIndex:i]];
        }
    }
    [self checkLabels];
    
    // button appearance
    [self.yesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.yesButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.noButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.noButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
}

/*--- FUNCTIONS FOR TOUCHING/MOVING SUGGESTIONS -- */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    dragging = NO;
    UITouch *touch = [[event allTouches] anyObject];
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)touch.view;
        NSLog(@"label x: %f, window x: %f", label.frame.origin.x, [UIScreen mainScreen].bounds.size.width/2);
        if (label.frame.origin.x - [UIScreen mainScreen].bounds.size.width/2 > 50 ) {
            NSLog(@"SWIPING RIGHT");
            [self swipeRight:label];
        }
        else if (label.frame.origin.x - [UIScreen mainScreen].bounds.size.width/2 < -150 ) {
            NSLog(@"SWIPING LEFT");
            [self swipeLeft:label];
        }
        else {
            [self snapToCenter:label];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)touch.view;
        if (dragging) {
            CGRect frame = label.frame;
            frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
            frame.origin.y = label.frame.origin.y + touchLocation.y - oldY;
            label.frame = frame;
        }
    }
}

/*--- END FUNCTIONS FOR TOUCHING/MOVING SUGGESTIONS -- */


-(void)checkLabels{
    if (numMovies == 0){
        self.yesButton.enabled = NO;
        self.noButton.enabled = NO;
    }
}

-(void)snapToCenter :(UILabel *)label{
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        // Do nothing
                    }];
    
}

-(void)swipeLeft :(UILabel*)label{
    NSString *adj = [self.model getCommonAdj :[_chosenFood lowercaseString] :[label.text lowercaseString]];
    int strength= [self.model getMediaToAdjStrength :[label.text lowercaseString] :adj];
    [self.model updateMediaToAdj :[label.text lowercaseString] :adj :strength+2];
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake(-200, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        [label removeFromSuperview];
                        [self.movieLabels removeObject:label];
                        numMovies--;
                        [self checkLabels];
                    }];

}

-(void)swipeRight :(UILabel*)label{
    NSString *adj = [self.model getCommonAdj :[_chosenFood lowercaseString] :[label.text lowercaseString]];
    int strength= [self.model getMediaToAdjStrength :[label.text lowercaseString] :adj];
    [self.model updateMediaToAdj :[label.text lowercaseString] :adj :strength+2];
    [self performSegueWithIdentifier:@"matchSegue" sender:self.yesButton];
}

-(void) moveForward{
    NSLog(@"-----GROWING-----");
    UILabel *label = [self.movieLabels objectAtIndex:0];
    //CGRect frmExpl = label.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
   
    [label setBounds:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100,[UIScreen mainScreen].bounds.size.height/2-60,label.bounds.size.width*2,label.bounds.size.height*2)];
    
    [UIView commitAnimations];
    
}


- (UILabel *)createMovieLabel :(NSString*)name {
    UILabel *movieLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-150, 200, 300)];
    
    movieLabel.text = name;
    movieLabel.textAlignment = NSTextAlignmentCenter;
    movieLabel.backgroundColor = [UIColor lightGrayColor];
    movieLabel.textColor = [UIColor whiteColor];
    movieLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:54];
    movieLabel.numberOfLines= 0;
    
    // enable touch delivery
    movieLabel.userInteractionEnabled = YES;
    
    return movieLabel;
}

//prepares to move to matched screen
// also performs the swipe right animation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UILabel *label = [self.movieLabels objectAtIndex:0];
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width + 200, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        [label removeFromSuperview];
                        [self.movieLabels removeObject:label];
                        numMovies--;
                        [self checkLabels];
                    }];
}

/* -- BUTTONS PRESSED -- */

- (IBAction)noButtonPressed:(UIButton *)sender {
    UILabel *label = [self.movieLabels objectAtIndex:0];
    [self swipeLeft:label];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* -- BUTTONS PRESSED -- */

@end
