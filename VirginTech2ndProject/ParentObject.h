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
    
    bool collisFlg;
}

@property bool collisFlg;

+(id)createParent;

@end
