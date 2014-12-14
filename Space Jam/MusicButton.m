//
//  MusicButton.m
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "MusicButton.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation MusicButton{
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    SKShapeNode *_circle;
    SKLabelNode *_label;
    
    NSMutableArray *_lines;
}

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        _lines = [[NSMutableArray alloc]init];
        
        self.position = CGPointMake(x, y);
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [self randomColor];
        
        self.color = _circle.strokeColor;
        
        [self addChild:_circle];
        self.userInteractionEnabled = YES;
        
        _player = [[AVAudioPlayer alloc]init];
        /*
        CGRect bounds = CGRectMake(-width/2, -height/2, width+20, height+20);
        UIBezierPath *randomPath = [UIBezierPath bezierPath];
        [randomPath moveToPoint:RandomPoint(bounds)];
        [randomPath addCurveToPoint:RandomPoint(bounds) controlPoint1:RandomPoint(bounds) controlPoint2:RandomPoint(bounds)];
        
        UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0,-self.frame.size.height/2)
                                                             radius:50
                                                         startAngle:0
                                                           endAngle:DEGREES_TO_RADIANS(360)
                                                          clockwise:YES];
        
        SKShapeNode *p = [[SKShapeNode alloc]init];
        p.path = aPath.CGPath;
        p.strokeColor = _circle.strokeColor;
        [self addChild:p];
        
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(0,-self.frame.size.height/2)];
        [line addLineToPoint:CGPointMake(50,-self.frame.size.height/2+50)];
        SKShapeNode *p = [[SKShapeNode alloc]init];
        p.path = line.CGPath;
        p.strokeColor = _circle.strokeColor;
        [self addChild:p];
         */
        
        [self drawLines:_circle.position : self.frame.size.height/2+50 : DEGREES_TO_RADIANS(1)];
    }
    return self;
}

-(void)drawLines: (CGPoint)center : (double)radius : (double)angle{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:center];
    CGFloat tX = center.x + radius * cos(angle);
    CGFloat tY = center.y + radius * sin(angle);
    CGPoint target = CGPointMake(tX, tY);
    [linePath addLineToPoint:target];
    SKShapeNode *line = [[SKShapeNode alloc]init];
    line.path = linePath.CGPath;
    line.strokeColor = self.color;
    [self addChild:line];
    
    [_lines addObject:line];
}

CGPoint RandomPoint(CGRect bounds)
{
    return CGPointMake(CGRectGetMinX(bounds) + arc4random() % (int)CGRectGetWidth(bounds),
                       CGRectGetMinY(bounds) + arc4random() % (int)CGRectGetHeight(bounds));
}

/*---------------------------------------------------------------------------/
 // SETUP
 /---------------------------------------------------------------------------*/
-(void)setDefault{
    _label = [[SKLabelNode alloc] init];
    _label.name= @"add";
    _label.text = @"+";
    _label.fontColor = _circle.strokeColor;
    //plus.fontName = @"Avenir";
    _label.fontSize = _circle.frame.size.width/1.5;
    _label.position = CGPointMake(0,-_label.frame.size.height/2);
    [self addChild:_label];
    
    self.hasSound = false;
    self.recording = false;
}

-(void)setButton{
    [self loadSound];
    _circle.fillColor = _circle.strokeColor;
    [self enumerateChildNodesWithName:@"recIcon" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    //set label text to blank ????????????
    _label.text = @"";
    self.hasSound = true;
    self.recording = false;
    
}

// loadSound: loads the audio files
-(void)loadSound{
    NSURL *url;
    if(self.recording){
        NSLog(@"%@", _recorder.url);
        url = _recorder.url;
    }
    else{
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"HolyShit" ofType:@"wav"];
        url = [[NSURL alloc]initFileURLWithPath:soundPath];
    }
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = (self.recording) ? 10.0:1.0;
    if(error) NSLog(@"Error loading sound file! error = %@", error);
}

/*---------------------------------------------------------------------------/
 // PLAY/STOP AUDIO
 /---------------------------------------------------------------------------*/
// playSound: plays the audio files --
-(void)playSound{
    [_player stop];
    _player.currentTime = 0;
    _player.numberOfLoops = -1;
    [_player play];
    
}

// Effecting Button Reaction when tapped
-(void)buttonTap: (BOOL)tap{
    if(tap){
        [self runAction:[SKAction scaleBy:.8 duration:0.1]];
    }
    else{
        [self runAction:[SKAction scaleBy:1.25 duration:0.1]];
    }
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


/*---------------------------------------------------------------------------/
// RECORDING
/---------------------------------------------------------------------------*/
-(void) prepareRecording{
    NSLog(@"Recording this");
    /* Visuals */
    _label.text= @"Recording";
    _label.fontSize = 13;
    _label.position = CGPointMake(0,-_label.frame.size.height/2);
    _label.fontColor = [UIColor blackColor];
    _label.fontName = @"Avenir Black";
    SKShapeNode *recCirc = [[SKShapeNode alloc]init];
    recCirc.name = @"recIcon";
    double width = _circle.frame.size.width/2.25;
    double height= _circle.frame.size.height/2.25;
    recCirc.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
    recCirc.fillColor =  [UIColor redColor];
    recCirc.strokeColor = [UIColor redColor];
    [self addChild: recCirc];
    
    
    /* Ready Recorder */
    //create url string for recorded audio
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd-ss"];
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSString *urlstring = [NSString stringWithFormat:@"audioMemo_%@.m4a", timestamp];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               urlstring,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    // Initiate and prepare the recorder
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&error];
    if(error) NSLog(@"Error starting recording, error= %@", error);
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    
    // AUTOMATICALLY STARTS RECORDING
    [self startRecording];
    
}

-(void)startRecording{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setActive:YES error:nil];
    
    // Start recording
    [_recorder record];
    self.recording = true;
}

-(void)stopRecording{
    [_recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:NO error:nil];
    ;
    [self setButton];
}

/* HELPER --------------------------------------------------*/
// randomColor : generates and returns a random color
-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

#pragma -
#pragma mark Touch Handling

/**
 * This method only occurs, if the touch was inside this node. Furthermore if
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //objc_msgSend(_targetTouchDown, _actionTouchDown, self);
    if(self.hasSound){
        [self playSound];
        //change button visual
        [self buttonTap:TRUE];
    }
    else{
        NSLog(@"%d", self.recording);
        if(!self.recording){
            [self prepareRecording];
            //change button visual
            [self buttonTap:TRUE];
        }
        else
            [self stopRecording];
    }
    NSLog(@"HI");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.hasSound){
        [self stopSound];
        //change button visual
        [self buttonTap:FALSE];
    }
}

@end
