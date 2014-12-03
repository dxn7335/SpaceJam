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

@interface MusicButton : SKShapeNode

-(id)initWithProperties: (double)width : (double)height : (int) x : (int) y;
-(void)loadSound;
-(void)playSound;
@end
