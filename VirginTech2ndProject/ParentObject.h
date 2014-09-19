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
    
    int objNum;//自分の番号
    int gpNum;//グループ番号
    bool blinkFlg;
    
    CCLabelTTF* label;
    //CCLabelTTF* label2;
}

@property int objNum;
@property int gpNum;
@property bool blinkFlg;

+(id)createParent:(int)objCnt gpNum:(int)gpNum;
-(void)startBlink;

@end
