//
//  CircleObject.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CircleObject : CCSprite
{
    float scale;
    float velocity;
    float startAngle;
}

+(id)createCircle;

@end
