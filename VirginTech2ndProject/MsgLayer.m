//
//  MsgLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MsgLayer.h"
#import "GameManager.h"
#import "StageLevel_01.h"

@implementation MsgLayer

CGSize winSize;
//CCLabelTTF* msg;
CCLabelBMFont* msg;
int cnt;
bool nextFlg;

+(MsgLayer *)scene{
    
    return [[self alloc] init];
}

-(id)initWithMsg:(NSString*)str nextFlg:(bool)flg{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    cnt=0;
    nextFlg=flg;
    //msg=[CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:60];
    msg=[CCLabelBMFont labelWithString:str fntFile:@"msg.fnt"];
    msg.position=ccp(winSize.width/2,winSize.height/2 + 50);
    //msg.color=[CCColor redColor];
    msg.opacity=0.0f;
    [self addChild:msg];
    
    [self schedule:@selector(show_Message_Schedule:)interval:0.1];
    
    return self;
}

-(void)show_Message_Schedule:(CCTime)dt
{
    if(cnt<=19){
        msg.opacity+=0.05f;
    }else{
        msg.opacity-=0.05f;
    }
    cnt++;
    
    if(cnt>=38){
        if(nextFlg){
            [self unschedule:@selector(show_Message_Schedule:)];
            //次ステージへ
            [GameManager setStageNum:[GameManager getStageNum]+1];//ステージレヴェル設定
            [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
            [self removeFromParentAndCleanup:YES];
        }else{
            [self unschedule:@selector(show_Message_Schedule:)];
            [self removeFromParentAndCleanup:YES];
        }
    }
}

@end
