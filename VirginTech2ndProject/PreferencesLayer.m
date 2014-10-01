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

    //バックグラウンド
    [self setBackGround];
    
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

-(void)setBackGround
{
    float offsetX;
    float offsetY;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"backGround_default.plist"];
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bg01.png"]];
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+1,
                                   winSize.height/frame.contentSize.height+1);
    NSString* bgName=[NSString stringWithFormat:@"bg%02d.png",(arc4random()%10)+1];
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        if(i==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = frame.contentSize.height/2-1;
        }else if(i%(int)frameCount.width==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = offsetY + frame.contentSize.height-1;
        }else{
            offsetX = offsetX + frame.contentSize.width-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame z:0];
    }
}

-(void)onCloseClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
