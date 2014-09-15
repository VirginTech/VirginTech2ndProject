//
//  CircleObject.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PuniObject : CCSprite
{
    float scale;
    float velocity;
    float targetAngle;
    
    bool collisFlg;//連続壁衝突防止
    int collisNum;;//誰と衝突したか
    int objNum;//自分の番号
    int gpNum;//グループ番号
    
    bool startFlg;//入場時判定無効化
    bool endFlg;//終了フラグ
    
    CCLabelTTF* label;
    //CCLabelTTF* label2;
    
    bool manualFlg;//マニュアルモードか
    bool touchFlg;//ルート線種描画変更フラグ
    NSMutableArray* posArray;
    float er,dr;//最終距離、補間距離(途中経過の)
    CGPoint startPos;
    int moveCnt;
}

@property float targetAngle;
@property int collisNum;
@property int objNum;
@property int gpNum;
@property bool manualFlg;
@property NSMutableArray* posArray;
@property int moveCnt;
@property bool touchFlg;
@property bool startFlg;
@property bool endFlg;

+(id)createPuni:(int)objCnt gpNum:(int)gpNum;
-(void)startBlink;

@end
