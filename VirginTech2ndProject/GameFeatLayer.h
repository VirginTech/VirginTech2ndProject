//
//  GameFeatLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/16.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import <GameFeatKit/GFView.h>
#import <GameFeatKit/GFController.h>
#import <GameFeatKit/GFIconController.h>
#import <GameFeatKit/GFIconView.h>

@interface GameFeatLayer : CCScene <GFViewDelegate>
{    
    GFIconController *gfIconController;
}

+ (GameFeatLayer *)scene;
- (id)init;

-(void)hiddenGfIconAd;

@end
