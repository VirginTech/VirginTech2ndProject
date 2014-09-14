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

+(int)getStageNum
{
    return stageNum;
}
+(void)setStageNum:(int)num
{
    stageNum=num;
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

+(void)initialize_Clear_Level
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"ClearLevel"]==nil){
        [GameManager save_Clear_Level:-1];
    }
    
}

@end
