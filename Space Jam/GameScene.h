//
//  GameScene.h
//  Space Jam
//

//  Copyright (c) 2014 Danny Nguyen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum: int{
    MODE_INIT,
    MODE_DEFAULT,
    MODE_ADD,
    MODE_REMOVE,
} SceneMode;

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic)SceneMode currentMode; // Used to tell what mode the player is on
@property (nonatomic) NSMutableArray *musicBtns;
@property (nonatomic) int maxScale;
@end
