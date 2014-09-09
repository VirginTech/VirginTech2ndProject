//
//  HelloWorldScene.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/01.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "StageLevel_01.h"
#import "TitleScene.h"
#import "BasicMath.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation StageLevel_01

const int puniMax=3;

CGSize winSize;
int puniCnt;

PuniObject* puni;
ParentObject* parent;
RouteDispLayer* routeDisp;

NSMutableArray* puniArray;
NSMutableArray* parentArray;

PuniObject* touchPuni;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (StageLevel_01 *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //各種データ初期化
    puniArray=[[NSMutableArray alloc]init];
    parentArray=[[NSMutableArray alloc]init];
    
    winSize = [[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.90f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    //プニ配置
    puniCnt=0;
    [self schedule:@selector(createPuni_Schedule:)interval:3.0];
    
    /*/親プニ配置
    parent=[ParentObject createParent:1];
    [self addChild:parent];
    [parentArray addObject:parent];
    
    parent=[ParentObject createParent:2];
    parent.position=ccp(winSize.width/2/2,winSize.height/2);
    [self addChild:parent];
    [parentArray addObject:parent];
    
    parent=[ParentObject createParent:3];
    parent.position=ccp(winSize.width-winSize.width/2/2,winSize.height/2);
    [self addChild:parent];
    [parentArray addObject:parent];
    */
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)createPuni_Schedule:(CCTime)dt
{
    puniCnt++;
    puni=[PuniObject createPuni:puniCnt];
    [puniArray addObject:puni];
    [self addChild:puni z:2];
    if(puniCnt>=puniMax){
        [self unschedule:@selector(createPuni_Schedule:)];
    }
}

-(void)judgement_Schedule:(CCTime)dt
{
    //衝突反射
    float collisSurfaceAngle;//衝突面角度
    //CGPoint nextPos;
    /*
    for(PuniObject* puni1 in puniArray){
        for(ParentObject* parent1 in parentArray){
            if([BasicMath RadiusIntersectsRadius:puni1.position
                                                pointB:parent1.position
                                                radius1:(puni1.contentSize.width*puni1.scale)/2.0f
                                                radius2:(parent1.contentSize.width*parent1.scale)/2.0f])
            {
                if(parent1.collisNum!=puni1.objNum && puni1.collisNum!=parent1.objNum){
                    //nextPos=CGPointMake(3*cosf(puni1.targetAngle),3*sinf(puni1.targetAngle));
                    //puni1.position=CGPointMake(puni1.position.x-nextPos.x, puni1.position.y-nextPos.y);

                    puni1.collisNum=parent1.objNum;
                    parent1.collisNum=puni1.objNum;
                    
                    collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:parent1.position];
                    puni1.targetAngle = 2*collisSurfaceAngle-(puni1.targetAngle+collisSurfaceAngle);
                    
                    //puni1.targetAngle = 2*(collisSurfaceAngle-puni1.targetAngle);
                    //NSLog(@"%f",puni1.targetAngle);
                }
            }else{
                if(parent1.collisNum==puni1.objNum || puni1.collisNum==parent1.objNum){
                    parent1.collisNum=-1;
                    puni1.collisNum=-1;
                }
            }
        }
    }*/
    
    for(PuniObject* puni1 in puniArray){
        for(PuniObject* puni2 in puniArray){
            if([BasicMath RadiusIntersectsRadius:puni1.position
                                                pointB:puni2.position
                                                radius1:(puni1.contentSize.width*puni1.scale)/2.0f-1.5
                                                radius2:(puni2.contentSize.width*puni2.scale)/2.0f-1.5])
            {
                if(puni1!=puni2){
                    if(puni2.collisNum!=puni1.objNum && puni1.collisNum!=puni2.objNum){
                    //if(puni1.collisNum!=puni2.objNum){

                        puni1.collisNum=puni2.objNum;
                        puni2.collisNum=puni1.objNum;
                        
                        collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:puni2.position];
                        puni1.targetAngle = 2*collisSurfaceAngle-(puni1.targetAngle+collisSurfaceAngle);
                        
                        collisSurfaceAngle = [self getCollisSurfaceAngle:puni2.position pos2:puni1.position];
                        puni2.targetAngle = 2*collisSurfaceAngle-(puni2.targetAngle+collisSurfaceAngle);
                        
                        puni1.posArray = [[NSMutableArray alloc]init];
                        puni1.moveCnt=0;
                        
                        puni2.posArray = [[NSMutableArray alloc]init];
                        puni2.moveCnt=0;
                        
                    }
                }
            }else{
                if(puni1!=puni2){
                    if(puni2.collisNum==puni1.objNum || puni1.collisNum==puni2.objNum){
                    //if(puni1.collisNum==puni2.objNum){
                        puni1.collisNum=-1;
                        puni2.collisNum=-1;
                    }
                }
            }
        }
    }
}

-(float)getCollisSurfaceAngle:(CGPoint)pos1 pos2:(CGPoint)pos2
{
    float angle;
    
    //angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
    //NSLog(@"入った！");
    float inAngle=[BasicMath getAngle_To_Degree:pos1 ePos:pos2];
    
    if(inAngle>=315 || inAngle<45){//上
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
        //NSLog(@"上");
    }else if(inAngle>=45 && inAngle<135){//右
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI;
        //NSLog(@"右");
    }else if(inAngle>=135 && inAngle<225){//下
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
       // NSLog(@"下");
    }else if(inAngle>=225 && inAngle<315){//左
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI * 2;
        //NSLog(@"左");
    }
    
    /*
    if(pos1.x<=pos2.x){//左
        if(pos1.y<=pos2.y){//下
            angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
        }else if(pos1.y>pos2.y){//上
            angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
        }
    }else if(pos1.x>pos2.x){//右
        if(pos1.y<=pos2.y){//下
            angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
        }else if(pos1.y>pos2.y){//上
            angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
        }
    }
    */
    return angle;
}

//============================
// タッチした球体を特定する
//============================
-(BOOL)isPuni:(CGPoint)touchLocation
{
    BOOL flg=false;
    for(PuniObject* _puni in puniArray){
        if([BasicMath RadiusContainsPoint:_puni.position
                                            pointB:touchLocation
                                            radius:(_puni.contentSize.width*_puni.scale)/2+10]){
            touchPuni=_puni;
            flg=true;
        }
    }
    return flg;
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    if([self isPuni:touchLocation]){
        
        touchPuni.touchFlg=true;
        touchPuni.posArray = [[NSMutableArray alloc]init];
        touchPuni.moveCnt=0;
        
        if(!touchPuni.manualFlg){
            routeDisp=[[RouteDispLayer alloc]init];
            routeDisp.puni=touchPuni;
            [self addChild:routeDisp z:1];
        }
    }else{
        touchPuni=nil;
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];

    if(touchPuni!=nil){
        if(![BasicMath RadiusContainsPoint:touchPuni.position pointB:touchLocation
                                                radius:(touchPuni.contentSize.width*touchPuni.scale)/2]){
            NSValue *value = [NSValue valueWithCGPoint:touchLocation];
            [touchPuni.posArray addObject:value];
        }
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    touchPuni.touchFlg=false;
    if(touchPuni!=nil){
        if(touchPuni.posArray.count<=0){
            touchPuni.manualFlg=false;
            touchPuni=nil;
        }
    }
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

// -----------------------------------------------------------------------

@end
