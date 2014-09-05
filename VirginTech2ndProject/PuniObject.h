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
    bool collisFlg2;
    bool startFlg;
    CCLabelTTF* label;
    CCLabelTTF* label2;
}

@property float targetAngle;
@property bool collisFlg2;

+(id)createPuni;

@end
