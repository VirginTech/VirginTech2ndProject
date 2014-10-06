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
#import "InfoLayer.h"
#import "NaviLayer.h"
#import "MsgLayer.h"
#import "FingerObject.h"
#import "AdGenerLayer.h"
#import <Social/Social.h>

@implementation StageLevel_01

CGSize winSize;

int stageLevel;
int puniCnt;//プニ個別番号
int pointPuniCnt;//プニ成功カウント

PuniObject* puni;
PuniObject* touchPuni;
ParentObject* parent;
RouteDispLayer* routeDisp;
ArrowObject* arrow;

NSMutableArray* puniArray;
NSMutableArray* parentArray;
NSMutableArray* gpNumArray;
NSMutableArray* removePuniArray;

NaviLayer* naviLayer;
CCButton *pauseButton;
CCButton *resumeButton;
CCButton *speed1xButton;
CCButton *speed2xButton;

CCParticleSystem* parentParticle;

//チュートリアル
bool tutorialFlg;
FingerObject* finger;
NSMutableArray* drawArray;


//Ad
AdGenerLayer* adgSSP;

//デバッグ用ラベル
//CCLabelTTF* puniLabel;
//NSMutableArray* labelArray;

+ (StageLevel_01 *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //各種データ初期化
    puniCnt=0;
    pointPuniCnt=0;
    puniArray=[[NSMutableArray alloc]init];
    parentArray=[[NSMutableArray alloc]init];
    gpNumArray=[[NSMutableArray alloc]init];
    drawArray=[[NSMutableArray alloc]init];
    [GameManager setPause:false];
    [GameManager setPlayBack:false];
    tutorialFlg=false;
    parentParticle=nil;
    
    //labelArray=[[NSMutableArray alloc]init];//デバッグ用
    
    winSize = [[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];

    //背景
    [self setBackGround];
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];

    //ポーズボタン
    pauseButton = [CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"pause.png"]];
    pauseButton.scale=0.5;
    pauseButton.position = ccp(winSize.width-(pauseButton.contentSize.width*pauseButton.scale)/2,
                               (pauseButton.contentSize.height*pauseButton.scale)/2);
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton z:4];
    pauseButton.visible=true;
    
    //レジュームボタン
    resumeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"resume.png"]];
    resumeButton.scale=0.5;
    resumeButton.position = ccp(winSize.width-(resumeButton.contentSize.width*resumeButton.scale)/2,
                                (resumeButton.contentSize.height*resumeButton.scale)/2);
    [resumeButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:resumeButton z:4];
    resumeButton.visible=false;
    
    //1xスピードボタン
    speed1xButton = [CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"normal_sp.png"]];
    speed1xButton.scale=0.5;
    speed1xButton.position = ccp((speed1xButton.contentSize.width*speed1xButton.scale)/2,
                                 (speed1xButton.contentSize.height*speed1xButton.scale)/2);
    [speed1xButton setTarget:self selector:@selector(onSpeed2xClicked:)];
    [self addChild:speed1xButton z:4];
    speed1xButton.visible=false;
    
    //2xスピードボタン
    speed2xButton = [CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"double_sp.png"]];
    speed2xButton.scale=0.5;
    speed2xButton.position = ccp((speed2xButton.contentSize.width*speed2xButton.scale)/2,
                                 (speed2xButton.contentSize.height*speed2xButton.scale)/2);
    [speed2xButton setTarget:self selector:@selector(onSpeed2xClicked:)];
    [self addChild:speed2xButton z:4];
    speed2xButton.visible=false;

    //倍速切り替え
    if(![GameManager getSpeed]){
        speed1xButton.visible=false;
        speed2xButton.visible=true;
    }else{
        speed1xButton.visible=true;
        speed2xButton.visible=false;
    }

    //インフォレイヤー
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer z:0];
    
    //ナビレイヤー
    naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:3];
    naviLayer.visible=false;
    
    //ステージレヴェル取得
    stageLevel=[GameManager getStageNum];
    
    //ステージデータ初期化
    [InitManager generate_Stage:stageLevel];
    
    //グループ番号取得
    gpNumArray=[InitManager getGpNumArray];
    
    //プニ配置
    [self schedule:@selector(createPuni_Schedule:)interval:[InitManager getInterval]
                                                repeat:CCTimerRepeatForever
                                                delay:5.0];
    //親プニ配置
    for(int i=0;i<gpNumArray.count;i++){
        parent=[ParentObject createParent:i gpNum:[[gpNumArray objectAtIndex:i]intValue]];
        [self addChild:parent];
        [parentArray addObject:parent];
    }
    
    //開始メッセージ
    MsgLayer* msg;
    if(stageLevel==0){
        msg=[[MsgLayer alloc]initWithMsg:@"Tutorial Level" nextFlg:false];
    }else{
        msg=[[MsgLayer alloc]initWithMsg:
                                [NSString stringWithFormat:@"Lv.%d Start!",stageLevel]
                                 nextFlg:false];
    }
    [self addChild:msg];
    
    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
    
    //Ad削除
    [adgSSP removeLayer];
}

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

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

