//
//  ViewController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "ViewController.h"
#import "PairingModel.h"

@interface ViewController ()
@property (strong, nonatomic) PairingModel *model;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.model = [PairingModel sharedModel];
    NSLog(@"%@", [self.model getFoodsForCategory:@"dessert"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
