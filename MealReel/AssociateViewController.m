//
//  AssociateViewController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "AssociateViewController.h"

@interface AssociateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (weak, nonatomic) IBOutlet UIButton *adj1;
@property (weak, nonatomic) IBOutlet UIButton *adj2;
@property (weak, nonatomic) IBOutlet UIButton *adj3;
@property (weak, nonatomic) IBOutlet UIButton *noneAdj;
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *choiceString;

@property (strong, nonatomic) PairingModel *model;

//data
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *adjectives;
@end

@implementation AssociateViewController

int randNum = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [PairingModel sharedModel];



    [self generateDisplay];
}
-(void)generateDisplay{
    //select either food or movie at random
    srandom((unsigned int)time(NULL));
    randNum = (int)random() % 2;
    
    //create movie image and adj choices
    if (randNum == 0){
        [self generateMovie];
        self.choiceString.text = @"This movie is...";
    }
    else{
        [self generateFood];
        self.choiceString.text = @"This food is...";
    }
    [self generateChoices];
}

- (void)generateMovie{
    // Remove the previously added background poster subview if there is one
    UIImageView *view = (UIImageView *)[self.choiceLabel viewWithTag:42];
    if(view){
        [view removeFromSuperview];
    }
    // movie images used
    NSString *media = [[self.model getRandomMedia]capitalizedString];
    self.choiceLabel.text = media;
    
    NSString *poster_url_str = [self.model getPosterUrlForMedia:media];
    NSURL *poster_url = [NSURL URLWithString:poster_url_str];
    NSData *poster_data = [NSData dataWithContentsOfURL:poster_url];
    UIImage *poster_img = [UIImage imageWithData:poster_data];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:poster_img];
    bg.frame = CGRectMake(0, 0, 300, 400);
    bg.tag = 42;
    [self.choiceLabel addSubview:bg];
}

- (void)generateFood{
    UIImageView *view = (UIImageView *)[self.choiceLabel viewWithTag:42];
    if(view){
        [view removeFromSuperview];
    }
    //use movie image instead when those are included
    self.choiceLabel.text = [[self.model getRandomFood]capitalizedString];
}

- (void)generateChoices {
    
    NSArray *choices = [self.model get4RandomAdjs];
    [self.model getPosterUrlForMedia:@"Rush Hour"];
    //display adjectives on buttons
    [self.adj1 setTitle: [[choices objectAtIndex:0]capitalizedString] forState:UIControlStateNormal];
    [self.adj2 setTitle: [[choices objectAtIndex:1] capitalizedString] forState:UIControlStateNormal];
    [self.adj3 setTitle: [[choices objectAtIndex:2]capitalizedString] forState:UIControlStateNormal];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)adjChosen:(UIButton*)sender {
    // Database Shenanigans
    // increase strength bw chosen adj and displayed movie
    // do nothing if choice is "None of These"
    if ([sender.currentTitle  isEqual: @"None of These"]){
        //do nothing
    }
    else{
        int strength = 0;
        if (randNum == 0){
             strength= [self.model getMediaToAdjStrength :[self.choiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString]];
            [self.model insertMediaToAdj:[self.choiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString] :strength+2];
        }
        else{
            strength = [self.model getFoodToAdjStrength:[self.choiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString]];
            [self.model insertFoodToAdj:[self.choiceLabel.text lowercaseString] :[[sender currentTitle] lowercaseString] :strength+2];
        }
        NSLog(@"strengthen connection bw %@ and %@ to %d", self.choiceLabel.text, [sender currentTitle], strength+2);
    }
    
    
    NSLog(@"You said the movie %@ is %@", self.choiceLabel.text,[sender currentTitle]);
    
    [self generateDisplay];
}



@end
