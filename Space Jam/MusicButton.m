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
    SKShapeNode *circle;
    int _x;
    int _y;
    double _w;
    double _h;
}

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        //self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, width, height)].CGPath;
                //self.fillColor = [self randomColor];
        //self.strokeColor = self.fillColor;
        //self.strokeColor = [self randomColor];
        //self.fillColor = [UIColor whiteColor];
        _x = x;
        _y = y;
        _w = width;
        _h = height;
        self.position = CGPointMake(x, y);
        circle = [[SKShapeNode alloc]init];
        circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        circle.strokeColor = [self randomColor];
        
        self.hasSound = false;
        [self addChild:circle];
    }
    
    _player = [[AVAudioPlayer alloc]init];
    
    return self;
}

// loadSound: loads the audio files
-(void)loadSound{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Oh Baby A Triple" ofType:@"mp3"];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:soundPath];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = 1.0;
    if(error) NSLog(@"Error loading sound file! error = %@", error);
}

// playSound: plays the audio files --
-(void)playSound{
    [_player play];
    NSLog(@"Lanxi you bitch!");
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"HI");
}
*/
-(void)setDefault{
    SKLabelNode *plus = [[SKLabelNode alloc] init];
    plus.text = @"+";
    plus.fontColor = circle.strokeColor;
    //plus.fontName = @"Avenir";
    plus.fontSize = circle.frame.size.width/1.5;
    plus.position = CGPointMake(0,-plus.frame.size.height/2);
    [self addChild:plus];
}

-(void)setButton{
    [self loadSound];
    circle.fillColor = circle.strokeColor;
    [self removeAllChildren];
    
}

// randomColor : generates and returns a random color
-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

@end
