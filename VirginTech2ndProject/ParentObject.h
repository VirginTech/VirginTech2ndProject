//
//  ParentObject.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/04.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParentObject : CCSprite {
    
    int collisNum;
    int objNum;
    
    CCLabelTTF* label;
    CCLabelTTF* label2;
}

@property int collisNum;
@property int objNum;

+(id)createParent:(int)objCnt;

@end
