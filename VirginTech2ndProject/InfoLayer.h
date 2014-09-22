//
//  InfoLayer.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InfoLayer : CCScene {
    
}

+ (InfoLayer *)scene;
- (id)init;

+(void)update_Score;
+(void)update_Ticket;
+(void)update_PlayBack;

@end
