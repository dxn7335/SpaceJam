//
//  Sound.m
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "Sound.h"

@implementation Sound

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if(self){
        self.name = dict[@"name"] ?  dict[@"name"] : @"";
        self.type = dict[@"type"] ?  dict[@"type"] : @"";
    }
    
    return self;
}
@end
