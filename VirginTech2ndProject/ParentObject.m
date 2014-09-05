//
//  ParentObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/04.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ParentObject.h"


@implementation ParentObject

@synthesize collisFlg;

CGSize winSize;

-(id)initWithParent
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"circle02.png" ]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];

        self.scale=0.5;
        self.position=ccp(winSize.width/2,winSize.height/2);
        
        collisFlg=false;
        
        //デバッグ用ライン
        CCDrawNode* drawNode1=[CCDrawNode node];
        [drawNode1 drawSegmentFrom:ccp(self.contentSize.width/2-800,self.contentSize.height/2)
                               to:ccp(self.contentSize.width/2+800,self.contentSize.height/2)
                           radius:1.0
                            color:[CCColor whiteColor]];
        [self addChild:drawNode1];

        CCDrawNode* drawNode2=[CCDrawNode node];
        [drawNode2 drawSegmentFrom:ccp(self.contentSize.width/2,self.contentSize.height/2-800)
                               to:ccp(self.contentSize.width/2,self.contentSize.height/2+800)
                           radius:1.0
                            color:[CCColor whiteColor]];
        [self addChild:drawNode2];

        self.rotation=45;
    }
    return self;
}

+(id)createParent
{
    return [[self alloc] initWithParent];
}

@end
