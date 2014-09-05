//
//  HelloWorldScene.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/01.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "PuniObject.h"
#import "ParentObject.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface StageLevel_01 : CCScene
{
    PuniObject* puni;
    ParentObject* parent;
}
// -----------------------------------------------------------------------

+ (StageLevel_01 *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end