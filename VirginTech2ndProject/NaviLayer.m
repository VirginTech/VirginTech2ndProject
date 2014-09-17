//
//  NaviLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "NaviLayer.h"
#import "TitleScene.h"

@implementation NaviLayer

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

    //タイトルボタン
    CCButton *titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:20.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.5f, 0.30f);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];

    //プレイバック
    CCButton *playbackButton = [CCButton buttonWithTitle:@"[プレイバック]" fontName:@"Verdana-Bold" fontSize:20.0f];
    playbackButton.positionType = CCPositionTypeNormalized;
    playbackButton.position = ccp(0.5f, 0.20f);
    [playbackButton setTarget:self selector:@selector(onPlaybackClicked:)];
    [self addChild:playbackButton];

    return self;
}

- (void)onPlaybackClicked:(id)sender
{
    
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
