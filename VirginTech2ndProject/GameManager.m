//
//  GameManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int stageNum;
long score;
bool speed2xFlg=false;

+(int)getStageNum
{
    return stageNum;
}
+(void)setStageNum:(int)num
{
    stageNum=num;
}

+(long)getScore
{
    return score;
}
+(void)setScore:(long)num
{
    score=num;
}

+(bool)getSpeed
{
    return speed2xFlg;
}
+(void)setSpeed:(bool)flg
{
    speed2xFlg=flg;
}

//=========================================
//　ハイスコアの取得
//=========================================
+(long)load_HighScore
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    long highScore=[[userDefault objectForKey:@"HighScore"]longValue];
    return highScore;
}
//=========================================
//　ハイスコアの保存
//=========================================
+(void)save_HighScore:(long)score
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* scoreNum=[NSNumber numberWithLong:score];
    [userDefault setObject:scoreNum forKey:@"HighScore"];
}

//=========================================
//　クリアレヴェルの取得
//=========================================
+(int)load_Clear_Level
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int level=[[userDefault objectForKey:@"ClearLevel"]intValue];
    return level;
}
//=========================================
//　クリアレヴェルの保存
//=========================================
+(void)save_Clear_Level:(int)num
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* level=[NSNumber numberWithInt:num];
    [userDefault setObject:level forKey:@"ClearLevel"];
}
//=========================================
//　初回起動時のクリアレヴェルの設定（-1）
//=========================================
+(void)initialize_Clear_Level
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"ClearLevel"]==nil){
        [GameManager save_Clear_Level:-1];
    }
    
}

@end
