//
//  DataStore.h
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

@property(nonatomic) NSMutableArray *allItems; //used to store all info

+(instancetype)sharedStore; //the single instance of DataStore used by app to retrieve info from allItems
@end
