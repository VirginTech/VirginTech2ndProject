//
//  GameManager.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(int)getStageNum;
+(void)setStageNum:(int)num;
+(long)getScore;
+(void)setScore:(long)num;
+(bool)getSpeed;
+(void)setSpeed:(bool)flg;

+(int)load_Clear_Level;
+(void)save_Clear_Level:(int)num;
+(void)initialize_Clear_Level;

+(long)load_HighScore;
+(void)save_HighScore:(long)score;

@end
