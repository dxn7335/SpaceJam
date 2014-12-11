//
//  GameScene.m
//  Space Jam
//
//  Created by Danny on 12/2/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{
    MusicButton *_currentBtn;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    /*
     SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
     
     myLabel.text = @"Hello, World!";
     myLabel.fontSize = 65;
     myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
     CGRectGetMidY(self.frame));
     
     [self addChild:myLabel];
     */
    self.musicBtns = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    // TEST: Creating buttons
    // Parameters x, y, width, height
    MusicButton *btn1 = [[MusicButton alloc] initWithProperties: self.frame.size.width/2 :self.frame.size.height/2 : 75 :75];
    btn1.userInteractionEnabled = NO;
    //[btn1 loadSound];
    btn1.name = @"1";
    [btn1 setDefault];
    [btn1 setButton];
    [self.musicBtns addObject:btn1];
    [self addChild:btn1];
    
    
    MusicButton *btn2 = [[MusicButton alloc] initWithProperties:400:400: 75: 75];
    btn2.userInteractionEnabled = NO;
    //[btn2 loadSound];
    btn2.name = @"2";
    [btn2 setDefault];
    [self.musicBtns addObject:btn2];
    [self addChild:btn2];
    
    /*
    SKLabelNode *plus = [[SKLabelNode alloc] init];
    plus.text = @"+";
    plus.fontColor = btn1.strokeColor;
    plus.fontName = @"Avenir";
    plus.fontSize = 50;
    plus.position = CGPointMake(CGRectGetWidth(self.frame)/2-50 ,CGRectGetHeight(self.frame)/2);*/
    //[btn1 addChild:plus];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*
     for (UITouch *touch in touches) {
     CGPoint location = [touch locationInNode:self];
     
     SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
     
     sprite.xScale = 0.5;
     sprite.yScale = 0.5;
     sprite.position = location;
     
     SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
     
     [sprite runAction:[SKAction repeatActionForever:action]];
     
     [self addChild:sprite];
     }
     */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
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
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_currentBtn != nil){
        [_currentBtn stopSound];
        _currentBtn = nil;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
