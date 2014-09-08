//
//  CircleObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PuniObject.h"
#import "BasicMath.h"

@implementation PuniObject

@synthesize targetAngle;
@synthesize collisNum;
@synthesize objNum;
@synthesize manualFlg;
@synthesize posArray;
@synthesize moveCnt;
@synthesize routeChangeFlg;

CGSize winSize;

-(void)move_Schedule:(CCTime)dt
{
    CGPoint nextPos;
    CGPoint pt1;
    CGPoint pt2;

    targetAngle=[self wallReflectionAngle];
    label2.string=[NSString stringWithFormat:@"%f",targetAngle];
    nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
    
    if(manualFlg){
        if(posArray.count>1){
            if(moveCnt==0){
                pt1 = startPos;
                pt2 = [[posArray objectAtIndex:moveCnt] CGPointValue];
            }else{
                pt1 = [[posArray objectAtIndex:moveCnt-1] CGPointValue];
                pt2 = [[posArray objectAtIndex:moveCnt] CGPointValue];
            }
            er=sqrtf(powf(pt2.x-pt1.x,2)+powf(pt2.y-pt1.y,2));
            targetAngle=[BasicMath getAngle_To_Radian:pt1 ePos:pt2];
            nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
            
            dr=dr+velocity;
            if((int)dr>=(int)er){//丸め誤差をあえて無視！（経路ズレるから）
                moveCnt++;
                dr=0;
            }
            if(posArray.count < moveCnt+1){
                manualFlg=false;
            }
        }else{
            startPos=self.position;
        }
    }
    self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
}

-(float)wallReflectionAngle
{
    float angle=targetAngle;
    
    if(self.position.y+(self.contentSize.height*scale)/2 >= winSize.height){//上限界
        if(!startFlg){
            if(collisFlg){
                self.position=ccp(self.position.x, self.position.y-3);
            }
            angle = 2*M_PI-targetAngle;
            collisFlg=true;
            //label.string=@"上";
        }
    }else if(self.position.y-(self.contentSize.height*scale)/2 <= 0){//下限界
        if(!startFlg){
            if(collisFlg){
                self.position=ccp(self.position.x, self.position.y+3);
            }
            angle = 2*M_PI-targetAngle;
            collisFlg=true;
            //label.string=@"下";
        }
    }else if(self.position.x-(self.contentSize.width*scale)/2 <= 0){//左限界
        if(!startFlg){
            if(collisFlg){
                self.position=ccp(self.position.x+3, self.position.y);
            }
            angle = 2*M_PI_2-targetAngle;
            collisFlg=true;
            //label.string=@"左";
        }
    }else if(self.position.x+(self.contentSize.width*scale)/2 >= winSize.width){//右限界
        if(!startFlg){
            if(collisFlg){
                self.position=ccp(self.position.x-3, self.position.y);
            }
            angle = 2*M_PI_2-targetAngle;
            collisFlg=true;
            //label.string=@"右";
        }
    }else{
        collisFlg=false;
        startFlg=false;
    }
    return angle;
}

-(id)initWithPuni:(int)objCnt
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"circle01.png" ]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];
        
        scale=0.3;
        velocity=0.5;

        objNum=objCnt;
        collisFlg=false;
        collisNum=-1;
        startFlg=true;
        manualFlg=false;
        routeChangeFlg=false;
        moveCnt=0;
        
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

        //方角設定
        actualY =(arc4random()% rangeY)+ minY;
        targetAngle = [BasicMath getAngle_To_Radian:self.position ePos:ccp(winSize.width/2,actualY)];
        
        //デバッグ用ラベル
        label=[CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d",objNum]fontName:@"Verdana-Bold" fontSize:35];
        label.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        label.color=[CCColor blackColor];
        [self addChild:label];

        label2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",targetAngle] fontName:@"Verdana-Bold" fontSize:25];
        label2.position=ccp(self.contentSize.width/2,self.contentSize.height/2-100);
        label2.color=[CCColor whiteColor];
        [self addChild:label2];

        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createPuni:(int)objCnt;
{
    return [[self alloc] initWithPuni:objCnt];
}

@end
