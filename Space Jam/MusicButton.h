//
//  MusicButton.h
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreAudio/CoreAudioTypes.h>
@import AVFoundation;

@interface MusicButton : SKSpriteNode <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property(nonatomic) BOOL hasSound;
@property(nonatomic) BOOL recording;
@property(nonatomic) BOOL tapped;
@property(nonatomic) UIColor *color;
@property(nonatomic) AVAudioRecorder *recorder;
@property(nonatomic) AVAudioPlayer *player;

-(id)initWithProperties: (int) x : (int) y : (double)width : (double)height :(uint8_t)categorymask :(uint8_t)contactmask;
// Audio
-(void)loadSound;
-(void)playSound;
-(void)stopSound;
-(void)prepareRecording;
-(void)startRecording;
-(void)stopRecording;
// Configuring Settings for Button
-(void)setDefault;
-(void)setButton;
-(void)canRemove;
-(void)restoreDefault;

//Add physics
-(void)addPhysics:(uint8_t)categorymask withContact:(uint8_t)contactmask rect:(CGRect)rect;
@end
