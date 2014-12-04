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
    SKShapeNode *_circle;
    SKLabelNode *_label;
}

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        self.position = CGPointMake(x, y);
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [self randomColor];
        [self addChild:_circle];
        
        _player = [[AVAudioPlayer alloc]init];
    }
    
    
    return self;
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
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"air-horn" ofType:@"mp3"];
        url = [[NSURL alloc]initFileURLWithPath:soundPath];
    }
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = (self.recording) ? 7.0:1.0;
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
    NSLog(@"Reording this motherfucker");
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
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 8] forKey:AVNumberOfChannelsKey];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"HI");
}

@end
