//
//  ViewController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //PairingModel *model =[(AppDelegate *)[UIApplication sharedApplication].delegate model];
    PairingModel *model = [PairingModel sharedModel];
    NSArray *matches = [model getTop5MatchesForFood:@"ice cream"];
    //[self.model insertFoodToAdj:@"steak" :@"happy" :5];
    [model insertMediaToAdj:@"2001 a space odyssey" :@"weird" :42];
    [model insertFoodToAdj:@"cake" :@"good" :36];
    
    //NSLog(@"result 1 %@", matches);
    //NSLog(@"%@", [self.model get4RandomAdjs]);
    //int s = [self.model getMediaToAdjStrength:@"up" :@"happy"];
    //NSLog(@"%d", s);
    NSLog(@"%@", [model getCategories]);
    NSLog(@"%@", [model getFoodsForCategory:@"dessert"]);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