//============================
// 背景描画
//============================
-(void)setBackGround
{
    float offsetX;
    float offsetY;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"backGround_default.plist"];
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bg01.png"]];
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+2,
                                                winSize.height/frame.contentSize.height+1);
    NSString* bgName=[NSString stringWithFormat:@"bg%02d.png",(arc4random()%10)+1];
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        if(i==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = frame.contentSize.height/2-1;
        }else if(i%(int)frameCount.width==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = offsetY + frame.contentSize.height-1;
        }else{
            offsetX = offsetX + frame.contentSize.width-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame z:0];
    }
}

//============================
// プニ生成スケジューラ
//============================
-(void)createPuni_Schedule:(CCTime)dt
{
    int gpNum;

    if(![GameManager getPause] && ![GameManager getPlayBack]){
        
        for(int i=0;i<[InitManager getPuniOnceMax];i++)
        {
            bool flg=true;
            puniCnt++;
            
            //グループ番号ランダム付与
            gpNum=arc4random()%gpNumArray.count;

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
            
            //チュートリアル用フィンガー表示
            if([GameManager getStageNum]==0){
                puni.finger.visible=true;
            }
            
            //矢印表示
            arrow=[ArrowObject createArrow:puni];
            [self addChild:arrow z:2];
            
            /*/デバッグ用ラベル
            puniLabel=[CCLabelTTF labelWithString:@"ObjNo= PosX= PosY= " fontName:@"Verdana-Bold" fontSize:8];
            puniLabel.name=[NSString stringWithFormat:@"%d",puni.objNum];
            puniLabel.position=ccp(100,winSize.height-20-(puniCnt*10));
            [self addChild:puniLabel z:4];
            [labelArray addObject:puniLabel];*/
            
            //経路レイヤー生成
            routeDisp=[[RouteDispLayer alloc]init];
            routeDisp.puni=puni;
            [self addChild:routeDisp z:1];
            
            if(puniCnt>=[InitManager getPuniOnceMax]*[InitManager getPuniRepeatMax]){
                [self unschedule:@selector(createPuni_Schedule:)];
            }
        }
    }
}
//============================
// チュートリアル用フィンガー移動用
//============================
-(void)finger_Move_Schedule:(CCTime)dt
{
    tutorialFlg=true;
    
    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    CGPoint endPos=ccp(parent.position.x+(finger.contentSize.width*finger.scale)/2,
                       parent.position.y+(finger.contentSize.height*finger.scale)/2);
    
    //方角セット
    targetAngle = [BasicMath getAngle_To_Radian:finger.position ePos:endPos];
    //総距離セット
    targetDistance = sqrtf(powf(finger.position.x - endPos.x,2) + powf(finger.position.y - endPos.y,2));
    //次位置セット
    nextPos=CGPointMake(2.0*cosf(targetAngle),2.0*sinf(targetAngle));
    finger.position=CGPointMake(finger.position.x+nextPos.x, finger.position.y+nextPos.y);
    //線描画
    CCDrawNode* drawNode=[CCDrawNode node];
    [drawNode drawDot:ccp(finger.position.x-(finger.contentSize.width*finger.scale)/2,
                          finger.position.y-(finger.contentSize.width*finger.scale)/2)
               radius:1.5 color:[CCColor whiteColor]];
    [self addChild:drawNode];
    [drawArray addObject:drawNode];
    
    if(targetDistance < 5.0){
        [self unschedule:@selector(finger_Move_Schedule:)];
        for(CCDrawNode* drow_ in drawArray){
            [self removeChild:drow_ cleanup:YES];
        }
        [self removeChild:finger cleanup:YES];
        drawArray=[[NSMutableArray alloc]init];
        tutorialFlg=false;
    }

}

