//
//  PairingModel.h
//  MealReel
//
//  Created by Tamreen M Khan on 5/3/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PairingModel : NSObject

@property (strong, nonatomic) NSString *dbFilename;
@property (nonatomic) sqlite3 *db;

+ (id)sharedModel;

-(NSMutableArray *)getTop5MatchesForFood:(NSString *)food;

-(int)getFoodToAdjStrength:(NSString *)food :(NSString *)adj;
-(void)insertFoodToAdj:(NSString *)food :(NSString *)adj :(int)strength;
-(void)updateFoodToAdj:(NSString *)food :(NSString *)adj :(int)newStrength;

-(void)insertMediaToAdj:(NSString *)media :(NSString *)adj :(int)strength;
-(void)updateMediaToAdj:(NSString *)media :(NSString *)adj :(int)newStrength;
-(int)getMediaToAdjStrength:(NSString *)media :(NSString *)adj;

-(NSMutableArray *)getCategories;
-(NSMutableArray *)getFoodsForCategory:(NSString *)cat;

-(NSMutableArray *)getTop5MediaForAdj:(const unsigned char *)adj;
-(NSMutableArray *)get4RandomAdjs;
-(NSString *)getRandomMedia;
-(NSString *)getRandomFood;

-(NSString *)getCommonAdj:(NSString *)food :(NSString *)media;
-(void) insertNewFood:(NSString *)food :(NSString *)category;

-(NSString *)getPosterUrlForMedia:(NSString *)media;
@end