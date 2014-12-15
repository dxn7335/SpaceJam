//
//  EditButton.h
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EditButton : SKSpriteNode
@property(nonatomic)SKShapeNode *circle;

-(id)initWithProperties: (int) x : (int) y : (double)width : (double)height;
@end
