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
#import "MusicButton.h"


@implementation GameScene{
    MusicButton *_currentBtn;
    NSMutableArray *_signals;
    RemoveButton *_removeBtn;
    AddButton *_addBtn;
    SKLabelNode *_instrLabel;
}

static const uint8_t signalCategory = 1;
static const uint8_t soundBtnCategory = 2;
static const double musicBtnSize = 50;



// SETUP
-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    self.backgroundColor = [UIColor blackColor];
    
    //Background Image
    
    SKSpriteNode *backImg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    backImg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    backImg.zPosition = -1;
    backImg.alpha = 0;
    backImg.name = @"bgNode";
    [self addChild:backImg];
    
    self.musicBtns = [[NSMutableArray alloc] init];
    
    //init singals array
    _signals = [NSMutableArray array];
    
    //create preset planets
    [self createPresetPlanets];
    
    double editsize = 40;
    // ADD BUTTON
    _addBtn = [[AddButton alloc] initAddButton:self.frame.size.height-(11*editsize) : self.frame.size.height -editsize :editsize :editsize];
    [self addChild:_addBtn];
  
    // REMOVE BUTTON
    _removeBtn = [[RemoveButton alloc] initRemoveButton:self.frame.size.height-(12.5*editsize) : self.frame.size.height - editsize :editsize :editsize ];
    [self addChild:_removeBtn];
    
    
    // INSTRUCTIONS LABEL
    _instrLabel = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    _instrLabel.fontSize = 16;
    _instrLabel.position = CGPointMake( self.frame.size.width/2+_instrLabel.fontSize*3.25, self.frame.size.height - 45);
    _instrLabel.fontColor = [UIColor whiteColor];
    _instrLabel.text = @"";
    [self addChild:_instrLabel];
    
    //Physics Collision
    self.physicsWorld.contactDelegate = self;
    
    
    //init Notification Listeners (had to do it, coach)
    [[NSNotificationCenter defaultCenter]
        addObserver: self
     
        selector: @selector(handleRemoveNotification:)
        name: kRemoveNotification
        object: _removeBtn
     ];
    
    [[NSNotificationCenter defaultCenter]
        addObserver: self
     
        selector: @selector(handleAddNotification:)
        name: kAddNotification
        object: _addBtn
     ];
    
    
    //init Start mode
    [self initStartAnimation];
    
}




/*------------------------------------------------------------------*/
// HANDLE NOTIFICATIONS
/*------------------------------------------------------------------*/
// Remove Button
-(void) handleRemoveNotification:(NSNotification *)notification{
    NSDictionary *removeInfo = notification.userInfo;
    
    if([removeInfo[@"on"] boolValue]) {
        [self setRemoveMode];
    }
    else {
        [self setDefaultMode];
    }
}

// Add Button
-(void) handleAddNotification:(NSNotification *)notification{
    NSDictionary *addInfo = notification.userInfo;
    
    if([addInfo[@"on"] boolValue]) {
        [self setAddMode];
        
        //_instrLabel.text = @"Tap anywhere to add a planet with sound";

        
        if([_addBtn.method isEqualToString:@"preset"]){
            _instrLabel.text = @"Tap anywhere to add a planet with sound";
        }
        //if recording chosen
        else if([_addBtn.method isEqualToString:@"record"]){
            _instrLabel.text = @"Tap anywhere to add and start recording your own sound";
        }
    }
    else {
        [self setDefaultMode];
    }
    
}

///////////////////////////////////////////////////
// Set back visual for default mode
-(void)setDefaultMode{
    self.currentMode = MODE_DEFAULT;
    _addBtn.alpha = 1;
    _addBtn.userInteractionEnabled = YES;
    _removeBtn.alpha = 1;
    _removeBtn.userInteractionEnabled = YES;
    _instrLabel.text = @"";
    for (MusicButton *musicNode in self.musicBtns) {
            [musicNode restoreDefault];
    }
}

//visuals for remote mode
-(void)setRemoveMode {
    self.currentMode = MODE_REMOVE;
    for (MusicButton *musicNode in self.musicBtns) {
        [musicNode canRemove];
    }
    
    _instrLabel.text = @"Tap on a planet to remove it";
    _addBtn.alpha = 0.3;
    _addBtn.userInteractionEnabled = NO;
}

//visuals for add mode
-(void)setAddMode {
    self.currentMode = MODE_ADD;
    _instrLabel.text = @"Add a planet with preset sounds or record your own";
    _removeBtn.alpha = 0.3;
    _removeBtn.userInteractionEnabled = NO;
}



