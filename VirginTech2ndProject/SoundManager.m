//
//  SoundManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/10/08.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

int bgmNum;
float bgmValue;
float bgmMaxVolume;

float effectValue;
float puniCollisionVolume;

//===================
//BGM・効果音プリロード
//===================
+(void)initSoundPreload
{
    //BGM
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm02.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm03.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm04.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm05.mp3"];
    
    //エフェクト
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni_Hit.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni_Lock.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni_Failed.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni_Collision.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni_Touch.mp3"];
    
    //ボタン
    [[OALSimpleAudio sharedInstance]preloadEffect:@"@button_Click.mp3"];
    
    //BGM初期値
    //bgmNum=arc4random()%5+1;
    bgmNum=0;
    
    //BGM音量初期値セット
    bgmValue=0.5;
    //BGM音量最大値セット
    bgmMaxVolume=0.3;
    
    //エフェクト音量初期値セット
    effectValue=0.5;
    //各種エフェクト最大値
    puniCollisionVolume=1.0;
}

//===================
// BGM
//===================
+(void)playBGM
{
    bgmNum++;
    if(bgmNum>5)bgmNum=1;
    
    NSString* name=[NSString stringWithFormat:@"bgm%02d.mp3",bgmNum];
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmMaxVolume*bgmValue];
    [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
+(void)pauseBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:YES];
}
+(void)resumeBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:NO];
}

//===================
// BGM音量セット
//===================
+(void)setBgmVolume:(float)value
{
    bgmValue=value;
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmMaxVolume*bgmValue];
}
+(float)getBgmVolume
{
    return bgmValue;
}

//===================
// エフェクト音量セット
//===================
+(void)setEffectVolume:(float)value
{
    effectValue=value;
}

//===================
// エフェクト音量セット
//===================
+(float)getEffectVolume
{
    return effectValue;
}

//===================
// プニ
//===================
+(void)puniCollisionEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni_Collision.mp3"];
}
+(void)puniHitEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni_Hit.mp3"];
}
+(void)puniFailedEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni_Failed.mp3"];
}
+(void)puniLockEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni_Lock.mp3"];
}
+(void)puniTouchEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni_Touch.mp3"];
}

//===================
// UI
//===================
+(void)buttonClickEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"button_Click.mp3"];
}


@end
