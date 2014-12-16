//
//  AddButton.h
//  Space Jam
//
//  Created by Danny on 12/14/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//class notification constant
static NSString *kAddNotification = @"kAddNotification";

@interface AddButton: SKSpriteNode

@property(nonatomic,copy) NSString *method; //notes how new music button is added
-(id)initAddButton:(int) x : (int) y : (double)width : (double)height;
-(void)resetButton;
@end
