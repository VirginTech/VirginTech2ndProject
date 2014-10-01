//
//  IntroScene.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/01.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "TitleScene.h"
#import "StageLevel_01.h"
#import "GameManager.h"
#import "InfoLayer.h"
#import "CreditLayer.h"
#import "ShopView.h"
#import "PreferencesLayer.h"
#import "AdGenerLayer.h"
#import "GameFeatLayer.h"

@implementation TitleScene

CGSize winSize;

GameFeatLayer* gfAd;

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector]viewSize];
    
    //初回データ初期値設定
    [GameManager initialize_Clear_Level];
    [GameManager initialize_Ticket_Count];
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];
    
    //背景
    [self setBackGround];
    
    //プレイバック回数セット
    [GameManager setPlayBackCount:5];
    
    //インフォレイヤー
    [GameManager setScore:0];
    [GameManager setStageNum:[GameManager load_Clear_Level]];
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer];
    
    //ADG-SSPバナー
    AdGenerLayer* adgSSP=[[AdGenerLayer alloc]init];
    [self addChild:adgSSP];
    
    //GameFeat広告
    gfAd=[[GameFeatLayer alloc]init];
    [self addChild:gfAd];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"ぷにぷにパニック！" fontName:@"Verdana-Bold" fontSize:40.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    
    //プレイ・ボタン
    CCButton *startButton = [CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:20.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.5f, 0.40f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];

    //コンティニュー・ボタン
    CCButton *continueButton = [CCButton buttonWithTitle:@"[コンティニュー]" fontName:@"Verdana-Bold" fontSize:20.0f];
    continueButton.positionType = CCPositionTypeNormalized;
    continueButton.position = ccp(0.5f, 0.30f);
    [continueButton setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueButton];
    
    // GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.95f, 0.15f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.95f, 0.25f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.35f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];

    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.05f, 0.15f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.05f, 0.25f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.05f, 0.35f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    //バージョン
    CCLabelTTF* versionLabel=[CCLabelTTF labelWithString:@"Version 1.0.0" fontName:@"Verdana" fontSize:13];
    versionLabel.position=ccp(versionLabel.contentSize.width/2+5,versionLabel.contentSize.height/2+5);
    versionLabel.color=[CCColor whiteColor];
    [self addChild:versionLabel];
    
    // done
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

- (void)onStartClicked:(id)sender
{
    //ステージレヴェル設定
    if([GameManager load_Clear_Level]>=0){
        [GameManager setStageNum:1];
    }else{
        [GameManager setStageNum:0];
    }
    //スコア設定
    [GameManager setScore:0];
    
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //プレイバック回数セット
    //[GameManager setPlayBackCount:5];
}

- (void)onContinueClicked:(id)sender
{
    if([GameManager load_Ticket_Count]>0){
        UIAlertView *alert = [[UIAlertView alloc] init];
        //alert.tag=type;
        alert.delegate = self;
        alert.title = @"コンティニュー";
        alert.message = @"チケット１枚を消費します。よろしいですか？";
        
        [alert addButtonWithTitle:@"いいえ"];
        [alert addButtonWithTitle:@"は　い"];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"コンティニュー"
                                                        message:@"チケットが足りません。"
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"は　い", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex){
        case 0:
            break;
        case 1:
            //ステージレヴェル設定
            [GameManager setStageNum:[GameManager load_Clear_Level]+1];
            //スコア設定
            [GameManager setScore:[GameManager load_HighScore]];
            
            [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
                                                withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
            //チケットセット
            [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]-1];
            [InfoLayer update_Ticket];
            
            //プレイバック回数セット
            //[GameManager setPlayBackCount:5];

            break;
    }
}

-(void)onGameCenterClicked:(id)sender
{
    lbv=[[LeaderboardView alloc]init];
    [lbv showLeaderboard];
}

-(void)onTwitterClicked:(id)sender
{
    //[SoundManager button_Click];
    NSURL* url = [NSURL URLWithString:@"https://twitter.com/VirginTechLLC"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onFacebookClicked:(id)sender
{
    //[SoundManager button_Click];
    NSURL* url = [NSURL URLWithString:@"https://www.facebook.com/pages/VirginTech-LLC/516907375075432"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onInAppPurchaseClicked:(id)sender
{
    //アプリ内購入の設定チェック
    if (![SKPaymentQueue canMakePayments]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"InAppBillingIslimited",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
        [alert show];
        return;
        
    }else{
        //ショップ画面へ
        [[CCDirector sharedDirector] replaceScene:
                        [ShopView scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
        
    }
}

-(void)onPreferencesButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[PreferencesLayer scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onCreditButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CreditLayer scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [gfAd hiddenGfIconAd];
}

@end
