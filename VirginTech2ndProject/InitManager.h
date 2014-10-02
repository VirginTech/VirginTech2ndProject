//
//  InitManager.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InitManager : NSObject

+(void)generate_Stage:(int)stageLevel;

+(float)getInterval;
+(int)getPuniOnceMax;
+(int)getPuniRepeatMax;
+(NSMutableArray*)getGpNumArray;

+(NSMutableArray*)getPattern:(int)pieces size:(float)size;
+(NSMutableArray*)getRotation:(int)pieces;

@end
