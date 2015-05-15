//
//  MiniAssociateViewController.m
//  MealReel
//
//  Created by Whitney on 5/6/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "PairingModel.h"
#import "MiniAssociateViewController.h"

@interface MiniAssociateViewController ()


@property (weak, nonatomic) IBOutlet UIButton *miniAdj1;
@property (weak, nonatomic) IBOutlet UIButton *miniAdj2;
@property (weak, nonatomic) IBOutlet UIButton *miniAdj3;
@property (weak, nonatomic) IBOutlet UIButton *miniNoneAdj;
@property (weak, nonatomic) IBOutlet UILabel *miniChoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *miniChoiceString;

@property (strong, nonatomic) PairingModel *model;

//data
@property (strong, nonatomic) NSArray *miniMovies;
@property (strong, nonatomic) NSArray *miniAdjectives;


@end

@implementation MiniAssociateViewController

int miniRandNum = 0;
int numRounds;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [PairingModel sharedModel];
    
    [self generateMiniDisplay];
    numRounds = 0;
}
-(void)generateMiniDisplay{
    //select either food or movie at random
    srandom((unsigned int)time(NULL));
    miniRandNum = (int)random() % 2;
    
    //create movie image and adj choices
    if (miniRandNum == 0){
        [self generateMiniMovie];
        self.miniChoiceString.text = @"This movie is...";
    }
    else{
        [self generateMiniFood];
        self.miniChoiceString.text = @"This food is...";
    }
    [self generateMiniChoices];
}

- (void)generateMiniMovie{
    // Remove the previously added background poster subview if there is one
    UIImageView *view = (UIImageView *)[self.miniChoiceLabel viewWithTag:42];
    if(view){
        [view removeFromSuperview];
    }
    
    NSString *media = [[self.model getRandomMedia]capitalizedString];
    self.miniChoiceLabel.text = media;
    
    NSString *poster_url_str = [self.model getPosterUrlForMedia:media];
    NSURL *poster_url = [NSURL URLWithString:poster_url_str];
    NSData *poster_data = [NSData dataWithContentsOfURL:poster_url];
    UIImage *poster_img = [UIImage imageWithData:poster_data];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:poster_img];
    bg.frame = CGRectMake(0, 0, 300, 400);
    bg.tag = 42;
    [self.miniChoiceLabel addSubview:bg];
}

- (void)generateMiniFood{
    UIImageView *view = (UIImageView *)[self.miniChoiceLabel viewWithTag:42];
    if(view){
        [view removeFromSuperview];
    }
    //use movie image instead when those are included
    self.miniChoiceLabel.text = [[self.model getRandomFood]capitalizedString];
}

- (void)generateMiniChoices {
    
    NSArray *choices = [self.model get4RandomAdjs];
    
    //display adjectives on buttons
    [self.miniAdj1 setTitle: [[choices objectAtIndex:0]capitalizedString] forState:UIControlStateNormal];
    [self.miniAdj2 setTitle: [[choices objectAtIndex:1] capitalizedString] forState:UIControlStateNormal];
    [self.miniAdj3 setTitle: [[choices objectAtIndex:2]capitalizedString] forState:UIControlStateNormal];
}

- (IBAction)adjMiniChosen:(UIButton*)sender {
    // Database Shenanigans
    // increase strength bw chosen adj and displayed movie
    // do nothing if choice is "None of These"
    if ([sender.currentTitle  isEqual: @"None of These"]){
        //do nothing
    }
    else{
        int strength = 0;
        if (miniRandNum == 0){
            strength= [self.model getMediaToAdjStrength :[self.miniChoiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString]];
            [self.model insertMediaToAdj:[self.miniChoiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString] :strength+2];
        }
        else{
            strength = [self.model getFoodToAdjStrength:[self.miniChoiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString]];
            [self.model insertFoodToAdj:[self.miniChoiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString] :strength+2];
        }
        NSLog(@"strengthen connection bw %@ and %@ to %d", self.miniChoiceLabel.text, [sender currentTitle], strength+2);
    }
    
    
    NSLog(@"You said the movie %@ is %@", self.miniChoiceLabel.text,[sender currentTitle]);
    
    [self checkRounds];
    [self generateMiniDisplay];
    
}

-(void)checkRounds{
    if (numRounds == 25) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        numRounds++;
    }
}




@end

