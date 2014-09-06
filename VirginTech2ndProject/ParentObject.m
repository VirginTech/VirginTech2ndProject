//
//  ParentObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/04.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ParentObject.h"


@implementation ParentObject

@synthesize collisNum;
@synthesize objNum;

CGSize winSize;

-(id)initWithParent:(int)objCnt;
{
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"circle02.png" ]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];

        self.scale=0.5;
        self.position=ccp(winSize.width/2,winSize.height/2);
        
        objNum=objCnt;
        collisNum=-1;
        
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

        //self.rotation=45;
        
        //デバッグ用ラベル
        label=[CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d",objNum]fontName:@"Verdana-Bold" fontSize:55];
        label.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        label.color=[CCColor blackColor];
        [self addChild:label];
        
        label2=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"%d",collisNum] fontName:@"Verdana-Bold" fontSize:35];
        label2.position=ccp(self.contentSize.width/2,self.contentSize.height/2-100);
        label2.color=[CCColor whiteColor];
        [self addChild:label2];
        
        [self schedule:@selector(test_Schedule:)interval:0.01];
        
    }
    return self;
}

-(void)test_Schedule:(CCTime)dt
{
    label2.string=[NSString stringWithFormat:@"%d",collisNum];
}

+(id)createParent:(int)objCnt;
{
    return [[self alloc] initWithParent:objCnt];
}

@end
