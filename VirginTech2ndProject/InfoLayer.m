//
//  InfoLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "InfoLayer.h"
#import "GameManager.h"

@implementation InfoLayer

CGSize winSize;

int stageLevel;
CCLabelBMFont* scoreLabel;
CCLabelBMFont* ticketLabel;

+ (InfoLayer *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector]viewSize];
    
    //ステージレヴェル取得
    if([GameManager getStageNum]<0){//初回タイトル画面
        stageLevel=0;
    }else{
        stageLevel=[GameManager getStageNum];
    }
    //ステージレベルラベル
    //NSLog(@"Stage=%d",stageLevel);
    CCLabelBMFont* stageLabel=[CCLabelBMFont labelWithString:
                                        [NSString stringWithFormat:@"Lv.%03d",stageLevel]
                                        fntFile:@"scoreFont.fnt"];
    stageLabel.position=ccp(stageLabel.contentSize.width/2, winSize.height-stageLabel.contentSize.height/2);
    [self addChild:stageLabel];
    
    //ハイスコア
    CCLabelBMFont* highScoreLabel=[CCLabelBMFont labelWithString:
                                        [NSString stringWithFormat:@"HighScore:%05ld",[GameManager load_HighScore]]
                                        fntFile:@"scoreFont.fnt"];
    highScoreLabel.position=ccp(winSize.width-highScoreLabel.contentSize.width/2,
                                winSize.height-highScoreLabel.contentSize.height/2);
    [self addChild:highScoreLabel];

    //スコア
    scoreLabel=[CCLabelBMFont labelWithString:
                                        [NSString stringWithFormat:@"Score:%05ld",[GameManager getScore]]
                                        fntFile:@"scoreFont.fnt"];
    scoreLabel.position=ccp(winSize.width/2-scoreLabel.contentSize.width/2,winSize.height-scoreLabel.contentSize.height/2);
    [self addChild:scoreLabel];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc_default.plist"];
    
    //コンティニュー・チケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.15;
    ticket.position=ccp(10,stageLabel.position.y-stageLabel.contentSize.height/2-10);
    [self addChild:ticket];
    
    ticketLabel=[CCLabelBMFont labelWithString:
                                        [NSString stringWithFormat:@"x %02d",[GameManager load_Ticket_Count]]
                                        fntFile:@"scoreFont.fnt"];
    //ticketLabel.color=[CCColor blackColor];
    ticketLabel.position=ccp(ticket.position.x+ticketLabel.contentSize.width/2+5,ticket.position.y-5);
    [self addChild:ticketLabel];

    //プレイバックの星表示
    
    
    return self;
}

+(void)update_Ticket
{
    ticketLabel.string=[NSString stringWithFormat:@"x %02d",[GameManager load_Ticket_Count]];
}

+(void)update_Score
{
    //NSLog(@"score=%ld",[GameManager getScore]);
    scoreLabel.string=[NSString stringWithFormat:@"Score:%05ld",[GameManager getScore]];
}

@end
