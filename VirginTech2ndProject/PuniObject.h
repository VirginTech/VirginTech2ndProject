//
//  CircleObject.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PuniObject : CCSprite
{
    float scale;
    float velocity;
    float targetAngle;
    bool collisFlg;
    int collisNum;;
    int objNum;
    int gpNum;
    
    bool startFlg;
    bool endFlg;
    //CCLabelTTF* label;
    //CCLabelTTF* label2;
    bool manualFlg;
    bool touchFlg;
    NSMutableArray* posArray;
    float er,dr;//最終距離、補間距離(途中経過の)
    CGPoint startPos;
    int moveCnt;
}

@property float targetAngle;
@property int collisNum;
@property int objNum;
@property int gpNum;
@property bool manualFlg;
@property NSMutableArray* posArray;
@property int moveCnt;
@property bool touchFlg;
@property bool startFlg;
@property bool endFlg;

+(id)createPuni:(int)objCnt gpNum:(int)gpNum;

@end
