//
//  NaviLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "NaviLayer.h"
#import "TitleScene.h"
#import "StageLevel_01.h"
#import "GameManager.h"
#import "InfoLayer.h"

@implementation NaviLayer

@synthesize titleButton;
@synthesize playbackButton;

CGSize winSize;

+ (NaviLayer *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    [self addChild:background];

    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    
    //タイトルボタン
    if([GameManager getLocale]==1){//英語
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                          [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"title_en.png"]];
    }else{
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                          [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"title_jp.png"]];
    }
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.425f, 0.25f);
    titleButton.scale=0.5;
    titleButton.rotation=-35;
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];

    //プレイバック
    if([GameManager getLocale]==1){//英語
        playbackButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playback_en.png"]];
    }else{
        playbackButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playback_jp.png"]];
    }
    playbackButton.positionType = CCPositionTypeNormalized;
    playbackButton.position = ccp(0.575f, 0.25f);
    playbackButton.scale=0.5;
    playbackButton.rotation=-35;
    [playbackButton setTarget:self selector:@selector(onPlaybackClicked:)];
    [self addChild:playbackButton];

    return self;
}

- (void)onPlaybackClicked:(id)sender
{
    if([GameManager getPlayBackCount]>0){
        //プレイバック回数セット
        [GameManager setPlayBackCount:[GameManager getPlayBackCount]-1];
        //プレイバック表示セット
        [InfoLayer update_PlayBack];
        //プレバック・スタート
        [StageLevel_01 startPlayBack];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"プレイバック"
                                                        message:@"プレイバック機能は５回までです。"
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"は　い", nil];
        [alert show];
    }
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
