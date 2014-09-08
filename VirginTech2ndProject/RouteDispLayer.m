//
//  RouteDispLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/08.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "RouteDispLayer.h"
#import "CCDrawingPrimitives.h"

@implementation RouteDispLayer

@synthesize puni;

+ (RouteDispLayer *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    [self schedule:@selector(state_Schedule:)interval:0.1];
    
    return self;
}

-(void)state_Schedule:(CCTime)dt
{
    if(!puni.manualFlg){
        //NSLog(@"削除！");
        [self unschedule:@selector(state_Schedule:)];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)draw{
    
    CGPoint pt1;
    CGPoint pt2;
    NSValue* value1;
    NSValue* value2;
    
    for(int i=1;i<puni.posArray.count;i++){
        
        value1= [puni.posArray objectAtIndex:i-1];
        value2= [puni.posArray objectAtIndex:i];
        pt1=[value1 CGPointValue];
        pt2=[value2 CGPointValue];
        
        glLineWidth(1.5f);
        ccDrawColor4F(1.00f, 1.00f, 1.00f, 0.50f);
        ccDrawLine(pt1,pt2);
    }
}

@end