//============================
// 審判スケジューラ
//============================
-(void)judgement_Schedule:(CCTime)dt
{
    if(![GameManager getPause] && ![GameManager getPlayBack]){
        
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
                                
                                //Puni1 反射角算定
                                collisSurfaceAngle = [self getCollisSurfaceAngle:puni1.position pos2:puni2.position];
                                puni1.targetAngle = 2*collisSurfaceAngle-(puni1.targetAngle+collisSurfaceAngle);
                                
                                //Puni2 反射角算定
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
                        //パーティクル効果
                        [self setParentParticle:parent1.position fileName:@"parent.plist"];
                        [parent1 puni_Hit_Action];
                        
                        //プニ削除
                        [removePuniArray addObject:puni1];
                        puni1.posArray = [[NSMutableArray alloc]init];
                        puni1.moveCnt=0;
                        
                        /*/デバッグラベル削除
                        for(CCLabelTTF* label in labelArray){
                            if(puni1.objNum==[label.name intValue]){
                                label.color=[CCColor redColor];
                                //[self removeChild:label cleanup:YES];
                                //[labelArray removeObject:label];
                            }
                        }*/
                        
                        //スコア更新
                        if(stageLevel>0){
                            [GameManager setScore:[GameManager getScore]+1];
                            [InfoLayer update_Score];
                        }
                        
                        //ステージ終了
                        pointPuniCnt++;
                        if(pointPuniCnt>=[InitManager getPuniOnceMax]*[InitManager getPuniRepeatMax]){
                            //ハイスコア保存
                            if([GameManager load_HighScore]<[GameManager getScore]){
                                [GameManager save_HighScore:[GameManager getScore]];
                                //リーダーボード送信
                                [GameManager submitScore_GameCenter:[GameManager load_HighScore]];
                            }
                            //次ステージへ
                            [self nextStage];
                        }
                    }else{//ステージ失敗
                        [self endGame];
                        [puni1 startBlink];
                        [parent1 startBlink];
                    }
                }
            }
        }
        //枠外判定
        [self removeOutSideFrameObject];
        
        //消滅オブジェクト削除
        [self removeObject];
        
        /*/デバッグ用ラベル更新
        for(PuniObject* puni1 in puniArray){
            for(CCLabelTTF* label in labelArray){
                if(puni1.objNum==[label.name intValue]){
                    label.string=[NSString stringWithFormat:@"ObjNo=%02d PosX=%.3f PosY=%.3f ",
                                  puni1.objNum,puni1.position.x,puni1.position.y];
                }
            }
        }*/
    }
}

//============================
// 画面外プニ削除、カウント付与
//============================
-(void)removeOutSideFrameObject
{
    for(PuniObject* puni1 in puniArray)
    {
        //if(!puni1.startFlg){
            if(puni1.position.y-(puni1.contentSize.height*puni1.scale)/2 > winSize.height + 50){//上枠外
                pointPuniCnt++;
                [removePuniArray addObject:puni1];
            }else if(puni1.position.y+(puni1.contentSize.height*puni1.scale)/2 < 0 - 50){//下枠外
                pointPuniCnt++;
                [removePuniArray addObject:puni1];
            }else if(puni1.position.x+(puni1.contentSize.width*puni1.scale)/2 < 0 - 50){//左枠外
                pointPuniCnt++;
                [removePuniArray addObject:puni1];
            }else if(puni1.position.x-(puni1.contentSize.width*puni1.scale)/2 > winSize.width + 50){//右枠外
                pointPuniCnt++;
                [removePuniArray addObject:puni1];
            }
        //}
    }
}

