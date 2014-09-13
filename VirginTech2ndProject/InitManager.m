//
//  InitManager.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/10.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "InitManager.h"

@implementation InitManager

const int gpTotleMax=5;

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
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size/2)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,-size/4)];
        [array addObject:offsetValue];
    }else if(pieces==4){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size/2)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,-size)];
        [array addObject:offsetValue];
    }else if(pieces==5){
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,size/2)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(-size/2,-size/4)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(0.0f,-size)];
        [array addObject:offsetValue];
        offsetValue=[NSValue valueWithCGPoint:ccp(size,-size)];
        [array addObject:offsetValue];
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
        puniRepeatMax=5;
    }else{
        puniOnceMax=stageLevel%5;
        if(puniOnceMax==0){
            puniOnceMax=5;
        }
        if(puniOnceMax==1){
            puniRepeatMax=10;
        }else if(puniOnceMax==2){
            puniRepeatMax=5;
        }else if(puniOnceMax==3){
            puniRepeatMax=4;
        }else if(puniOnceMax==4){
            puniRepeatMax=3;
        }else if(puniOnceMax==5){
            puniRepeatMax=2;
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
        num = (arc4random()%gpTotleMax)+1;
        if(![gpIndex containsIndex:num]){
            [gpIndex addIndex:num];
            [gpNumArray addObject:[NSNumber numberWithInt:num]];
        }else{
            i--;
        }
    }
    
}

@end
