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
#import "PuniObject.h"
#import "SoundManager.h"

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
    
    //オープニングBGM
    [SoundManager playBGM];
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];
    
    //背景
    [self setBackGround];
    
    //プレイバック回数セット
    [GameManager setPlayBackCount:5];
    
    //インフォレイヤー
    [GameManager setScore:0];
    [GameManager setStageNum:99999];//プニを回転させるため
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer z:1];
    
    //ADG-SSPバナー
    AdGenerLayer* adgSSP=[[AdGenerLayer alloc]init];
    [self addChild:adgSSP];
    
    //GameFeat広告
    gfAd=[[GameFeatLayer alloc]init];
    [self addChild:gfAd];
    
    /*/ Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"ぷにぷにパニック！" fontName:@"Verdana-Bold" fontSize:40.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];*/
    
    //タイトルロゴ
    CCSprite* titleLogo;
    if([GameManager getLocale]==1){
        titleLogo=[CCSprite spriteWithImageNamed:@"titlelogo_en.png"];
    }else{
        titleLogo=[CCSprite spriteWithImageNamed:@"titlelogo_jp.png"];
    }
    titleLogo.scale=0.4;
    titleLogo.position=ccp(winSize.width/2+20,winSize.height/2+50);
    [self addChild:titleLogo z:1];
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    
    //プレイ・ボタン
    CCButton *startButton;
    if([GameManager getLocale]==1){//英語
        startButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play_en.png"]];
    }else{
        startButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play_jp.png"]];
    }
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.425f, 0.35f);
    startButton.scale=0.5;
    startButton.rotation=-35;
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton z:2];

    //コンティニュー・ボタン
    CCButton *continueButton;
    if([GameManager getLocale]==1){//英語
        continueButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue_en.png"]];
    }else{
        continueButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue_jp.png"]];
    }
    continueButton.positionType = CCPositionTypeNormalized;
    continueButton.position = ccp(0.575f, 0.35f);
    continueButton.scale=0.5;
    continueButton.rotation=-35;
    [continueButton setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueButton z:2];
    
    // GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.97f, 0.10f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.97f, 0.20f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.97f, 0.30f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];

    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.03f, 0.10f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.03f, 0.20f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.03f, 0.30f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    //おすすめボタン
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
    
    //バージョン
    CCLabelTTF* versionLabel=[CCLabelTTF labelWithString:@"Version 1.0.0" fontName:@"Verdana-Bold" fontSize:13];
    versionLabel.position=ccp(winSize.width-versionLabel.contentSize.width/2,winSize.height-40);
    versionLabel.color=[CCColor whiteColor];
    [self addChild:versionLabel];
    
    //プニ登場
    [GameManager setPause:false];
     PuniObject* puni=[PuniObject createPuni:0 gpNum:(arc4random()%5)+1];
    [self addChild:puni z:3];
    
    /*/初回ログインボーナス
    //NSDate* currentDate= [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    if([dict valueForKey:@"LoginDate"]==nil){//初回なら
        [GameManager save_login_Date:currentDate];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=1;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"BonusGet",NULL);
        alert.message = NSLocalizedString(@"FirstBonus",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"OK",NULL)];
        [alert show];
    }
    
    //デイリー・ボーナス
    NSDate* recentDate=[GameManager load_Login_Date];
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    currentDate = [calen dateFromComponents:comps];
    
    if([currentDate compare:recentDate]==NSOrderedDescending){//日付が変わってるなら「1」
        [GameManager save_login_Date:currentDate];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=2;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"BonusGet",NULL);
        alert.message = NSLocalizedString(@"DailyBonus",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"OK",NULL)];
        [alert show];
    }*/
    
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
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+2,
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
    //効果音
    [SoundManager buttonClickEffect];
    
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
    //効果音
    [SoundManager buttonClickEffect];
    
    if([GameManager load_Clear_Level]>0){
        if([GameManager load_Ticket_Count]>0){
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.tag=0;
            alert.delegate = self;
            alert.title = NSLocalizedString(@"Continue",NULL);
            alert.message = NSLocalizedString(@"Ticket_Use",NULL);
            
            [alert addButtonWithTitle:NSLocalizedString(@"No",NULL)];
            [alert addButtonWithTitle:NSLocalizedString(@"Yes",NULL)];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Continue",NULL)
                                                            message:NSLocalizedString(@"Ticket_Shortage",NULL)
                                                            delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:NSLocalizedString(@"OK",NULL),
                                                            nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Continue",NULL)
                                                            message:NSLocalizedString(@"NotContinue",NULL)
                                                            delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:NSLocalizedString(@"OK",NULL),
                                                            nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0){
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
    }/*else if(alertView.tag==1){
        
        //チケット付与
        [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+10];
        [InfoLayer update_Ticket];
        
    }else if(alertView.tag==2){
        
        //チケット付与
        [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+ 1];
        [InfoLayer update_Ticket];
        
    }*/
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
    //効果音
    [SoundManager buttonClickEffect];
    
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
    //効果音
    [SoundManager buttonClickEffect];
    
    [[CCDirector sharedDirector] replaceScene:[PreferencesLayer scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onCreditButtonClicked:(id)sender
{
    //効果音
    [SoundManager buttonClickEffect];
    
    [[CCDirector sharedDirector] replaceScene:[CreditLayer scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onMoreAppBtnClicked:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/jp/artist/virgintech-llc./id869207880"];
    [[UIApplication sharedApplication]openURL:url];
}

@end
