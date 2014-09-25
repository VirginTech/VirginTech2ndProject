//
//  FingerObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "FingerObject.h"

@implementation FingerObject

CGSize winSize;

-(void)finger_Rotation_Schedule:(CCTime)dt
{
    if(self.rotation<15){
        self.rotation=self.rotation+0.3;
    }else{
        self.rotation=0;
    }
}

-(id)initWithFinger:(bool)roteFlg
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"puniObj_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"finger.png"]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];
        
        if(roteFlg){
            [self schedule:@selector(finger_Rotation_Schedule:)interval:0.01];
        }
    }
    return self;
}

+(id)createFinger:(bool)roteFlg
{
    return [[self alloc] initWithFinger:roteFlg];
}

@end
