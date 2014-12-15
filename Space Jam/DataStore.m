//
//  DataStore.m
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

//Private Singleton(can only be 1 instance) DataStore
+(id)sharedStore{
    static DataStore *sharedStore = nil;
    //does a sharedStore already exist? If not, create one
    if(!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [DataStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

-(instancetype)initPrivate{
    self = [super init];
    if(self){
        self.allItems = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