/*------------------------------------------------------------------*/
// STARTING SCREEN ANIMATION SEQUENCE
/*------------------------------------------------------------------*/
-(void)createPresetPlanets{
    // TEST: Creating buttons
    // Parameters x, y, width, height
    MusicButton *btn1 = [[MusicButton alloc] initWithProperties: self.frame.size.width/3 :self.frame.size.height/1.8 : 50 :50:soundBtnCategory:signalCategory];;
    [btn1 setButton];
    [self.musicBtns addObject:btn1];
    [self addChild:btn1];
    
    
    MusicButton *btn2 = [[MusicButton alloc] initWithProperties:550:300: 50: 50:soundBtnCategory:signalCategory];
    //[btn2 loadSound];
    [btn2 setButton];
    [self.musicBtns addObject:btn2];
    [self addChild:btn2];
    
    MusicButton *btn3 = [[MusicButton alloc] initWithProperties: self.frame.size.height-100 :560 : 50 :50:soundBtnCategory:signalCategory];;
    [btn3 setButton];
    [self.musicBtns addObject:btn3];
    [self addChild:btn3];
    
    MusicButton *btn4 = [[MusicButton alloc] initWithProperties: 480 :100 : 50 :50:soundBtnCategory:signalCategory];;
    [btn4 setButton];
    [self.musicBtns addObject:btn4];
    [self addChild:btn4];
}


//////////////////////////////////////////////
// start animation settings -----------------/
-(void) initStartAnimation{
    self.maxScale = 20;
    
    _addBtn.alpha = 0;
    _removeBtn.alpha = 0;

    self.currentMode = MODE_INIT;
    
    for( MusicButton *node in _musicBtns){
        node.alpha = 0;
    }
    
    SKShapeNode *circle = [self drawCircle:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self addChild:circle];
    circle.name = @"start";
    
    //instructions
    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    label.name = @"instruction";
    label.text = @"TAP HERE TO SEND A SIGNAL";
    label.fontSize = 15;
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+circle.frame.size.height/2+20);
    [self addChild:label];
    
    SKLabelNode *label2 = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    label2.name = @"instruction2";
    label2.text = @"THE PLANETS MAY SEND ONE BACK";
    label2.fontSize = 15;
    label2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-circle.frame.size.height+10);
    [self addChild:label2];
}


/* PRIVATE METHODS */

// HELPER
-(SKShapeNode*)drawCircle: (CGPoint)point{
    /* initial circle */
    SKShapeNode *circle = [[SKShapeNode alloc] init];
    //signal.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-25, point.y-25, 50, 50)].CGPath;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, 50, 0.0, (2 * M_PI), NO);
    circle.path = path;
    circle.position = point;
    circle.strokeColor = [UIColor whiteColor];
    
    //physics
    circle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:circle.frame.size];
    circle.physicsBody.dynamic = YES;
    circle.physicsBody.affectedByGravity = NO;
    circle.physicsBody.categoryBitMask = signalCategory;
    circle.physicsBody.contactTestBitMask = soundBtnCategory;
    circle.physicsBody.collisionBitMask = 0;
    
    return circle;
}

// Creating the Signal on tap
-(void)drawSignal: (CGPoint)point{
    
    __block SKSpriteNode *signal = [[SKSpriteNode alloc] init];
    [self addChild: signal];
    
    [_signals addObject:signal];
    
    /* initial circle */
    SKShapeNode *circle = [self drawCircle:point];
    [signal addChild:circle];
    
    // Signal will constantly grow to a certain point
    __block SKAction *scale = [SKAction scaleTo:2.5 duration: 0.6];
    __block SKAction *fadeout = [SKAction fadeOutWithDuration:0.65];
    __block SKAction *grow = [SKAction group:@[scale,fadeout]];
    [circle runAction:grow completion:^{
        SKAction *remove = [SKAction removeFromParent];;
        [circle runAction: remove];
    }];
    
    /////////////////
    /* RUN LOOPED SEQUENCE TO REPEAT ADDING CIRCLES */
    [signal runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.5],
                                                                       [SKAction runBlock:^{
        SKShapeNode *circle = [self drawCircle:point];
        [signal addChild: circle];
        
        // Signal will constantly grow to a certain point
        [circle runAction:grow completion:^{
            SKAction *remove = [SKAction removeFromParent];
            [circle runAction: remove];
        }];
        
    }]]]] withKey:@"drawLines"];
}


