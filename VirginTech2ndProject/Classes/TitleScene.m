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

@implementation TitleScene

CGSize winSize;

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
    
    //インフォレイヤー
    [GameManager setScore:0];
    [GameManager setStageNum:[GameManager load_Clear_Level]];
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"ぷにぷにパニック！" fontName:@"Verdana-Bold" fontSize:40.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];
    
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
            break;
    }
}

@end
