//
//  ArrowObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/18.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ArrowObject.h"


@implementation ArrowObject

CGSize winSize;

-(void)blink_Schedule:(CCTime)dt
{
    if(self.visible){
        self.visible=false;
    }else{
        self.visible=true;
    }
    
    if([self isInSide:_puni.position]){
        [self unschedule:@selector(blink_Schedule:)];
        [self removeFromParentAndCleanup:YES];
    }
}

-(bool)isInSide:(CGPoint)pos
{
    bool flg=true;//枠内
    
    if(pos.y-(self.contentSize.height*self.scale)/2 > winSize.height){//上完全枠外
        flg=false;
    }else if(pos.y+(self.contentSize.height*self.scale)/2 < 0){//下完全枠外
        flg=false;
    }else if(pos.x+(self.contentSize.width*self.scale)/2 < 0){//左完全枠外
        flg=false;
    }else if(pos.x-(self.contentSize.width*self.scale)/2 > winSize.width){//右完全枠外
        flg=false;
    }
    return flg;
}

-(id)initWithArrow:(PuniObject*)puni
{
    _puni=puni;
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];

    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"arrow.png"]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];

        self.scale=0.1;
        
        CGPoint tmpPos=puni.position;
        CGPoint nextPos=CGPointMake(5.0f*cosf(puni.targetAngle),5.0f*sinf(puni.targetAngle));
        
        if(puni.position.x+(self.contentSize.width*self.scale)/2 < 0){//左
            self.rotation=-90;
            while(tmpPos.x<=0){
                tmpPos=ccp(tmpPos.x+nextPos.x,tmpPos.y+nextPos.y);
            }
            self.position=ccp((self.contentSize.height*self.scale)/2,tmpPos.y);
        }else if(puni.position.x-(self.contentSize.width*self.scale)/2 > winSize.width){//右
            self.rotation=90;
            while(tmpPos.x>=winSize.width){
                tmpPos=ccp(tmpPos.x+nextPos.x,tmpPos.y+nextPos.y);
            }
            self.position=ccp(winSize.width-(self.contentSize.height*self.scale)/2,tmpPos.y);
        }else if(puni.position.y-(self.contentSize.height*self.scale)/2 > winSize.height){//上
            self.rotation=0;
            while(tmpPos.y>=winSize.height){
                tmpPos=ccp(tmpPos.x+nextPos.x,tmpPos.y+nextPos.y);
            }
            self.position=ccp(tmpPos.x,winSize.height-(self.contentSize.height*self.scale)/2);
        }else if(puni.position.y+(self.contentSize.height*self.scale)/2 < 0){//下
            self.rotation=180;
            while(tmpPos.y<=0){
                tmpPos=ccp(tmpPos.x+nextPos.x,tmpPos.y+nextPos.y);
            }
            self.position=ccp(tmpPos.x,(self.contentSize.height*self.scale)/2);
        }
    
        [self schedule:@selector(blink_Schedule:)interval:0.3];
    }
    return self;
}

+(id)createArrow:(PuniObject*)puni
{
    return [[self alloc] initWithArrow:puni];
}

@end
