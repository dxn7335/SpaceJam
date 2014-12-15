//
//  Sound.h
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *type;

//designated initializer
-(instancetype)initWithDictionary:(NSDictionary*) dictionary;
@end
