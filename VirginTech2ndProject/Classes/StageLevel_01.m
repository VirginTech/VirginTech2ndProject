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
#import "InitManager.h"
#import "GameManager.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation StageLevel_01

CGSize winSize;

int stageLevel;
int puniCnt;

PuniObject* puni;
ParentObject* parent;
RouteDispLayer* routeDisp;

NSMutableArray* puniArray;
NSMutableArray* parentArray;
NSMutableArray* gpNumArray;

NSMutableArray* removePuniArray;

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
    puniCnt=0;
    puniArray=[[NSMutableArray alloc]init];
    parentArray=[[NSMutableArray alloc]init];
    gpNumArray=[[NSMutableArray alloc]init];
    
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

    //ステージレヴェル取得
    stageLevel=[GameManager getClearStageNum]+1;
    
    //ステージデータ初期化
    [InitManager generate_Stage:stageLevel];
    
    //グループ番号取得
    gpNumArray=[InitManager getGpNumArray];
    
    //プニ配置
    [self schedule:@selector(createPuni_Schedule:)interval:10.0
                                                repeat:[InitManager getPuniRepeatMax]-1
                                                delay:5.0];
    //親プニ配置
    for(int i=0;i<gpNumArray.count;i++){
        parent=[ParentObject createParent:i gpNum:[[gpNumArray objectAtIndex:i]intValue]];
        [self addChild:parent];
        [parentArray addObject:parent];
    }
    
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
    int gpNum;

    for(int i=0;i<[InitManager getPuniOnceMax];i++)
    {
        bool flg=true;
        puniCnt++;
        
        gpNum=arc4random()%gpNumArray.count;
        //puni=[PuniObject createPuni:puniCnt gpNum:[[gpNumArray objectAtIndex:gpNum]intValue]];

        //重なり防止
        while(flg){
            flg=false;
            puni=[PuniObject createPuni:puniCnt gpNum:[[gpNumArray objectAtIndex:gpNum]intValue]];
            for(PuniObject* puni1 in puniArray){
                if([BasicMath RadiusIntersectsRadius:puni1.position
                                                pointB:puni.position
                                                radius1:(puni1.contentSize.width*puni1.scale)/2.0f+30.0
                                                radius2:(puni.contentSize.width*puni.scale)/2.0f+30.0])
                {
                    flg=true;
                    break;
                }
            }
        }
        
        [puniArray addObject:puni];
        [self addChild:puni z:2];
        
        routeDisp=[[RouteDispLayer alloc]init];
        routeDisp.puni=puni;
        [self addChild:routeDisp z:1];
    }
}

-(void)judgement_Schedule:(CCTime)dt
{
    //初期化
    removePuniArray=[[NSMutableArray alloc]init];
    
    //プニ同士の衝突判定
    float collisSurfaceAngle;//衝突面角度
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
                        if(!puni1.startFlg && !puni2.startFlg){
                            
                            //めり込み監視
                            puni1.collisNum=puni2.objNum;
                            puni2.collisNum=puni1.objNum;
                            
                            //反射角算定
                            collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:puni2.position];
                            puni1.targetAngle = 2*collisSurfaceAngle-(puni1.targetAngle+collisSurfaceAngle);
                            
                            collisSurfaceAngle = [self getCollisSurfaceAngle:puni2.position pos2:puni1.position];
                            puni2.targetAngle = 2*collisSurfaceAngle-(puni2.targetAngle+collisSurfaceAngle);
                            
                            //マニュアルモード解除
                            puni1.posArray = [[NSMutableArray alloc]init];
                            puni1.moveCnt=0;
                            if(puni1==touchPuni)touchPuni=nil;
                            
                            puni2.posArray = [[NSMutableArray alloc]init];
                            puni2.moveCnt=0;
                            if(puni2==touchPuni)touchPuni=nil;
                            
                        }
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
    
    //プニ　対　親プニ
    for(PuniObject* puni1 in puniArray){
        for(ParentObject* parent1 in parentArray){
            if([BasicMath RadiusIntersectsRadius:puni1.position
                                            pointB:parent1.position
                                            radius1:(puni1.contentSize.width*puni1.scale)/2.0f-5.0
                                            radius2:(parent1.contentSize.width*parent1.scale)/2.0f-5.0])
            {
                if(puni1.gpNum == parent1.gpNum)
                {
                    [removePuniArray addObject:puni1];
                    puni1.posArray = [[NSMutableArray alloc]init];
                    puni1.moveCnt=0;
                }else{
                    [self endGame];
                }
            }
        }
    }
    [self removeObject];
}

-(void)endGame
{
    for(PuniObject* puni1 in puniArray)
    {
        puni1.endFlg=true;
        puni1.posArray = [[NSMutableArray alloc]init];
        puni1.moveCnt=0;
        
        self.userInteractionEnabled = NO;
        [self unscheduleAllSelectors];//終了
    }
}

-(void)removeObject
{
    for(PuniObject* puni1 in removePuniArray)
    {
        [puniArray removeObject:puni1];
        [self removeChild:puni1 cleanup:YES];
    }
}

-(float)getCollisSurfaceAngle:(CGPoint)pos1 pos2:(CGPoint)pos2
{
    float angle;
    
    float inAngle=[BasicMath getAngle_To_Degree:pos1 ePos:pos2];
    
    if(inAngle>=315 || inAngle<45){//上
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
    }else if(inAngle>=45 && inAngle<135){//右
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI;
    }else if(inAngle>=135 && inAngle<225){//下
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
    }else if(inAngle>=225 && inAngle<315){//左
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI * 2;
    }
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
