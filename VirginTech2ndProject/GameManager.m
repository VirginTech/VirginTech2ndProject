//
//  GameManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int clearStageNum=14;//とりあえず

+(int)getClearStageNum
{
    return clearStageNum;
}

+(void)setClearStageNum:(int)num
{
    clearStageNum=num;
}

@end