//============================
// メッセージ終了後、ネクストステージへ
//============================
-(void)nextStage
{
    //レヴェル保存
    if([GameManager load_Clear_Level]<stageLevel){
        [GameManager save_Clear_Level:stageLevel];
    }
    
    MsgLayer* msg=[[MsgLayer alloc]initWithMsg:@"Good Job!" nextFlg:true];
    [self addChild:msg];
    
    //レイティング
    if(stageLevel!=0 && stageLevel%10==0){
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=1;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"Rate",NULL);
        alert.message=NSLocalizedString(@"Rate_Message",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"NoThanks",NULL)];
        [alert addButtonWithTitle:NSLocalizedString(@"RemindMeLater",NULL)];
        [alert addButtonWithTitle:NSLocalizedString(@"RateItNow",NULL)];
        [alert show];
        
        [[CCDirector sharedDirector]pause];
    }

    //次ステージへ
    //[GameManager setStageNum:stageLevel+1];//ステージレヴェル設定
    //[[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

//============================
// ゲーム終了
//============================
-(void)endGame
{
    //全プニ停止
    for(PuniObject* puni1 in puniArray)
    {
        puni1.posArray = [[NSMutableArray alloc]init];
        puni1.moveCnt=0;
    }
    self.userInteractionEnabled = NO;
    //[self unscheduleAllSelectors];//終了
    pauseButton.visible=false;
    [GameManager setPause:true];
    naviLayer.playbackButton.visible=true;
    naviLayer.titleButton.positionType = CCPositionTypeNormalized;
    naviLayer.titleButton.position = ccp(0.425f, 0.25f);
    naviLayer.titleButton.rotation=-35;
    naviLayer.visible=true;

    //ハイスコア保存
    if([GameManager load_HighScore]<[GameManager getScore]){
        [GameManager save_HighScore:[GameManager getScore]];
        //リーダーボード送信
        [GameManager submitScore_GameCenter:[GameManager load_HighScore]];
    }
    [self schedule:@selector(playBack_state_Schedule:) interval:0.1];
    
    //ADG-SSPバナー
    adgSSP=[[AdGenerLayer alloc]init];
    [self addChild:adgSSP];
    
    //ソーシャル機能
    if([GameManager getPlayBackCount]==0){
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=2;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"Share",NULL);
        alert.message=NSLocalizedString(@"Social_Message",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"Twitter",NULL)];
        [alert addButtonWithTitle:NSLocalizedString(@"Facebook",NULL)];
        [alert addButtonWithTitle:NSLocalizedString(@"NoThanks",NULL)];
        [alert show];
    }
}
//============================
// レイティングメッセージ受信
//============================
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL* url;
    if(alertView.tag==1){
        switch (buttonIndex){
            case 0:
                [[CCDirector sharedDirector]resume];
                break;
            case 1:
                [[CCDirector sharedDirector]resume];
                break;
            case 2:
                url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=914387804&mt=8&type=Purple+Software"];
                [[UIApplication sharedApplication]openURL:url];
                break;
        }
    }else if(alertView.tag==2){
        switch (buttonIndex){
            case 0:
                [self post_Twitter];
                break;
            case 1:
                [self post_Facebook];
                break;
            case 2:
                break;
        }
    }
}

//============================
// プレイバック開始（後戻し）
//============================
+(void)startPlayBack
{
    for(PuniObject* puni1 in puniArray){
        puni1.blinkFlg=false;
    }
    for(ParentObject* parent1 in parentArray){
        parent1.blinkFlg=false;
    }
    [GameManager setPlayBack:true];
}

//============================
// プレイバック再開準備状況監視スケジューラ
//============================
-(void)playBack_state_Schedule:(CCTime)dt
{
    bool flg=false;
    for(PuniObject* puni1 in puniArray){
        if(!puni1.playBackReadyFlg){
            flg=true;
            break;
        }
    }
    if(!flg){//再開
        naviLayer.visible=false;
        
        [GameManager setPause:false];
        [GameManager setPlayBack:false];
        
        //プレイバック配列初期化
        for(PuniObject* puni1 in puniArray){
            puni1.playBackArray=[[NSMutableArray alloc]init];
        }
        
        pauseButton.visible=true;
        self.userInteractionEnabled = YES;
        [self unschedule:@selector(playBack_state_Schedule:)];
        
        //Ad削除
        [adgSSP removeLayer];
    }
}

//============================
// プニ オブジェクト削除
//============================
-(void)removeObject
{
    for(PuniObject* puni1 in removePuniArray)
    {
        [puniArray removeObject:puni1];
        [self removeChild:puni1 cleanup:YES];
    }
}

