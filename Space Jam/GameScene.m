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
}

static const uint8_t signalCategory = 1;
static const uint8_t soundBtnCategory = 2;
static const double musicBtnSize = 50;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [UIColor blackColor];
    self.musicBtns = [[NSMutableArray alloc] init];
    //init singals array
    _signals = [NSMutableArray array];
    
    [self createPresetPlanets];
    
    double editsize = 40;
    // ADD BUTTON
    _addBtn = [[AddButton alloc] initAddButton:self.frame.size.height-(11*editsize) : self.frame.size.height -editsize :editsize :editsize];
    [self addChild:_addBtn];
  
    // REMOVE BUTTON
    _removeBtn = [[RemoveButton alloc] initRemoveButton:self.frame.size.height-(12.5*editsize) : self.frame.size.height - editsize :editsize :editsize ];
    [self addChild:_removeBtn];
    
    
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
    
    _addBtn.alpha = 0.3;
    _addBtn.userInteractionEnabled = NO;
}

//visuals for add mode
-(void)setAddMode {
    self.currentMode = MODE_ADD;
    
    _removeBtn.alpha = 0.3;
    _removeBtn.userInteractionEnabled = NO;
}



/*------------------------------------------------------------------*/
// STARTING SCREEN ANIMATION SEQUENCE
/*------------------------------------------------------------------*/
-(void)createPresetPlanets{
    // TEST: Creating buttons
    // Parameters x, y, width, height
    MusicButton *btn1 = [[MusicButton alloc] initWithProperties: self.frame.size.width/2 :self.frame.size.height/2 : 50 :50:soundBtnCategory:signalCategory];;
    btn1.name = @"1";
    [btn1 setButton];
    [self.musicBtns addObject:btn1];
    [self addChild:btn1];
    
    
    MusicButton *btn2 = [[MusicButton alloc] initWithProperties:400:400: 50: 50:soundBtnCategory:signalCategory];
    //[btn2 loadSound];
    btn2.name = @"2";
    [btn2 setButton];
    [self.musicBtns addObject:btn2];
    [self addChild:btn2];
}

// start animation settings -----------------/
-(void) initStartAnimation{
    self.maxScale = 20;
}


/* PRIVATE METHODS */
// Creating the Signal on tap
-(void)drawSignal: (CGPoint)point{
    
    __block SKSpriteNode *signal = [[SKSpriteNode alloc] init];
    [self addChild: signal];
    
    [_signals addObject:signal];
    
    /* initial circle */
    SKShapeNode *circle = [[SKShapeNode alloc] init];
    //signal.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-25, point.y-25, 50, 50)].CGPath;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, 50, 0.0, (2 * M_PI), NO);
    circle.path = path;
    circle.position = point;
    circle.strokeColor = [UIColor whiteColor];
    [signal addChild: circle];
    
    //physics
    circle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:circle.frame.size];
    circle.physicsBody.dynamic = YES;
    circle.physicsBody.affectedByGravity = NO;
    circle.physicsBody.categoryBitMask = signalCategory;
    circle.physicsBody.contactTestBitMask = soundBtnCategory;
    circle.physicsBody.collisionBitMask = 0;
    // Signal will constantly grow to a certain point
    __block SKAction *scale = [SKAction scaleTo:2.5 duration: 0.6];
    __block SKAction *fadeout = [SKAction fadeOutWithDuration:0.65];
    __block SKAction *grow = [SKAction group:@[scale,fadeout]];
    [circle runAction:grow completion:^{
        SKAction *remove = [SKAction removeFromParent];;
        [circle runAction: remove];
    }];
    
    /* RUN LOOPED SEQUENCE TO REPEAT ADDING CIRCLES */
    [signal runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.5],
                                                                       [SKAction runBlock:^{
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
        [signal addChild: circle];
        
        // Signal will constantly grow to a certain point
        [circle runAction:grow completion:^{
            SKAction *remove = [SKAction removeFromParent];
            [circle runAction: remove];
        }];
        
    }]]]] withKey:@"drawLines"];

    
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
    
    if(self.currentMode == MODE_DEFAULT){
        [self drawSignal: location];
    }
    else if (self.currentMode == MODE_REMOVE){
        [self removeModeHandler:location];
        
    }
    else if (self.currentMode == MODE_ADD){
        [self addModeHandler:location];
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   /* if(_currentBtn != nil){
        [_currentBtn stopSound];
        _currentBtn = nil;
    }
    */
    
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
        
        SKNode *nodehit = (contact.bodyA.categoryBitMask & signalCategory) ? contact.bodyB.node : contact.bodyA.node;
        for (MusicButton *musicNode in self.musicBtns) {
            if ([nodehit  isEqual: musicNode]) {
                if( !musicNode.tapped && musicNode.hasSound)
                    [musicNode playSound];
                    //skaction alpha to 1
            }
        }
        
    }
}




@end
