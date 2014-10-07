//
//  ParentObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/04.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ParentObject.h"
#import "InitManager.h"
#import "CCAnimation.h"

@implementation ParentObject

//@synthesize collisNum;
@synthesize objNum;
@synthesize gpNum;
@synthesize blinkFlg;

CGSize winSize;

-(void)startBlink
{
    blinkFlg=true;
    [self schedule:@selector(blink_Schedule:) interval:0.25];
}

-(void)blink_Schedule:(CCTime)dt
{
    if(blinkFlg){
        if([self visible]){
            [self setVisible:NO];
        }else{
            [self setVisible:YES];
        }
    }else{
        [self setVisible:YES];
        [self unschedule:@selector(blink_Schedule:)];
    }
}

-(id)initWithParent:(int)objCnt gpNum:(int)_gpNum;
{
    CGPoint centerPos;
    NSMutableArray* gpPatternArray=[[NSMutableArray alloc]init];
    NSMutableArray* gpRotationArray=[[NSMutableArray alloc]init];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
                            [NSString stringWithFormat:@"puni%02d_default.plist",_gpNum]];
    
    //NSString* gpName=[NSString stringWithFormat:@"puni%02d.png",_gpNum];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"01.png"]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];

        self.scale=0.4;
        
        //ポジション設定
        centerPos=ccp(winSize.width/2,winSize.height/2);
        gpPatternArray=[InitManager getPattern:
                        (int)[InitManager getGpNumArray].count size:self.contentSize.width*self.scale];
        self.position=ccp(centerPos.x+[[gpPatternArray objectAtIndex:objCnt]CGPointValue].x,
                          centerPos.y+[[gpPatternArray objectAtIndex:objCnt]CGPointValue].y);
        //ローティション設定
        gpRotationArray=[InitManager getRotation:(int)[InitManager getGpNumArray].count];
        self.rotation=[[gpRotationArray objectAtIndex:objCnt]floatValue];
        
        objNum=objCnt;
        gpNum=_gpNum;
        blinkFlg=false;
        
        /*/デバッグ用ライン
        CCDrawNode* drawNode1=[CCDrawNode node];
        [drawNode1 drawSegmentFrom:ccp(self.contentSize.width/2-800,self.contentSize.height/2)
                               to:ccp(self.contentSize.width/2+800,self.contentSize.height/2)
                           radius:1.0
                            color:[CCColor whiteColor]];
        [self addChild:drawNode1];

        CCDrawNode* drawNode2=[CCDrawNode node];
        [drawNode2 drawSegmentFrom:ccp(self.contentSize.width/2,self.contentSize.height/2-800)
                               to:ccp(self.contentSize.width/2,self.contentSize.height/2+800)
                           radius:1.0
                            color:[CCColor whiteColor]];
        [self addChild:drawNode2];*/

        //self.rotation=45;
        
        /*/デバッグ用ラベル
        label=[CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d",gpNum]fontName:@"Verdana-Bold" fontSize:55];
        label.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        label.color=[CCColor blackColor];
        [self addChild:label];
        
        label2=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"%d",collisNum] fontName:@"Verdana-Bold" fontSize:35];
        label2.position=ccp(self.contentSize.width/2,self.contentSize.height/2-100);
        label2.color=[CCColor whiteColor];
        [self addChild:label2];
        
        [self schedule:@selector(test_Schedule:)interval:0.01];
        */
        
        //アニメーション
        animeCnt=0;
        frame=[[NSMutableArray alloc]init];
        for(int i=1; i<=10; i++){
            CCSpriteFrame *spr = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                    spriteFrameByName:[NSString stringWithFormat:@"%02d.png",i]];
            [frame addObject:spr];
        }
        /*CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frame delay:0.1];
        CCActionAnimate *AnimAction  = [CCActionAnimate actionWithAnimation:animation];
        CCActionRepeatForever *repAction = [CCActionRepeatForever actionWithAction:AnimAction];
        [self runAction:repAction];*/
        
        [self schedule:@selector(animation_Schedule:)interval:0.1];
    }
    return self;
}

-(void)puni_Hit_Action
{
    self.scale=0.5;
    [self schedule:@selector(puni_Hit_Schedule:) interval:0.01];
}

-(void)puni_Hit_Schedule:(CCTime)dt
{
    self.scale-=0.005;
    if(self.scale<=0.40){
        [self unschedule:@selector(puni_Hit_Schedule:)];
    }
}

-(void)animation_Schedule:(CCTime)dt
{
    [self setSpriteFrame:[frame objectAtIndex:animeCnt]];
    
    animeCnt++;
    if(animeCnt>=10){
        animeCnt=0;
    }
    //label2.string=[NSString stringWithFormat:@"%d",collisNum];
}

+(id)createParent:(int)objCnt gpNum:(int)_gpNum
{
    return [[self alloc] initWithParent:objCnt gpNum:_gpNum];
}

@end
