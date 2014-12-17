//
//  MusicButton.m
//  Space Jam
//
//  Created by Student on 12/3/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "MusicButton.h"
#import <math.h>
#import "DataStore.h"
#import "Sound.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation MusicButton{
    SKShapeNode *_circle;
    SKLabelNode *_label;
    
    NSMutableArray *_lines;
    NSTimer *_drawInteral;
}

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height : (uint8_t)categorymask :(uint8_t )contactmask{
    self = [super init];
    if (self != nil) {
        _lines = [[NSMutableArray alloc]init];
        
        self.position = CGPointMake(x, y);
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [self randomColor];
        self.color = _circle.strokeColor;
        
        [self addChild:_circle];
        self.userInteractionEnabled = NO;

        _player = [[AVAudioPlayer alloc]init];
        
        [self setDefault];
        
        [self addPhysics:categorymask withContact:contactmask rect:CGRectMake(-width/2, -height/2, width, height)];
  
    }
    return self;
}

-(void)addPhysics:(uint8_t)categorymask withContact:(uint8_t )contactmask rect:(CGRect)rect{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = categorymask;
    self.physicsBody.contactTestBitMask = contactmask;
    self.physicsBody.collisionBitMask = 0;
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
        int i = arc4random_uniform([DataStore sharedStore].allItems.count);
        NSLog(@"%d", i);
        Sound *sound = [DataStore sharedStore].allItems[i];
        NSLog(@"%@", sound);
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:sound.name ofType:sound.type];
        url = [[NSURL alloc]initFileURLWithPath:soundPath];
    }
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = (self.recording) ? 10.0:1.0;
    if(error) NSLog(@"Error loading sound file! error = %@", error);
}


// IF ABLE TO REMOVE
-(void)canRemove{
    _circle.strokeColor = [UIColor redColor];
}

-(void)restoreDefault{
    _circle.strokeColor = self.color;
}



/*---------------------------------------------------------------------------/
 // PLAY/STOP AUDIO
 /---------------------------------------------------------------------------*/
// playSound: plays the audio files --
-(void)playSound{
    _tapped = true;
    [self glowOnTouch];
    [_player stop];
    _player.currentTime = 0;
    _player.numberOfLoops = -1;
    [_player play];

    //_circle.strokeColor = [self randomColor];
}

// Effecting Button Reaction when tapped
-(void)buttonTap: (BOOL)tap{
    _tapped = tap;
    if(tap){
        [self runAction:[SKAction scaleBy:.8 duration:0.1]];
    }
    else{
        [self runAction:[SKAction scaleBy:1.25 duration:0.1]];
    }
}

// stopSound: stops looping of sound
-(void)stopSound{
    _tapped = false;
    _player.numberOfLoops = 0;
    
    SKNode *glow = [self childNodeWithName:@"glow"];
    SKAction *fadeout = [SKAction fadeOutWithDuration:0.4];
    [glow runAction:fadeout completion:^{
        SKAction *remove = [SKAction removeFromParent];;
        [glow runAction: remove];
    }];
    //_circle.strokeColor = self.color;
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
    _label.text= @"REC";
    _label.fontSize = 13;
    _label.position = CGPointMake(0,-_label.frame.size.height/2);
    _label.fontColor = [UIColor whiteColor];
    _label.fontName = @"Avenir Black";
    SKShapeNode *recCirc = [[SKShapeNode alloc]init];
    recCirc.name = @"recIcon";
    double width = _circle.frame.size.width/2;
    double height= _circle.frame.size.height/2;
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
    self.userInteractionEnabled = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setActive:YES error:nil];
    
    // Start recording
    [_recorder record];
    self.recording = true;
}

-(void)stopRecording{
    self.userInteractionEnabled = NO;
    
    [_recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:NO error:nil];
    ;
    [self setButton];
}


/*----------------------------------------------------------------------/
// TAP VISUALS
/----------------------------------------------------------------------*/
/*
// draws a line from center of circle
-(void)drawLine: (CGPoint)center : (double)radius : (double)angle{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:center];
    CGFloat tX = center.x + radius * cos(angle);
    CGFloat tY = center.y + radius * sin(angle);
    CGPoint target = CGPointMake(tX, tY);
    [linePath addLineToPoint:target];
    SKShapeNode *line = [[SKShapeNode alloc]init];
    line.path = linePath.CGPath;
    line.alpha = 0.5;
    line.strokeColor = self.color;
    [self addChild:line];
    
    SKAction *fadeout = [SKAction fadeOutWithDuration:0.1];
    [line runAction:fadeout];
    [_lines addObject:line];
}

-(void)drawPattern: (double)height{
    double angle = 0;
    double minRad = _circle.frame.size.width/2+height;
    double maxRad = _circle.frame.size.width*2;
    double radius = _circle.frame.size.width/2+height;
    bool atMax = false;
    while(angle < 360){
        if(radius < maxRad && !atMax){
            radius += 3 + arc4random() % (8);;
        }
        else {
            atMax = true;
            if(radius > minRad)
                radius -= 3 + arc4random() % (8);
            else
                atMax = false;
        }
        angle += 1.5;
        
        [self drawLine:_circle.position :radius :DEGREES_TO_RADIANS(angle)];
    }
}


-(void)clearLines{
    
    for(int i=0; i< _lines.count; i++){
        [_lines[i] removeFromParent];
        [_lines removeObjectAtIndex:i];
    }
}*/

-(void)glowOnTouch {
    /*__block double multiplier = 2;
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.01],
                                                                      [SKAction runBlock:^{
        [self drawOutline: multiplier];
        multiplier +=0.05;
        
        if(multiplier > 3) multiplier = 2;
        
        if(_tapped == 0){
            [self removeActionForKey:@"drawLines"];
        }
        
    }]]]] withKey:@"drawLines"];*/
    double width = _circle.frame.size.width * 1.75;
    double height = _circle.frame.size.height * 1.75;
    SKShapeNode *circle = [[SKShapeNode alloc]init];
    circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
    circle.alpha = 0;
    circle.name = @"glow";
    circle.strokeColor = self.color;
    //fadein
    SKAction *fadein = [SKAction fadeInWithDuration:0.05];
    [circle runAction:fadein];
    [self addChild:circle];
}

/*
-(void)removeLines {
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.2],
                                                                       [SKAction runBlock:^{
    
        if(_lines.count > 0){
            NSLog(@"remove");
            [_lines[0] removeFromParent];
            [_lines removeObjectAtIndex:0];
            
            if(_lines.count > 40) [self clearLines];
        }
        else{
            [self removeActionForKey:@"removeLines"];
        }

    }]]]] withKey:@"removelines"];
    
}*/


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
**/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //objc_msgSend(_targetTouchDown, _actionTouchDown, self);
    if(self.hasSound){
        [self playSound];
        //change button visual
        [self buttonTap:TRUE];
        [self glowOnTouch];
    }
    else{
        if(!self.recording){
            [self prepareRecording];
            //change button visual
            [self buttonTap:TRUE];
        }
        else
            [self stopRecording];
    }
    
    
}



@end
