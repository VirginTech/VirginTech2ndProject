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
    bool startFlg;
    CCLabelTTF* label;
    CCLabelTTF* label2;
    bool manualFlg;
    bool routeChangeFlg;
    NSMutableArray* posArray;
    float er,dr;//最終距離、補間距離(途中経過の)
    CGPoint startPos;
    int moveCnt;
}

@property float targetAngle;
@property int collisNum;
@property int objNum;
@property bool manualFlg;
@property NSMutableArray* posArray;
@property int moveCnt;
@property bool routeChangeFlg;

+(id)createPuni:(int)objCnt;

@end
