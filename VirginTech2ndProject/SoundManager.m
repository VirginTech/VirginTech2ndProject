//
//  SoundManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/10/08.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

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
    [[OALSimpleAudio sharedInstance]preloadEffect:@"puni.mp3"];
    
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
    int num=arc4random()%5+1;
    NSString* name=[NSString stringWithFormat:@"bgm%02d.mp3",num];
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmMaxVolume*bgmValue];
    [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
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
// プニ衝突音
//===================
+(void)puniCollisionEffect
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:puniCollisionVolume*effectValue];
    [[OALSimpleAudio sharedInstance]playEffect:@"puni.mp3"];
}

@end
