//
//  FoodPickController.m
//  MealReel
//
//  Created by Whitney on 4/21/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "FoodPickController.h"

@interface FoodPickController ()
@property (weak, nonatomic) IBOutlet UIPickerView *FoodPicker;

@property (strong, nonatomic) NSArray *cuisines;
@property (strong, nonatomic) NSArray *dishes;

@end

@implementation FoodPickController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.FoodPicker.dataSource = self;
    self.FoodPicker.delegate = self;
    
    self.cuisines =@[@"Indian", @"Italian", @"Japanese", @"American", @"Breakfast", @"Mexican"];
    self.dishes =@[@"Chicken Fingers", @"Mac N' Cheese", @"Hot Dog", @"Apple Pie", @"PB&J", @"Steak", @"Burger"];
    
    //do things
    
    
    
    
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
        return [self.cuisines count];
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
        return [self.cuisines objectAtIndex:row];
    }
    else{
        return [self.dishes objectAtIndex:row];

    }
    
}




@end
