//
//  PairingModel.m
//  MealReel
//
//  Created by Tamreen M Khan on 5/3/15.
//  Copyright (c) 2015 New York University. All rights reserved.
//

#import "PairingModel.h"

@implementation PairingModel

-(instancetype)init{
    self = [super init];
    if(self){
        self.dbFilename = @"/Users/Whitney/MealReel/MealReel/MealReel.db";
    }
    
    sqlite3 *db;
    if(sqlite3_open([self.dbFilename UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }else{
        self.db = db;
    }
    return self;
}

+ (id)sharedModel {
    static PairingModel *model = nil;
    @synchronized(self) {
        if (model == nil)
            model = [[self alloc] init];
    }
    return model;
}

-(NSArray *)getTop5MatchesForFood:(NSString *)food{
    NSMutableArray *matches;
    char *query = "SELECT adj FROM food_to_adj"
        " WHERE food=?"
        " ORDER BY strength DESC LIMIT 1;";
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        if(sqlite3_bind_text(stmt, 1, [food UTF8String], -1, NULL) != SQLITE_OK){
            NSLog(@"err: %s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    if(sqlite3_step(stmt) == SQLITE_ROW){
        matches = [self getTop5MediaForAdj:sqlite3_column_text(stmt, 0)];
    }

    sqlite3_finalize(stmt);
    return matches;
}

-(NSMutableArray *)getTop5MediaForAdj:(const unsigned char *)adj{
    NSMutableArray *matches = [[NSMutableArray alloc] initWithCapacity:5];
    char *query = "SELECT media FROM media_to_adj"
    " WHERE adj=?"
    " ORDER BY strength DESC LIMIT 5;";
    sqlite3_stmt *stmt;
    int i;

    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        if(sqlite3_bind_text(stmt, 1, (char *)adj, -1, NULL) != SQLITE_OK){
            NSLog(@"err: %s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    i=0;
    while(sqlite3_step(stmt) == SQLITE_ROW){
        matches[i] = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        i++;
    }
    return matches;
}

-(int)getFoodToAdjStrength:(NSString *)food :(NSString *)adj{
    char *query = "SELECT strength FROM food_to_adj WHERE"
        " food = ? AND adj = ?;";
    sqlite3_stmt *stmt;
    int strength;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [food UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
    }
    
    sqlite3_step(stmt);
    strength = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);
    return strength;
}

-(void)insertFoodToAdj:(NSString *)food :(NSString *)adj :(int)strength{
    char *query;
    sqlite3_stmt *stmt;
    int res;
    
    query = "SELECT * FROM food_to_adj WHERE"
        " food = ? AND adj = ?";
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [food UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
        if((res=sqlite3_step(stmt)) == SQLITE_ROW){
            // This pairing already exists, so update instead of insert
            sqlite3_finalize(stmt);
            return [self updateFoodToAdj:food :adj :strength];
        }else if(res != SQLITE_DONE){
            NSLog(@"Error: %s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }
    query = "INSERT INTO food_to_adj (food, adj, strength)"
        " values(?,?,?);";
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [food UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 3, strength);
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)updateFoodToAdj:(NSString *)food :(NSString *)adj :(int)newStrength{
    char *query = "UPDATE food_to_adj SET strength=?"
    " WHERE food=? AND adj=?";
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_int(stmt, 1, newStrength);
        sqlite3_bind_text(stmt, 2, [food UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [adj UTF8String], -1, NULL);
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(int)getMediaToAdjStrength:(NSString *)media :(NSString *)adj{
    char *query = "SELECT strength FROM media_to_adj WHERE"
    " media = ? AND adj = ?;";
    sqlite3_stmt *stmt;
    int strength;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [media UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
    }
    
    sqlite3_step(stmt);
    strength = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);
    return strength;
}

-(void)insertMediaToAdj:(NSString *)media :(NSString *)adj :(int)strength{
    char *query;
    sqlite3_stmt *stmt;
    int res;
    
    query = "SELECT * FROM media_to_adj WHERE"
        " media = ? AND adj = ?";
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [media UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
        if((res=sqlite3_step(stmt)) == SQLITE_ROW){
            // This pairing already exists, so update instead of insert
            sqlite3_finalize(stmt);
            return [self updateMediaToAdj:media :adj :strength];
        }else if(res != SQLITE_DONE){
            NSLog(@"Error: %s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }

    query = "INSERT INTO media_to_adj (media, adj, strength)"
        " values(?,?,?);";
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [media UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [adj UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 3, strength);
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(void)updateMediaToAdj:(NSString *)media :(NSString *)adj :(int)newStrength{
    char *query = "UPDATE media_to_adj SET strength=?"
    " WHERE media=? AND adj=?";
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_int(stmt, 1, newStrength);
        sqlite3_bind_text(stmt, 2, [media UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [adj UTF8String], -1, NULL);
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

-(NSMutableArray *)getCategories{
    NSMutableArray *cats = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    char *query = "SELECT DISTINCT category FROM categories";
    char *cat;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            cat = (char *)sqlite3_column_text(stmt, 0);
            [cats addObject:[[NSString alloc] initWithUTF8String:cat]];
        }
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }
    
    return cats;
}

-(NSMutableArray *)getFoodsForCategory:(NSString *)cat{
    NSMutableArray *foods = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    char *query = "SELECT food FROM categories WHERE category=?;";
    char *food;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [cat UTF8String], -1,  NULL);
        while(sqlite3_step(stmt) == SQLITE_ROW){
            food = (char *)sqlite3_column_text(stmt, 0);
            [foods addObject:[[NSString alloc] initWithUTF8String:food]];
        }
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }
    
    sqlite3_finalize(stmt);
    return foods;
}

-(NSMutableArray *)get4RandomAdjs{
    NSMutableArray *adjs = [[NSMutableArray alloc] initWithCapacity :4];
    char *query = "SELECT adj from adjs ORDER BY RANDOM() LIMIT 4";
    sqlite3_stmt *stmt;
    int i;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        i=0;
        while(sqlite3_step(stmt) == SQLITE_ROW){
            adjs[i] = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            i++;
        }
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    return adjs;
}

-(NSString *)getRandomMedia{
    char *query = "SELECT name from media ORDER BY RANDOM() LIMIT 1";
    sqlite3_stmt *stmt;
    char *name_cstr;
    NSString *name;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            name_cstr = (char *)sqlite3_column_text(stmt, 0);
            name = [[NSString alloc] initWithUTF8String:name_cstr];
        }else{
            NSLog(@"Error:%s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    return name;
}

-(NSString *)getRandomFood{
    char *query = "SELECT food from categories ORDER BY RANDOM() LIMIT 1";
    sqlite3_stmt *stmt;
    char *name_cstr;
    NSString *name;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            name_cstr = (char *)sqlite3_column_text(stmt, 0);
            name = [[NSString alloc] initWithUTF8String:name_cstr];
        }else{
            NSLog(@"Error:%s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error:%s", sqlite3_errmsg(self.db));
    }
    
    return name;
}

-(NSString *)getCommonAdj:(NSString *)food :(NSString *)media{
    char *query = "SELECT food_to_adj.adj FROM food_to_adj"
    " INNER JOIN media_to_adj ON food_to_adj.adj = media_to_adj.adj"
    " WHERE food_to_adj.food = ? AND media_to_adj.media = ?;"
    " ORDER BY media_to_adj.strength DESC LIMIT 1;";
    sqlite3_stmt *stmt;
    char *adj_cstr;
    NSString *adj;
    
    if(sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [food UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [media UTF8String], -1, NULL);
        if(sqlite3_step(stmt) == SQLITE_ROW){
            adj_cstr = (char *)sqlite3_column_text(stmt, 0);
            adj = [[NSString alloc] initWithUTF8String:adj_cstr];
        }else{
            NSLog(@"Error: %s", sqlite3_errmsg(self.db));
        }
    }else{
        NSLog(@"Error: %s", sqlite3_errmsg(self.db));
    }
    
    return adj;
}

@end