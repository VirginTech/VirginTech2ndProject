//
//  GameFeatLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/16.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "GameFeatLayer.h"
#import "GameManager.h"

@implementation GameFeatLayer

CGSize winSize;
GFIconView *iconView;

+ (GameFeatLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //アイコン広告
    gfIconController = [[GFIconController alloc] init];
    [gfIconController setRefreshTiming:60];
    
    if([GameManager getDevice]==3){//iPad
        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(0, (winSize.height*2)/2+50, 80, 80)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(0, (winSize.height*2)/2-50, 80, 80)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake((winSize.width*2)-80, (winSize.height*2)/2+50, 80, 80)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake((winSize.width*2)-80, (winSize.height*2)/2-50, 80, 80)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }else{
        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(0, winSize.height/2+25, 50, 50)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(0, winSize.height/2-55, 50, 50)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(winSize.width-50, winSize.height/2+25, 50, 50)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];

        iconView = [[GFIconView alloc] initWithFrame:CGRectMake(winSize.width-50, winSize.height/2-55, 50, 50)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }

    //ウォールボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];

    CCButton* moreAppBtn;
    if([GameManager getLocale]==1){//英語
        moreAppBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gfBtn_en.png"]];
    }else{
        moreAppBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gfBtn_jp.png"]];
    }
    moreAppBtn.positionType = CCPositionTypeNormalized;
    moreAppBtn.position = ccp(0.5f, 0.20f);
    moreAppBtn.scale=0.7;
    [moreAppBtn setTarget:self selector:@selector(onMoreAppBtnClicked:)];
    [self addChild:moreAppBtn];

    return self;
}

- (void) dealloc
{
    
}

-(void)onEnter
{
    [super onEnter];
    [gfIconController loadAd:@"8161"];
    [gfIconController visibleIconAd];
    //[gfIconController stopAd];//更新しない
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
    [self hiddenGfIconAd];
}

-(void)hiddenGfIconAd
{
    //[gfIconController stopAd];//エラーになる！
    [gfIconController invisibleIconAd];
}

-(void)onMoreAppBtnClicked:(id)sender
{
    //CCAppDelegate *delegate = (CCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [GFController showGF:[CCDirector sharedDirector] site_id:@"8161" delegate:self];
}

//=======================================================
// GFViewDelegate
//=======================================================
- (void)didShowGameFeat{
    // GameFeatが表示されたタイミングで呼び出されるdelegateメソッド
    //NSLog(@"didShowGameFeat");
}
- (void)didCloseGameFeat{
    // GameFeatが閉じられたタイミングで呼び出されるdelegateメソッド
    //NSLog(@"didCloseGameFeat");
}

@end
