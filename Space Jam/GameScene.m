//
//  GameScene.m
//  Space Jam
//
//  Created by Danny on 12/2/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

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
    MusicButton *btn1 = [[MusicButton alloc] initWithProperties:CGRectGetWidth(self.frame)/2-50 :CGRectGetHeight(self.frame)/2 :100 :100];
    btn1.userInteractionEnabled = NO;
    [btn1 loadSound];
    [self.musicBtns addObject:btn1];
    [self addChild:btn1];
    
    MusicButton *btn2 = [[MusicButton alloc] initWithProperties:CGRectGetWidth(self.frame)/2-50 :CGRectGetHeight(self.frame)/2+100 :50 :50];
    btn2.userInteractionEnabled = NO;
    [self.musicBtns addObject:btn2];
    [self addChild:btn2];
    
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
        if ([node isEqual: musicNode]) {
            [musicNode playSound];
        }
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
