//
//  RemoveButton.h
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "EditButton.h"

//class notification constant
static NSString *kRemoveNotification = @"kRemoveNotification";

@interface RemoveButton : SKSpriteNode

-(id)initRemoveButton:(int) x : (int) y : (double)width : (double)height;

@end
