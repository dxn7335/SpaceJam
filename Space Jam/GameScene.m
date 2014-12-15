//
//  GameScene.m
//  Space Jam
//
//  Created by Danny on 12/2/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "GameScene.h"
#import "AddButton.h"
#import "RemoveButton.h"

@implementation GameScene{
    MusicButton *_currentBtn;
    NSMutableArray *_signals;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    self.musicBtns = [[NSMutableArray alloc] init];
    //init singals array
    _signals = [NSMutableArray array];
    
    self.backgroundColor = [UIColor blackColor];
    
    
    // TEST: Creating buttons
    // Parameters x, y, width, height
    MusicButton *btn1 = [[MusicButton alloc] initWithProperties: self.frame.size.width/2 :self.frame.size.height/2 : 60 :60];
    //[btn1 loadSound];
    btn1.name = @"1";
    [btn1 setDefault];
    [btn1 setButton];
    //[btn1 setTouchUpInsideTarget:self action:@selector(stopSound)];
    [self.musicBtns addObject:btn1];
    [self addChild:btn1];
    
    
    MusicButton *btn2 = [[MusicButton alloc] initWithProperties:400:400: 60: 60];
    //[btn2 loadSound];
    btn2.name = @"2";
    [btn2 setDefault];
    [self.musicBtns addObject:btn2];
    [self addChild:btn2];
    
    double editsize = 40;
    // ADD BUTTON
    AddButton *addBtn = [[AddButton alloc] initAddButton:self.frame.size.height-(2.5*editsize) :editsize :editsize :editsize];
    [self addChild:addBtn];
    NSLog(@"%f", addBtn.position.x);
    // REMOVE BUTTON
    RemoveButton *removeBtn = [[RemoveButton alloc] initWithProperties:self.frame.size.height-(editsize) :editsize :editsize :editsize ];
    [self addChild:removeBtn];
}


// Creating the Signal on tap
-(void)drawSignal: (CGPoint)point{
    SKShapeNode *signal = [[SKShapeNode alloc] init];
    signal.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-25, point.y-25, 50, 50)].CGPath;
    signal.strokeColor = [UIColor whiteColor];

    [self addChild: signal];
    [_signals addObject:signal];
     NSLog(@"%d", _signals.count);
}

-(void)releaseSignal{
    for (SKShapeNode *signal in _signals){
        
            SKAction *fadeout = [SKAction fadeOutWithDuration:0.4];
            [signal runAction:fadeout completion:^{
                SKAction *remove = [SKAction removeFromParent];
                [signal runAction:remove];
            }];
        
    }
    
    //clears array
    [_signals removeAllObjects];
}


/////////////////////////////////////////////////////////////////////
// TOUCH HANDLERS

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Called when a touch begins
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self drawSignal: location];

/*
    for (MusicButton *musicNode in self.musicBtns) {
        NSLog(@"node = %@", node.parent);
        //if ([node isEqual: musicNode]) {
        if ([node.parent  isEqual: musicNode]) {
            if(musicNode.hasSound){
                _currentBtn = musicNode;
                [musicNode playSound];
            }
            else{
                //[musicNode setButton];
                if(!musicNode.recording)
                    [musicNode prepareRecording];
                else
                    [musicNode stopRecording];
            }
        }
    }
 */
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   /* if(_currentBtn != nil){
        [_currentBtn stopSound];
        _currentBtn = nil;
    }
    */

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self releaseSignal];
}


-(void)update:(CFTimeInterval)currentTime {
    //Called before each frame is rendered
    //NSLog(@"HIIIIIIIIIII");
    
}

@end
