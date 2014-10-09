//
//  SoundManager.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/10/08.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject

+(void)initSoundPreload;

+(void)playBGM;
+(void)stopBGM;
+(void)pauseBGM;
+(void)resumeBGM;

+(void)setBgmVolume:(float)value;
+(float)getBgmVolume;

+(void)setEffectVolume:(float)value;
+(float)getEffectVolume;

+(void)puniCollisionEffect;
+(void)puniHitEffect;
+(void)puniFailedEffect;
+(void)puniLockEffect;
+(void)puniTouchEffect;

+(void)buttonClickEffect;

@end
