//
//  CircleObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "CircleObject.h"


@implementation CircleObject

CGSize winSize;

-(void)move_Schedule:(CCTime)dt
{
    CGPoint nextPos;
    nextPos=CGPointMake(velocity*cosf(startAngle),velocity*sinf(startAngle));
    self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
}

//========================
// 方向(角度)を取得→(ラジアン)
//========================
+(float)getAngle_To_Radian:(CGPoint)sPos ePos:(CGPoint)ePos{
    
    float angle;
    float dx,dy;//差分距離ベクトル
    dx = ePos.x - sPos.x;
    dy = ePos.y - sPos.y;
    //斜辺角度
    angle=atanf(dy/dx);
    
    if(dx<0 && dy>0){//座標左上
        angle=M_PI+angle;
    }else if(dx<0 && dy<=0){//座標左下
        angle=M_PI+angle;
    }else if(dx>=0 && dy<=0){//座標右下
        angle=M_PI*2+angle;
    }else{//座標右上（修正なし）
    }
    return angle;
}

-(id)initWithCircle
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"circle01.png" ]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];
        
        scale=0.3;
        velocity=0.5;

        self.scale=scale;
        
        //ポジション設定
        int minY = (self.contentSize.height*scale)/2;
        int maxY = winSize.height - (self.contentSize.height*scale)/2;
        int rangeY = maxY - minY;
        int actualY =(arc4random()% rangeY)+ minY;
        
        int minX = winSize.width - winSize.width/3;
        int maxX = winSize.width - (self.contentSize.width*scale)/2;
        int rangeX = maxX - minX;
        int actualX =(arc4random()% rangeX)+ minX;
        
        //寄せ
        if(arc4random()%2==0){
            actualX = winSize.width + (self.contentSize.width*scale)/2;//右
        }else{
            if(arc4random()%2==0){
                actualY = winSize.height + (self.contentSize.height*scale)/2;//上
            }else{
                actualY = -(self.contentSize.height*scale)/2;//下
            }
        }
        
        self.position = ccp(actualX,actualY);

        //方角設定(中心へ)
        actualY =(arc4random()% rangeY)+ minY;
        startAngle = [CircleObject getAngle_To_Radian:self.position ePos:ccp(winSize.width/2,actualY)];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createCircle
{
    return [[self alloc] initWithCircle];
}

@end