//============================
// デバッグ用
//============================
+(void)pointPuniCntAdd
{
    pointPuniCnt++;
}

//============================
// パーティクルセット(親)
//============================
-(void)setParentParticle:(CGPoint)pos fileName:(NSString*)fileName
{
    if(parentParticle!=nil){//その都度削除
        [self removeChild:parentParticle cleanup:YES];
    }
    parentParticle=[[CCParticleSystem alloc]initWithFile:fileName];
    parentParticle.position=pos;
    parentParticle.scale=0.30;
    [self addChild:parentParticle];
}

//============================
// 衝突面アングル算出
//============================
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
            //if(!_puni.startFlg){//枠内であれば
                touchPuni=_puni;
                flg=true;
            //}
        }
    }
    return flg;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    if([self isPuni:touchLocation]){
        
        //チュートリアル用フィンガー
        if([GameManager getStageNum]==0){
            if(!tutorialFlg){
                if(touchPuni.finger.visible){
                    touchPuni.finger.visible=false;
                    finger=[FingerObject createFinger:false];
                    finger.scale=0.3;
                    finger.position=ccp(touchPuni.position.x+(finger.contentSize.width*finger.scale)/2,
                                        touchPuni.position.y+(finger.contentSize.height*finger.scale)/2);
                    [self addChild:finger];
                    [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
                }
            }
        }
        
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

    //同じグループだったら経路設定終了
    bool flg=false;;
    for(ParentObject* parent1 in parentArray){
        if([BasicMath RadiusContainsPoint:parent1.position pointB:touchLocation
                                                radius:(parent1.contentSize.width*parent1.scale)/2-5]){
            if(parent1.gpNum==touchPuni.gpNum){
                flg=true;
                touchPuni.touchFlg=false;
                //[touchPuni.posArray removeLastObject];
                [touchPuni.posArray addObject:[NSValue valueWithCGPoint:parent1.position]];
                touchPuni=nil;
            }
        }
    }
    if(!flg){
        if(touchPuni!=nil){
            if(![BasicMath RadiusContainsPoint:touchPuni.position pointB:touchLocation
                                                radius:(touchPuni.contentSize.width*touchPuni.scale)/2]){
                NSValue *value = [NSValue valueWithCGPoint:touchLocation];
                [touchPuni.posArray addObject:value];
            }
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

- (void)onSpeed2xClicked:(id)sender
{
    if(![GameManager getSpeed]){//ノーマルモードだったら
        for(PuniObject* puni1 in puniArray){
            puni1.velocity=puni1.velocity*2;
        }
        speed1xButton.visible=true;
        speed2xButton.visible=false;
        [GameManager setSpeed:true];
    }else{//倍速モードだったら
        for(PuniObject* puni1 in puniArray){
            puni1.velocity=puni1.velocity/2;
        }
        speed1xButton.visible=false;
        speed2xButton.visible=true;
        [GameManager setSpeed:false];
    }
}

- (void)onPauseClicked:(id)sender
{
    if(![GameManager getPause]){//プレイ中だったら
        self.userInteractionEnabled = NO;
        [GameManager setPause:true];
        pauseButton.visible=false;
        resumeButton.visible=true;
        naviLayer.visible=true;
        naviLayer.playbackButton.visible=false;
        naviLayer.titleButton.positionType = CCPositionTypeNormalized;
        naviLayer.titleButton.position = ccp(0.5f, 0.25f);
        naviLayer.titleButton.rotation=0;
        //ADG-SSPバナー
        adgSSP=[[AdGenerLayer alloc]init];
        [self addChild:adgSSP];
        
    }else{//ポーズ中だったら
        self.userInteractionEnabled = YES;
        [GameManager setPause:false];
        pauseButton.visible=true;
        resumeButton.visible=false;
        naviLayer.visible=false;
        //Ad削除
        [adgSSP removeLayer];
    }
}

-(void)post_Twitter
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:[NSString stringWithFormat:
                        @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                        [GameManager load_HighScore],
                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+1];
                 //チケット表示更新
                 [InfoLayer update_Ticket];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}
-(void)post_Facebook
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:[NSString stringWithFormat:
                        @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                        [GameManager load_HighScore],
                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+1];
                 //チケット表示更新
                 [InfoLayer update_Ticket];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

@end
