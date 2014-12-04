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

@interface MusicButton : SKSpriteNode <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property(nonatomic) Boolean hasSound;

-(id)initWithProperties: (int) x : (int) y : (double)width : (double)height;
// Audio
-(void)loadSound;
-(void)playSound;
-(void)stopSound;
// Configuring Settings for Button
-(void)setDefault;
-(void)setButton;
@end
