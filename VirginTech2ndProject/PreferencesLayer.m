//
//  PreferencesLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PreferencesLayer.h"
#import "GameManager.h"
#import "TitleScene.h"

@implementation PreferencesLayer

CGSize winSize;

+(PreferencesLayer *)scene
{
    return [[self alloc] init];
}

-(id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;

    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    //閉じるボタン
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    //CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
    //                         [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"close.png"]];
    CCButton* closeButton=[CCButton buttonWithTitle:@"[閉じる]"];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    //closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    return self;
}

-(void)onCloseClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