// Releases signal when touch ends
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
//////////////////////////////////////////////////////////////////
//ON TOUCH BEGIN
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Called when a touch begins
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if(self.currentMode == MODE_DEFAULT){
        [self drawSignal: location];
    }
    else if (self.currentMode == MODE_REMOVE){
        [self removeModeHandler:location];
        
    }
    else if (self.currentMode == MODE_ADD){
        [self addModeHandler:location];
    }
    else if (self.currentMode == MODE_INIT){
        [self initModeHandler:location];
    }

}

//ON TOUCH ENDED ////////////////////////////////////////////////
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self releaseSignal];
}


-(void)update:(CFTimeInterval)currentTime {
    //Called before each frame is rendered
    //NSLog(@"HIIIIIIIIIII");
    for (MusicButton *musicNode in self.musicBtns) {
        if(_signals.count == 0 && musicNode.hasSound)
            [musicNode stopSound];
    }
}








/*  HANDLERS  */
//---------------------------------------------------------------
// INIT MODE HANDLER
//---------------------------------------------------------------
-(void) initModeHandler: (CGPoint)point{
    SKNode *node = [self nodeAtPoint:point];
    
    if([node.name isEqualToString:@"start"]){
        
        __block SKAction *remove = [SKAction removeFromParent];
        //Remove Instructions
        SKNode *instr = [self childNodeWithName:@"instruction"];
        SKNode *instr2 = [self childNodeWithName:@"instruction2"];
        [instr runAction:remove];
        [instr2 runAction:remove];
        
        // Signal will constantly grow to a certain point
        SKAction *scale = [SKAction scaleTo:9 duration: 1];
        SKAction *fadeout = [SKAction fadeOutWithDuration:0.9];
        SKAction *grow = [SKAction group:@[scale,fadeout]];
        [node runAction:grow completion:^{
            //fade in bg
            SKAction *fadein = [SKAction fadeInWithDuration:0.6];
            SKNode *bg = [self childNodeWithName:@"bgNode"];
            [bg runAction:fadein];
            [_addBtn runAction:fadein];
            [_removeBtn runAction:fadein];
            [node runAction: remove];
            [self setDefaultMode];
        }];
    }
}

//---------------------------------------------------------------
// REMOVE MODE HANDLER
//---------------------------------------------------------------
-(void)removeModeHandler:(CGPoint)point{
    SKNode *node = [self nodeAtPoint:point];
    NSLog(@"remove it");
    for (MusicButton *musicNode in self.musicBtns) {
        if( [node.parent isEqual:musicNode] ){
            SKAction *remove = [SKAction removeFromParent];
            [musicNode runAction:remove completion:^{
                [self.musicBtns removeObject:musicNode];
            }];
        return;
        }
    }
}

//---------------------------------------------------------------
// ADD MODE HANDLER
//---------------------------------------------------------------
-(void)addModeHandler:(CGPoint)point{
    if(![_addBtn.method isEqualToString:@"none"]){
        
        MusicButton *newBtn = [[MusicButton alloc] initWithProperties:point.x :point.y :musicBtnSize :musicBtnSize :soundBtnCategory :signalCategory];
        
        //if preset sounds chosen
        if([_addBtn.method isEqualToString:@"preset"]){
            [newBtn setButton];
        }
        //if recording chosen
        else if([_addBtn.method isEqualToString:@"record"]){
            [newBtn prepareRecording];
            _addBtn.method = @"recording";
        }
        
        [self addChild:newBtn];
        [_musicBtns addObject:newBtn];
        [_addBtn resetButton];
        [self setDefaultMode];
    }
}


//---------------------------------------------------------------
// Collision
//---------------------------------------------------------------
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & signalCategory) != 0)
    {
        //WHEN A SIGNAL HITS A PLANET/MUSIC BUTTON, IT WILL RESPOND BY PLAYING ITS SOUND
        SKNode *nodehit = (contact.bodyA.categoryBitMask & signalCategory) ? contact.bodyB.node : contact.bodyA.node;
        for (MusicButton *musicNode in self.musicBtns) {
            if ([nodehit  isEqual: musicNode]) {
                if( !musicNode.tapped && musicNode.hasSound){
                    [musicNode playSound];
                    
                    if(musicNode.alpha == 0){
                        SKAction *fadein = [SKAction fadeInWithDuration:0.2];
                        [musicNode runAction:fadein];
                    }
                }
                
            }
        }
        
    }
}




@end
