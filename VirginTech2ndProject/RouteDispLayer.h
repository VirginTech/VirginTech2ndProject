//
//  RouteDispLayer.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/08.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PuniObject.h"

@interface RouteDispLayer : CCScene {
    
    PuniObject* puni;
}

@property PuniObject* puni;

+ (RouteDispLayer *)scene;
- (id)init;

@end
