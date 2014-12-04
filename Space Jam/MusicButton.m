//
//  MusicButton.m
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "MusicButton.h"


@implementation MusicButton{
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    SKShapeNode *circle;
}

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        self.position = CGPointMake(x, y);
        circle = [[SKShapeNode alloc]init];
        circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        circle.strokeColor = [self randomColor];
        [self addChild:circle];
        
        _player = [[AVAudioPlayer alloc]init];
    }
    
    
    return self;
}

// loadSound: loads the audio files
-(void)loadSound{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"air-horn" ofType:@"mp3"];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:soundPath];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = 1.0;
    if(error) NSLog(@"Error loading sound file! error = %@", error);
}

// playSound: plays the audio files --
-(void)playSound{
    _player.currentTime = 0;
    _player.numberOfLoops = -1;
    [_player play];
}

// stopSound: stops looping of sound
-(void)stopSound{
    _player.numberOfLoops = 0;
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"HI");
}
*/
-(void)setDefault{
    SKLabelNode *plus = [[SKLabelNode alloc] init];
    plus.name= @"add";
    plus.text = @"+";
    plus.fontColor = circle.strokeColor;
    //plus.fontName = @"Avenir";
    plus.fontSize = circle.frame.size.width/1.5;
    plus.position = CGPointMake(0,-plus.frame.size.height/2);
    [self addChild:plus];
    
    self.hasSound = false;
}

-(void)setButton{
    [self loadSound];
    circle.fillColor = circle.strokeColor;
    [self enumerateChildNodesWithName:@"add" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    self.hasSound = true;
    
}

// randomColor : generates and returns a random color
-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"HI");
}

@end
