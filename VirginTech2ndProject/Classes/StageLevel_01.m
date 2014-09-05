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

CGSize winSize;
int puniCnt;

NSMutableArray* puniArray;
NSMutableArray* parentArray;

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
    
    //親プニ配置
    parent=[ParentObject createParent];
    [self addChild:parent];
    [parentArray addObject:parent];
    
    parent=[ParentObject createParent];
    parent.position=ccp(winSize.width/2/2,winSize.height/2);
    [self addChild:parent];
    [parentArray addObject:parent];
    
    parent=[ParentObject createParent];
    parent.position=ccp(winSize.width-winSize.width/2/2,winSize.height/2);
    [self addChild:parent];
    [parentArray addObject:parent];
    
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
    puni=[PuniObject createPuni];
    [puniArray addObject:puni];
    [self addChild:puni];
    if(puniCnt>=10){
        [self unschedule:@selector(createPuni_Schedule:)];
    }
}

-(void)judgement_Schedule:(CCTime)dt
{
    //衝突反射
    float collisSurfaceAngle;//衝突面角度
    //CGPoint nextPos;
    
    for(PuniObject* puni1 in puniArray){
        for(ParentObject* parent1 in parentArray){
            if([BasicMath RadiusIntersectsRadius:puni1.position
                                                pointB:parent1.position
                                                radius1:(puni1.contentSize.width*puni1.scale)/2.0f
                                                radius2:(parent1.contentSize.width*parent1.scale)/2.0f])
            {
                if(!parent1.collisFlg){
                    //nextPos=CGPointMake(3*cosf(puni1.targetAngle),3*sinf(puni1.targetAngle));
                    //puni1.position=CGPointMake(puni1.position.x-nextPos.x, puni1.position.y-nextPos.y);

                    parent1.collisFlg=true;
                    collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:parent1.position];
                    puni1.targetAngle = 2*collisSurfaceAngle-(puni1.targetAngle+collisSurfaceAngle);
                    
                    //puni1.targetAngle = 2*(collisSurfaceAngle-puni1.targetAngle);
                    //NSLog(@"%f",puni1.targetAngle);
                }
            }else{
                parent1.collisFlg=false;
            }
        }
    }
    
    /*
    for(PuniObject* puni1 in puniArray){
        for(PuniObject* puni2 in puniArray){
            if([BasicMath RadiusIntersectsRadius:puni1.position
                                                pointB:puni2.position
                                                radius1:(puni1.contentSize.width*puni1.scale)/2.0f
                                                radius2:(puni2.contentSize.width*puni2.scale)/2.0f])
            {
                if(puni1!=puni2){
                    collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:puni2.position];
                    puni1.targetAngle = 2*collisSurfaceAngle-puni1.targetAngle+collisSurfaceAngle;
                }
            }
        }
    }*/
}

-(float)getCollisSurfaceAngle:(CGPoint)pos1 pos2:(CGPoint)pos2
{
    float angle;
    
    //angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
    //NSLog(@"入った！");
    float inAngle=[BasicMath getAngle_To_Degree:pos2 ePos:pos1];
    
    if(inAngle>=315 || inAngle<45){//上
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
        //NSLog(@"上");
    }else if(inAngle>=45 && inAngle<135){//右
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI * 2;
        //NSLog(@"右");
    }else if(inAngle>=135 && inAngle<225){//下
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
       // NSLog(@"下");
    }else if(inAngle>=225 && inAngle<315){//左
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI;
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

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
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
