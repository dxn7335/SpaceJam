//
//  AddButton.m
//  Space Jam
//
//  Created by Danny on 12/14/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "AddButton.h"

@implementation AddButton

-(id)initAddButton : (int) x : (int) y : (double)width : (double)height{
    self = [super initWithProperties:x :y :width :height];
    if (self != nil) {
        
        SKLabelNode *label = [[SKLabelNode alloc] init];
        label.text = @"+";
        label.fontColor = [UIColor whiteColor];
        //plus.fontName = @"Avenir";
        label.fontSize = 20;
        label.position = CGPointMake(0,-label.frame.size.height/2);
        [self addChild:label];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Add");
}
@end
