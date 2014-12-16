//
//  RemoveButton.m
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "RemoveButton.h"

@implementation RemoveButton{
    SKShapeNode *_circle;
    NSMutableArray *circles;
    BOOL _on;
}

-(id)initRemoveButton : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        self.position = CGPointMake(x, y);
        circles = [[NSMutableArray alloc] init];
        
        SKNode *btn = [[SKNode alloc] init];
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [UIColor whiteColor];
        _circle.alpha = 0.6;
        self.color = _circle.strokeColor;
        btn.name = @"create";
        [btn addChild:_circle];
        
        SKLabelNode *label = [[SKLabelNode alloc] init];
        label.text = @"-";
        label.fontColor = [UIColor whiteColor];
        //label.fontName = @"Avenir";
        label.fontSize = 75;
        label.position = CGPointMake(0, -_circle.frame.size.height/1.65 + label.frame.size.height);
        [btn addChild:label];
        
        self.userInteractionEnabled = YES;
        
        [self addChild:btn];
        [circles addObject:btn];
        
        _on = NO;
        
    }
    return self;
}

-(void)toggleOn: (BOOL)value{
    _on = value;
    if(value == YES){
        _circle.fillColor = [UIColor redColor];
        _circle.strokeColor = [UIColor redColor];
        _circle.alpha = 1;
    }else {
        _circle.fillColor = nil;
        _circle.strokeColor = [UIColor whiteColor];
        _circle.alpha = 0.6;

    }
}

-(void)notifyRemoveMode{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSNumber *isOn = @(_on);
    dict[@"on"] = isOn;
    //publish notification
    [notificationCenter postNotificationName:kRemoveNotification object:self userInfo:dict];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Remove");
    //if remove is already on, turn off
    if(_on) {
        [self toggleOn:NO];
        [self notifyRemoveMode];
    }else{
        [self toggleOn:YES];
        [self notifyRemoveMode];
    }
}
@end
