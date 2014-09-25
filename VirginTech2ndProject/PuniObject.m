//
//  CircleObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PuniObject.h"
#import "BasicMath.h"
#import "StageLevel_01.h"
#import "GameManager.h"

@implementation PuniObject

@synthesize velocity;
@synthesize targetAngle;
@synthesize collisNum;
@synthesize objNum;
@synthesize gpNum;
@synthesize manualFlg;
@synthesize posArray;
@synthesize moveCnt;
@synthesize touchFlg;
@synthesize startFlg;
@synthesize blinkFlg;
@synthesize playBackReadyFlg;
@synthesize playBackArray;
@synthesize finger;

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

-(void)move_Schedule:(CCTime)dt
{
    if([GameManager getPause]){
        if([GameManager getPlayBack]){
            if(moveCnt<playBackArray.count){
                CGPoint pt = [[playBackArray objectAtIndex:moveCnt] CGPointValue];
                self.position=CGPointMake(pt.x, pt.y);
                moveCnt++;
            }else{
                playBackReadyFlg=true;
                //playBackArray=[[NSMutableArray alloc]init];
                //moveCnt=0;
            }
        }
    }else{
        if(posArray.count>1 && posArray.count > moveCnt+1){
            
            CGPoint pt1;
            CGPoint pt2;
            
            manualFlg=true;
            if(moveCnt==0 && dr==0){
                NSValue *value = [NSValue valueWithCGPoint:startPos];
                [posArray insertObject:value atIndex:0];
                //pt1 = startPos;
                pt1 = [[posArray objectAtIndex:moveCnt] CGPointValue];
                pt2 = [[posArray objectAtIndex:moveCnt+1] CGPointValue];
            }else{
                pt1 = [[posArray objectAtIndex:moveCnt] CGPointValue];
                pt2 = [[posArray objectAtIndex:moveCnt+1] CGPointValue];
            }
            
            er=sqrtf(powf(pt2.x-pt1.x,2)+powf(pt2.y-pt1.y,2));
            targetAngle=[BasicMath getAngle_To_Radian:pt1 ePos:pt2];

            //デバッグ用メッセージアラート
            if(isnan(targetAngle)){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"マニュアルモード・エラー"
                                            message:[NSString stringWithFormat:
                                            @"Er=%f\n Angle=%f\n pt1.x=%f\n pt2.x=%f\n pt1.y=%f\n pt2.y=%f"
                                            ,er,targetAngle,pt1.x,pt2.x,pt1.y,pt2.y]
                                            delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
                [alert show];
                [self unschedule:@selector(move_Schedule:)];
                //[StageLevel_01 pointPuniCntAdd];
                //[self removeFromParentAndCleanup:YES];
            }else{
                dr=dr+velocity;
                CGPoint inpolPos = CGPointMake(dr*cosf(targetAngle),dr*sinf(targetAngle));
                //pt1から補間分(inpolPos)を加える
                inpolPos.x=pt1.x+inpolPos.x;
                inpolPos.y=pt1.y+inpolPos.y;
                self.position=CGPointMake(inpolPos.x, inpolPos.y);
                
                if(dr>=er){
                    moveCnt++;
                    dr=0;
                }
            }
        }else{
            
            CGPoint nextPos;
            dr=0;
            manualFlg=false;
            targetAngle=[self wallReflectionAngle];
            nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));

            //デバッグ用メッセージアラート
            if(isnan(targetAngle)){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"オートモード・エラー"
                                    message:[NSString stringWithFormat:@"Angle=%f",targetAngle]
                                    delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"OK", nil];
                [alert show];
                [self unschedule:@selector(move_Schedule:)];
            }else{
                self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
            }
            startPos=self.position;
        }
        
        //プレイバック配列
        NSValue *value = [NSValue valueWithCGPoint:self.position];
        [playBackArray insertObject:value atIndex:0];
        if(playBackArray.count==300){
            [playBackArray removeLastObject];
        }
        playBackReadyFlg=false;
    }
    
    label2.string=[NSString stringWithFormat:@"%f",targetAngle];

    /*
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
    */
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

-(id)initWithPuni:(int)objCnt gpNum:(int)_gpNum;
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"puniObj_default.plist"];
    NSString* gpName=[NSString stringWithFormat:@"puni%02d.png",_gpNum];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:gpName]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];
        
        scale=0.25;
        if(![GameManager getSpeed]){//ノーマル
            velocity=0.20;
        }else{//倍速
            velocity=0.20 * 2;
        }
        objNum=objCnt;
        gpNum=_gpNum;
        collisFlg=false;
        collisNum=-1;
        startFlg=true;
        blinkFlg=false;
        manualFlg=false;
        touchFlg=false;
        moveCnt=0;
        playBackReadyFlg=false;
        playBackArray=[[NSMutableArray alloc]init];
        
        self.scale=scale;
        
        //ポジション設定
        int minY = (self.contentSize.height*scale)/2;
        int maxY = winSize.height - (self.contentSize.height*scale)/2;
        int rangeY = maxY - minY;
        int actualY =(arc4random()% rangeY)+ minY;
        
        //int minX = winSize.width - winSize.width/3;
        int minX = (self.contentSize.width*scale)/2;
        int maxX = winSize.width - (self.contentSize.width*scale)/2;
        int rangeX = maxX - minX;
        int actualX =(arc4random()% rangeX)+ minX;
        
        //寄せ 50px外まで
        if(arc4random()%2==0){
            if(arc4random()%2==0){
                actualX = winSize.width + (self.contentSize.width*scale)/2 + 50;//右
            }else{
                actualX = -(self.contentSize.width*scale)/2 - 50;//左
            }
        }else{
            if(arc4random()%2==0){
                actualY = winSize.height + (self.contentSize.height*scale)/2 + 50;//上
            }else{
                actualY = -(self.contentSize.height*scale)/2 - 50;//下
            }
        }
        
        self.position = ccp(actualX,actualY);

        //方角設定
        actualY =(arc4random()% rangeY)+ minY;
        targetAngle = [BasicMath getAngle_To_Radian:self.position ePos:ccp(winSize.width/2,actualY)];
        
        //チュートリアル用フィンガー
        if([GameManager getStageNum]==0){//初回のみ
            finger=[FingerObject createFinger:true];
            finger.position=ccp(self.contentSize.width/2+(finger.contentSize.width*finger.scale)/2,
                                self.contentSize.height/2+(finger.contentSize.height*finger.scale)/2);
            finger.visible=false;
            [self addChild:finger];
        }
        
        //デバッグ用ラベル
        label=[CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d",objNum]fontName:@"Verdana-Bold" fontSize:35];
        label.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        label.color=[CCColor blackColor];
        [self addChild:label];
        
        label2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",targetAngle] fontName:@"Verdana-Bold" fontSize:35];
        label2.position=ccp(self.contentSize.width/2,self.contentSize.height/2-100);
        label2.color=[CCColor whiteColor];
        [self addChild:label2];
        

        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createPuni:(int)objCnt gpNum:(int)_gpNum
{
    return [[self alloc] initWithPuni:objCnt gpNum:_gpNum];
}

@end
