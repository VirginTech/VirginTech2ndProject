//
//  ParentObject.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/04.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ParentObject.h"
#import "InitManager.h"

@implementation ParentObject

//@synthesize collisNum;
@synthesize objNum;
@synthesize gpNum;

CGSize winSize;

-(void)startBlink
{
    [self schedule:@selector(blink_Schedule:) interval:0.25];
}

-(void)blink_Schedule:(CCTime)dt
{
    if([self visible]){
        [self setVisible:NO];
    }else{
        [self setVisible:YES];
    }
}

-(id)initWithParent:(int)objCnt gpNum:(int)_gpNum;
{
    CGPoint centerPos;
    NSMutableArray* gpPatternArray=[[NSMutableArray alloc]init];
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"circle_default.plist"];
    NSString* gpName=[NSString stringWithFormat:@"circle%02d.png",_gpNum];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:gpName]])
    {
        winSize = [[CCDirector sharedDirector]viewSize];

        self.scale=0.40;
        
        centerPos=ccp(winSize.width/2,winSize.height/2);
        gpPatternArray=[InitManager getPattern:
                        (int)[InitManager getGpNumArray].count size:self.contentSize.width*self.scale];
        self.position=ccp(centerPos.x+[[gpPatternArray objectAtIndex:objCnt]CGPointValue].x,
                          centerPos.y+[[gpPatternArray objectAtIndex:objCnt]CGPointValue].y);
        
        objNum=objCnt;
        gpNum=_gpNum;
        
        /*/デバッグ用ライン
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
        */
        //デバッグ用ラベル
        label=[CCLabelTTF labelWithString:
               [NSString stringWithFormat:@"%d",gpNum]fontName:@"Verdana-Bold" fontSize:55];
        label.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        label.color=[CCColor blackColor];
        [self addChild:label];
        /*
        label2=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"%d",collisNum] fontName:@"Verdana-Bold" fontSize:35];
        label2.position=ccp(self.contentSize.width/2,self.contentSize.height/2-100);
        label2.color=[CCColor whiteColor];
        [self addChild:label2];
        
        [self schedule:@selector(test_Schedule:)interval:0.01];
        */
    }
    return self;
}

/*
-(void)test_Schedule:(CCTime)dt
{
    label2.string=[NSString stringWithFormat:@"%d",collisNum];
}*/

+(id)createParent:(int)objCnt gpNum:(int)_gpNum;
{
    return [[self alloc] initWithParent:objCnt gpNum:_gpNum];
}

@end
