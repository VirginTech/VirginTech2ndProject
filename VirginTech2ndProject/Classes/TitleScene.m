//
//  IntroScene.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/01.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "TitleScene.h"
#import "StageLevel_01.h"
#import "GameManager.h"
#import "InfoLayer.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation TitleScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //初回データ初期値設定
    [GameManager initialize_Clear_Level];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //インフォレイヤー
    [GameManager setStageNum:[GameManager load_Clear_Level]];
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"VirginTech 2nd Project" fontName:@"Verdana-Bold" fontSize:32.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *startButton = [CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:20.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.5f, 0.40f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];

    CCButton *continueButton = [CCButton buttonWithTitle:@"[コンティニュー]" fontName:@"Verdana-Bold" fontSize:20.0f];
    continueButton.positionType = CCPositionTypeNormalized;
    continueButton.position = ccp(0.5f, 0.30f);
    [continueButton setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueButton];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onStartClicked:(id)sender
{
    if([GameManager load_Clear_Level]>=0){
        [GameManager setStageNum:1];
    }else{
        [GameManager setStageNum:0];
    }
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onContinueClicked:(id)sender
{
    [GameManager setStageNum:[GameManager load_Clear_Level]+1];
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
