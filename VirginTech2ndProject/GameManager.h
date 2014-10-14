//
//  GameManager.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(int)getLocale;
+(void)setLocale:(int)value;//1:英語 2:日本語
+(float)getOsVersion;
+(void)setOsVersion:(float)version;
+(int)getDevice;
+(void)setDevice:(int)type;// 1:iPhone5 2:iPhone4 3:iPad2

+(int)getStageNum;
+(void)setStageNum:(int)num;
+(long)getScore;
+(void)setScore:(long)num;
+(bool)getSpeed;
+(void)setSpeed:(bool)flg;
+(bool)getPause;
+(void)setPause:(bool)flg;
+(bool)getPlayBack;
+(void)setPlayBack:(bool)flg;
+(int)getPlayBackCount;
+(void)setPlayBackCount:(int)cnt;

+(int)load_Clear_Level;
+(void)save_Clear_Level:(int)num;
+(void)initialize_Clear_Level;

+(long)load_HighScore;
+(void)save_HighScore:(long)score;

+(int)load_Ticket_Count;
+(void)save_Ticket_Count:(int)cnt;
+(void)initialize_Ticket_Count;

+(NSDate*)load_Login_Date;
+(void)save_login_Date:(NSDate*)date;

+(void)submitScore_GameCenter:(NSInteger)score;

@end
