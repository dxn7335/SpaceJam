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
@property (nonatomic, readonly) SEL actionTouchUpInside;
@property (nonatomic, readonly) SEL actionTouchDown;
@property (nonatomic, readonly) SEL actionTouchUp;
@property (nonatomic, readonly, weak) id targetTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchDown;
@property (nonatomic, readonly, weak) id targetTouchUp;

-(id)initWithProperties: (int) x : (int) y : (double)width : (double)height;
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

/** Sets the target-action pair, that is called when the Button is tapped.
 "target" won't be retained.
 */
- (void)setTouchUpInsideTarget:(id)target action:(SEL)action;
- (void)setTouchDownTarget:(id)target action:(SEL)action;
- (void)setTouchUpTarget:(id)target action:(SEL)action;
@end
