//
//  MusicButton.m
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "MusicButton.h"


@implementation MusicButton{
    AVAudioPlayer *_player;
}

-(id)initWithProperties : (double)width : (double)height : (int)x : (int)y{
    self = [super init];
    if (self != nil) {
        self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width, height, x, y)].CGPath;
        self.fillColor = [self randomColor];
    }
    
    _player = [[AVAudioPlayer alloc]init];
    
    return self;
}

// loadSound: loads the audio files
-(void)loadSound{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"mp3"];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:soundPath];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = 1.0;
    if(error) NSLog(@"Error loading sound file! error = %@", error);
}

// playSound: plays the audio files --
-(void)playSound{
    NSLog(@"Lanxi you bitch!");
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"HI");
}
*/
-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}
@end
