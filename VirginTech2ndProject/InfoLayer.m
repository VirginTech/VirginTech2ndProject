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
CCLabelTTF* scoreLabel;

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
    CCLabelTTF* stageLabel=[CCLabelTTF labelWithString:
                            [NSString stringWithFormat:@"Lv.%02d/Lv.50",stageLevel]
                                              fontName:@"Verdana-Bold"
                                              fontSize:15.0f];
    stageLabel.position=ccp(stageLabel.contentSize.width/2, winSize.height-stageLabel.contentSize.height/2);
    [self addChild:stageLabel];
    
    //ハイスコア
    CCLabelTTF* highScoreLabel=[CCLabelTTF labelWithString:
                                [NSString stringWithFormat:@"HighScore:%05ld",[GameManager load_HighScore]]
                                fontName:@"Verdana-Bold"
                                fontSize:15.0f];
    highScoreLabel.position=ccp(winSize.width-highScoreLabel.contentSize.width/2,
                                winSize.height-highScoreLabel.contentSize.height/2);
    [self addChild:highScoreLabel];

    //スコア
    scoreLabel=[CCLabelTTF labelWithString:
                                [NSString stringWithFormat:@"Score:%05ld",[GameManager getScore]]
                                                  fontName:@"Verdana-Bold"
                                                  fontSize:15.0f];
    scoreLabel.position=ccp(winSize.width/2,winSize.height-scoreLabel.contentSize.height/2);
    [self addChild:scoreLabel];
    
    return self;
}

+(void)update_Score
{
    NSLog(@"score=%ld",[GameManager getScore]);
    scoreLabel.string=[NSString stringWithFormat:@"Score:%05ld",[GameManager getScore]];
}

@end