//
//  ArrowObject.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/18.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PuniObject.h"

@interface ArrowObject : CCSprite {

    PuniObject* _puni;
}

+(id)createArrow:(PuniObject*)puni;

@end
