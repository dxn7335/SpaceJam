//
//  AddButton.m
//  Space Jam
//
//  Created by Danny on 12/14/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "AddButton.h"

@implementation AddButton{
    SKShapeNode *_circle;
    NSMutableArray *circles;
    BOOL _optionsShown;
}

-(id)initAddButton : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        self.position = CGPointMake(x, y);
        circles = [[NSMutableArray alloc] init];
        
        SKNode *btn = [[SKNode alloc] init];
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [UIColor whiteColor];
        _circle.alpha = 0.8;
        self.color = _circle.strokeColor;
        btn.name = @"create";
        [btn addChild:_circle];
        
        SKLabelNode *label = [[SKLabelNode alloc] init];
        label.text = @"+";
        label.fontColor = [UIColor whiteColor];
        //plus.fontName = @"Avenir";
        label.fontSize = 30;
        label.position = CGPointMake(0,-label.frame.size.height/2);
        [btn addChild:label];
        
        self.userInteractionEnabled = YES;
        
        [self addChild:btn];
        [circles addObject:btn];
        
        // if add as been clicked
        _optionsShown = NO;
        self.method = @"none";
    }
    return self;
}

/*//  TOUCH EVENT  //*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Add");
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    for (SKNode *circle in circles) {
        if ([node.parent isEqual: circle]) {
            //hitting the add
            if ([circle.name isEqual:@"create"]) {
                if(!_optionsShown){
                    [self showOptions];
                    [self notifyAddMode];
                }
                else{
                    //notifies to exit mode
                    [self hideOptions];
                    [self resetButton];
                    [self notifyAddMode];
                }
            }
            //hitting preset
            else if ([circle.name isEqualToString:@"preset"]){
                self.method = @"preset";
                [self notifyAddMode];
                [self selectMethod];
            }
            //hitting record
            else if ([circle.name isEqualToString:@"record"]){
               self.method = @"record";
                [self notifyAddMode];
                [self selectMethod];
                
            }
        }
    }
    
}

// NOTIFICATION  ///////////////////
-(void)notifyAddMode{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSNumber *isOn = @(_optionsShown);
    dict[@"on"] = isOn;
    dict[@"method"] = (self.method) ? self.method:@"none";
    //publish notification
    [notificationCenter postNotificationName:kAddNotification object:self userInfo:dict];
}

// FUNCTIONALITY FUNCTIONS

// show other adding options
-(void)showOptions{
    [self createPreset];
    [self createRecord];
    _optionsShown = YES;
    //self.userInteractionEnabled = NO;
}
//hides the adding options
-(void)hideOptions{
    SKAction *fadeout = [SKAction fadeOutWithDuration:0.3];
    SKAction *slide = [SKAction moveByX:-10 y:0 duration:0.3];
    for (SKNode *btn in circles) {
        if(btn != [self childNodeWithName:@"create"]){
            [btn runAction:[SKAction group:@[fadeout,slide]] completion:^{
                SKAction *remove = [SKAction removeFromParent];
                [btn runAction:remove];
                [circles removeObject:btn];
            }];
        }
        else btn.alpha = 0.8;
    }
    _optionsShown = NO;
    
}

// handler when an option is selected
-(void)selectMethod{
    for (SKNode *btn in circles) {
        if([btn.name isEqualToString:self.method]){
            btn.alpha = 1;
        }
        else {
            btn.alpha = 0.35;
        }
    }
}

//Reset Button Settings
-(void)resetButton{
    [self hideOptions];
    self.method = @"none";
}

-(void)createPreset{
    NSLog(@"SHow Preset");
    SKNode *btn = [[SKNode alloc]init];
    SKShapeNode *presetCir = [[SKShapeNode alloc]init];
    btn.name = @"preset";
    btn.position = CGPointMake(-self.frame.size.width/2, -_circle.frame.size.height*1.75);
    presetCir = [[SKShapeNode alloc]init];
    presetCir.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width+40, self.frame.size.height+40)].CGPath;
    
    presetCir.strokeColor = [UIColor whiteColor];
    presetCir.alpha = 0.6;
    self.color = presetCir.strokeColor;
    
    SKSpriteNode *spriteImg = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    spriteImg.size = CGSizeMake(25, 25);
    spriteImg.position = CGPointMake(presetCir.frame.size.width/2, presetCir.frame.size.height/2);
    [btn addChild:spriteImg];
    [btn addChild:presetCir];
    btn.alpha = 0;
    [self addChild: btn];
    [circles addObject:btn];
    
    SKAction *fadein = [SKAction fadeInWithDuration:0.3];
    SKAction *slide = [SKAction moveByX:10 y:0 duration:0.3];
    [btn runAction:[SKAction group:@[fadein,slide]]];
}

-(void)createRecord{
    SKNode *btn = [[SKNode alloc]init];
    SKShapeNode *recordCir = [[SKShapeNode alloc]init];
    btn.name = @"record";
    btn.position = CGPointMake(-self.frame.size.width/2-60, -_circle.frame.size.height*1.75);
    recordCir = [[SKShapeNode alloc]init];
    recordCir.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width+40, self.frame.size.height+40)].CGPath;
    
    recordCir.strokeColor = [UIColor whiteColor];
    recordCir.alpha = 0.6;
    self.color = recordCir.strokeColor;
    
    SKSpriteNode *spriteImg = [SKSpriteNode spriteNodeWithImageNamed:@"microphone"];
    spriteImg.position = CGPointMake(recordCir.frame.size.width/2, recordCir.frame.size.height/2);
    spriteImg.size = CGSizeMake(15, 25);
    [btn addChild:spriteImg];
    [btn addChild:recordCir];
    [self addChild:btn];
    [circles addObject:btn];
    
    SKAction *fadein = [SKAction fadeInWithDuration:0.3];
    SKAction *slide = [SKAction moveByX:10 y:0 duration:0.3];
    [btn runAction:[SKAction group:@[fadein,slide]]];
    
}
@end
