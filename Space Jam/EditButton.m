//
//  EditButton.m
//  Space Jam
//
//  Created by Danny on 12/15/14.
//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import "EditButton.h"

@implementation EditButton

-(id)initWithProperties : (int) x : (int) y : (double)width : (double)height{
    self = [super init];
    if (self != nil) {
        
        
        self.position = CGPointMake(x, y);
        _circle = [[SKShapeNode alloc]init];
        _circle.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-width/2, -height/2, width, height)].CGPath;
        _circle.strokeColor = [UIColor whiteColor];
        _circle.alpha = 0.6;
        self.color = _circle.strokeColor;
        
        self.userInteractionEnabled = YES;
        
        [self addChild:_circle];
        
    }
    return self;
}


@end
