//
//  NaviLayer.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface NaviLayer : CCScene
{
    CCButton *titleButton;
    CCButton *playbackButton;
}

@property CCButton *titleButton;
@property CCButton *playbackButton;

+ (NaviLayer *)scene;
- (id)init;

@end
