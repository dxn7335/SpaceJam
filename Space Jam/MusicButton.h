//
//  MusicButton.h
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface MusicButton : SKSpriteNode

@property(nonatomic) Boolean hasSound;

-(id)initWithProperties: (int) x : (int) y : (double)width : (double)height;
-(void)loadSound;
-(void)playSound;
-(void)setDefault;
@end
