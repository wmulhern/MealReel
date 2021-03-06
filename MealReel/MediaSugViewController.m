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
@property (strong, nonatomic) IBOutlet UILabel *sorryLabel;
@property (strong, nonatomic) UIPanGestureRecognizer *gesture;

@property (strong, nonatomic) PairingModel *model;

@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSMutableArray *movieLabels;


@end

@implementation MediaSugViewController

//for moving suggestions
BOOL dragging;
float oldX, oldY;

//number of movies initially suggested
NSInteger numMovies;
NSInteger refreshes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [PairingModel sharedModel];
    
    // Underlying label for when we run out of suggestions
    _sorryLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-150, 200, 300)];
    _sorryLabel.text = @"Sorry, we have no more suggestions for you";
    _sorryLabel.textAlignment = NSTextAlignmentCenter;
    _sorryLabel.textColor = [UIColor redColor];
    _sorryLabel.font = [UIFont fontWithName:@"System - System" size:40];
    _sorryLabel.numberOfLines= 0;
    [self.view addSubview:_sorryLabel];
    _sorryLabel.hidden = YES;
    
    
    // populate suggestion array
    self.movies = [self.model getTop5MatchesForFood:[_chosenFood lowercaseString]];
    numMovies = [self.movies count];
    if (numMovies < 2) {
        [self add5Movies:self.movies];
        numMovies = [self.movies count];
    }
    //self.movies =@[@"The Lion King", @"Up", @"Big Hero 6", @"Cinderella", @"How To Train Your Dragon", @"Rio", @"A Bug's Life"];
    
    refreshes = 0;

    // create suggestion stack
    self.movieLabels = [[NSMutableArray alloc ] initWithCapacity:numMovies];
    
    [self createLabelStack];
    [self checkLabels];
    
    // button appearance
    [self.yesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.yesButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.noButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.noButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
}


/* -- SETTING UP MOVIE LABEL STACK -- */

-(void)createLabelStack{
    NSInteger i = 0;
    
    for (i = 0; i<numMovies; i++){
        UILabel *movieLabel = [self createMovieLabel:[_movies objectAtIndex:i]];
        NSLog(@"created %@ label", [_movies objectAtIndex:i] );
        [self.movieLabels addObject:movieLabel];
    }
    for (i = numMovies-1;i >=0; i--) {
        [self.view addSubview:[self.movieLabels objectAtIndex:i]];
    }
}


- (UILabel *)createMovieLabel :(NSString*)name {
    NSString *poster_url_str = [self.model getPosterUrlForMedia:name];
    NSURL *poster_url = [NSURL URLWithString:poster_url_str];
    NSData *poster_data = [NSData dataWithContentsOfURL:poster_url];
    UIImage *poster_img = [UIImage imageWithData:poster_data];
    
    UILabel *movieLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-150, 200, 300)];
    movieLabel.text = [name capitalizedString];
    movieLabel.backgroundColor = [UIColor lightGrayColor];
    movieLabel.textColor = [UIColor clearColor];
    movieLabel.font = [UIFont fontWithName:@"Apple Color Emoji" size:36];
    movieLabel.numberOfLines= 0;
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:poster_img];
    bg.frame = CGRectMake(0, 0, 200, 300);
    [movieLabel addSubview:bg];
    movieLabel.backgroundColor = [UIColor clearColor];
    
    // enable touch delivery
    movieLabel.userInteractionEnabled = YES;
    
    return movieLabel;
}

- (NSMutableArray *)add5Movies :(NSMutableArray*)array{
    NSInteger num = [array count];
    NSInteger goal = num+5;
    while (num < goal){
        NSString *media = [self.model getRandomMedia];
        if (![array containsObject:media]) {
            [array addObject:media];
            num++;
        }
    }
    return array;
}

/* -- SETTING UP MOVIE LABEL STACK -- */

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
    if (numMovies == 0 && refreshes == 3){
        _sorryLabel.hidden = NO;
        self.yesButton.enabled = NO;
        self.noButton.enabled = NO;
    }
    else if (numMovies == 0){
        [self add5Movies:self.movies];
        numMovies = [self.movies count];
        [self createLabelStack];
        refreshes--;
    }
}

-(void)snapToCenter :(UILabel *)label{
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        // Do nothing
                    }];
    
}

-(void)swipeLeft :(UILabel*)label{
    //decrement strengths in db
    NSString *adj = [self.model getCommonAdj :[_chosenFood lowercaseString] :[label.text lowercaseString]];
    int strength= [self.model getMediaToAdjStrength :[label.text lowercaseString] :adj];
    [self.model updateMediaToAdj :[label.text lowercaseString] :adj :strength+2];
    
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake(-200, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        [label removeFromSuperview];
                        [self.movieLabels removeObject:label];
                        [self.movies removeObject:label.text];
                        numMovies--;
                        [self checkLabels];
                    }];

}

-(void)swipeRight :(UILabel*)label{
    // increment strengths in db
    NSString *adj = [self.model getCommonAdj :[_chosenFood lowercaseString] :[label.text lowercaseString]];
    int strength= [self.model getMediaToAdjStrength :[label.text lowercaseString] :adj];
    [self.model updateMediaToAdj :[label.text lowercaseString] :adj :strength+2];
    
    [UIView transitionWithView:label
                      duration:0.5f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width + 200, [UIScreen mainScreen].bounds.size.height/2);
                    }
                    completion:^(BOOL finished) {
                        [label removeFromSuperview];
                        [self.movieLabels removeObject:label];
                        [self.movies removeObject:label.text];
                        numMovies--;
                        [self checkLabels];
                    }];
    
    [self performSegueWithIdentifier:@"matchSegue" sender:label];
}

/* -- BUTTONS PRESSED -- */

- (IBAction)yesButtonPressed:(UIButton *)sender {
    UILabel *label = [self.movieLabels objectAtIndex:0];
    [self swipeRight:label];
}

- (IBAction)noButtonPressed:(UIButton *)sender {
    UILabel *label = [self.movieLabels objectAtIndex:0];
    [self swipeLeft:label];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* -- BUTTONS PRESSED -- */

@end
