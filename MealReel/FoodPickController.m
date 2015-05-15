//
//  FoodPickController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "FoodPickController.h"
#import "MediaSugViewController.h"

@interface FoodPickController ()
@property (weak, nonatomic) IBOutlet UIPickerView *FoodPicker;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *dishes;

@property (strong, nonatomic) PairingModel *model;

@end

@implementation FoodPickController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [PairingModel sharedModel];
    
    self.FoodPicker.dataSource = self;
    self.FoodPicker.delegate = self;
    
    
    
    //self.cuisines =@[@"Indian", @"Italian", @"Japanese", @"American", @"Breakfast", @"Mexican"];
    //self.dishes =@[@"Chicken Fingers", @"Mac N' Cheese", @"Hot Dog", @"Apple Pie", @"PB&J", @"Steak", @"Burger"];
    
    //do things
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"selectFoodSegue"]) {
        MediaSugViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.chosenFood = [self.dishes objectAtIndex:[self.FoodPicker selectedRowInComponent:1]];
    }
    
}


- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.categories = [self.model getCategories];
    NSString *selectedCategory = [self.categories objectAtIndex:0];
    self.dishes = [self.model getFoodsForCategory: selectedCategory];
    
    [self.FoodPicker reloadComponent:0];
    [self.FoodPicker reloadComponent:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//////////////  PICKER SET UP  ///////////////////


#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.categories count];
    } else {
        return [self.dishes count];
    }
}


#pragma mark Picker Delegate Methods


- (UIView *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
          forComponent: (NSInteger) component
{
    if (component == 0){
        return [[self.categories objectAtIndex:row]capitalizedString];
    }
    else{
        return [[self.dishes objectAtIndex:row]capitalizedString];

    }
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *selectedCategory = self.categories[row];
        self.dishes = [self.model getFoodsForCategory: selectedCategory];
        [self.FoodPicker reloadComponent:1];
        [self.FoodPicker selectRow:0
                       inComponent:1
                          animated:YES];
         }
}


@end
