//
//  AddFoodViewController.m
//  MealReel
//
//  Created by Whitney on 5/6/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "AddFoodViewController.h"
#import "PairingModel.h"

@interface AddFoodViewController ()
@property (weak, nonatomic) IBOutlet UITextField *categoryText;
@property (weak, nonatomic) IBOutlet UITextField *dishText;
@property (weak, nonatomic) IBOutlet UILabel *categoryError;
@property (weak, nonatomic) IBOutlet UILabel *dishError;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) PairingModel *model;

@end

@implementation AddFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [PairingModel sharedModel];
    
    //make error labels invisible
    self.categoryError.hidden = YES;
    self.dishError.hidden = YES;
}

- (IBAction)CategoryInput:(id)sender {
}
- (IBAction)DishInput:(id)sender {
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [self checkInputs];
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.categoryText resignFirstResponder];
    [self.dishText resignFirstResponder];
}

-(BOOL)checkInputs{
    BOOL good = YES;
    if ([self.categoryText.text isEqual:@""]) {
        //make error label visible
        self.categoryError.hidden = NO;
        good = NO;
    }
    else{
        self.categoryError.hidden = YES;
    }
    if ([self.dishText.text isEqual:@""]) {
        //make error label visible
        self.dishError.hidden = NO;
        good = NO;
    }
    else {
        self.dishError.hidden = YES;
    }
    return good;
}

- (IBAction)addFood:(UIButton *)sender {
    BOOL good = [self checkInputs];
    if(good == YES){
        //add entry
        [self.model insertNewFood:[self.dishText.text lowercaseString]  :[self.categoryText.text lowercaseString]];
        NSLog(@"Adding %@ -- %@", self.categoryText.text, self.dishText.text);
        //leave
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
