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
    int gpNum;
    
    //CCLabelTTF* label;
    //CCLabelTTF* label2;
}

@property int collisNum;
@property int objNum;
@property int gpNum;

+(id)createParent:(int)objCnt gpNum:(int)gpNum;

@end
