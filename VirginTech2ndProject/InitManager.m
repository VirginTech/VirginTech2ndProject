//
//  InitManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "InitManager.h"

@implementation InitManager

const int gpTotleMax=5;//グループ出現最大値
const int gpAllocationMax=5;//割当可能グループ数

float interval;
int puniOnceMax;
int puniRepeatMax;
NSMutableArray* gpNumArray;

+(int)getPuniOnceMax
{
    return puniOnceMax;
}

+(int)getPuniRepeatMax
{
    return puniRepeatMax;
}

+(float)getInterval
{
    return interval;
}

+(NSMutableArray*)getGpNumArray
{
    return gpNumArray;
}

+(NSMutableArray*)getPattern:(int)pieces size:(float)size
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSValue *offsetValue;
    
    if(pieces==1){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,0.0f)];
        [array addObject:offsetValue];
    }else if(pieces==2){
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,0.0f)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,0.0f)];
        [array addObject:offsetValue];
    }else if(pieces==3){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size/1.65)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,-size/4)];
        [array addObject:offsetValue];
    }else if(pieces==4){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size/2)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size,0)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size,0)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,-size/2)];
        [array addObject:offsetValue];
    }else if(pieces==5){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/1.2,size/2.5)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/1.2,size/2.5)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,-size/2)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,-size/2)];
        [array addObject:offsetValue];
    }
    
    return array;
}

+(NSMutableArray*)getRotation:(int)pieces
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    
    if(pieces==1){
        [array addObject:[NSNumber numberWithFloat:0.0]];
    }else if(pieces==2){
        [array addObject:[NSNumber numberWithFloat: 90.0]];
        [array addObject:[NSNumber numberWithFloat:-90.0]];
    }else if(pieces==3){
        [array addObject:[NSNumber numberWithFloat:180.0]];
        [array addObject:[NSNumber numberWithFloat:-45.0]];
        [array addObject:[NSNumber numberWithFloat: 45.0]];
    }else if(pieces==4){
        [array addObject:[NSNumber numberWithFloat:180.0]];
        [array addObject:[NSNumber numberWithFloat:-90.0]];
        [array addObject:[NSNumber numberWithFloat: 90.0]];
        [array addObject:[NSNumber numberWithFloat:  0.0]];
    }else if(pieces==5){
        [array addObject:[NSNumber numberWithFloat: 180.0]];
        [array addObject:[NSNumber numberWithFloat:-135.0]];
        [array addObject:[NSNumber numberWithFloat: 135.0]];
        [array addObject:[NSNumber numberWithFloat:  45.0]];
        [array addObject:[NSNumber numberWithFloat: -45.0]];
    }
    
    return array;
}

+(void)generate_Stage:(int)stageLevel
{
    int gpMax=2;
    int num;
    NSMutableIndexSet* gpIndex=[[NSMutableIndexSet alloc]init];;
    
    if(stageLevel==0){
        gpMax=1;
        puniOnceMax=1;
        puniRepeatMax=3;
        interval=3.0;
    }else{
        puniOnceMax=stageLevel%5;
        if(puniOnceMax==1){
            puniRepeatMax=30;//30
            interval=2.0;
        }else if(puniOnceMax==2){
            puniRepeatMax=15;
            interval=4.0;
        }else if(puniOnceMax==3){
            puniRepeatMax=10;
            interval=6.0;
        }else if(puniOnceMax==4){
            puniRepeatMax=8;
            interval=8.0;
        }else if(puniOnceMax==0){
            puniOnceMax=5;
            puniRepeatMax=6;
            interval=10.0;
        }
        for(int i=1;i<stageLevel;i++){
            if(i%5==0){
                if(gpMax<gpTotleMax){
                    gpMax++;
                }
            }
        }
    }
    
    //NSLog(@"puniOnceMax=%d",puniOnceMax);
    //NSLog(@"puniRepeatMax=%d",puniRepeatMax);
    //NSLog(@"gpMax=%d",gpMax);
    
    for(int i=0;i<gpMax;i++){
        num = (arc4random()%gpAllocationMax)+1;
        if(![gpIndex containsIndex:num]){
            [gpIndex addIndex:num];
            [gpNumArray addObject:[NSNumber numberWithInt:num]];
        }else{
            i--;
        }
    }
    
}

@end
