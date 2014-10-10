//
//  PreferencesLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PreferencesLayer.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "SoundManager.h"

@implementation PreferencesLayer

CGSize winSize;

CCSlider* bgmSlider;
CCSlider* effectSlider;
CCButton* onBgmSwitch;
CCButton* offBgmSwitch;
CCButton* onEffectSwitch;
CCButton* offEffectSwitch;

+(PreferencesLayer *)scene
{
    return [[self alloc] init];
}

-(id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;

    //バックグラウンド
    [self setBackGround];
    
    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    //閉じるボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"closeBtn.png"]];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.95f, 0.95f); // Top Right of screen
    closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    //BGM音量
    CCLabelTTF* bgmLabel=[CCLabelTTF labelWithString:@"BGM:" fontName:@"Verdana-Bold" fontSize:20.0];
    bgmLabel.position=ccp(winSize.width/2-100,winSize.height/2+100);
    [self addChild:bgmLabel];
    
    //BGMスイッチ
    onBgmSwitch=[CCButton buttonWithTitle:@""
                              spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onBgmSwitch.position=ccp(bgmLabel.position.x+100,bgmLabel.position.y);
    [onBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    onBgmSwitch.name=@"1";
    
    offBgmSwitch=[CCButton buttonWithTitle:@""
                               spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offBgmSwitch.position=ccp(bgmLabel.position.x+100,bgmLabel.position.y);
    [offBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    offBgmSwitch.name=@"0";
    
    if([SoundManager getBgmSwitch]){
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
    }
    
    [self addChild:onBgmSwitch z:1];
    [self addChild:offBgmSwitch z:1];
    
    
    //BGM音量スライダー
    bgmSlider=[[CCSlider alloc]initWithBackground:
               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bgm_line.png"]
                andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_bgm.png"]];
    bgmSlider.position=ccp(winSize.width/2-bgmSlider.contentSize.width/2,bgmLabel.position.y-50);
    [bgmSlider setSliderValue:[SoundManager getBgmVolume]];
    bgmSlider.name=@"BGM-Volume";
    bgmSlider.handle.scale=0.3;
    [self addChild:bgmSlider];
    
    //エフェクト音量
    CCLabelTTF* effectLabel=[CCLabelTTF labelWithString:@"Effect:" fontName:@"Verdana-Bold" fontSize:20.0];
    effectLabel.position=ccp(winSize.width/2-100,bgmLabel.position.y-100);
    [self addChild:effectLabel];
    
    //Effectスイッチ
    onEffectSwitch=[CCButton buttonWithTitle:@""
                                 spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onEffectSwitch.position=ccp(effectLabel.position.x+100,effectLabel.position.y);
    [onEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    onEffectSwitch.name=@"1";
    
    offEffectSwitch=[CCButton buttonWithTitle:@""
                                  spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offEffectSwitch.position=ccp(effectLabel.position.x+100,effectLabel.position.y);
    [offEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    offEffectSwitch.name=@"0";
    
    if([SoundManager getEffectSwitch]){
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
    }
    
    [self addChild:onEffectSwitch z:1];
    [self addChild:offEffectSwitch z:1];
    
    //エフェクト音量スライダー
    effectSlider=[[CCSlider alloc]initWithBackground:
                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"effect_line.png"]
                    andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_effect.png"]];
    effectSlider.position=ccp(winSize.width/2-effectSlider.contentSize.width/2,bgmLabel.position.y-150);
    [effectSlider setSliderValue:[SoundManager getEffectVolume]];
    effectSlider.name=@"Effect-Volume";
    effectSlider.handle.scale=0.3;
    [self addChild:effectSlider];
    
    return self;
}

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

- (void)bgmSwitchClicked:(id)sender
{
    NSLog(@"押された！");
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
        [SoundManager setBgmSwitch:true];
        [SoundManager playBGM];
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
        [SoundManager setBgmSwitch:false];
        [SoundManager stopBGM];
    }
}
- (void)effectSwitchClicked:(id)sender
{
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
        [SoundManager setEffectSwitch:true];
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
        [SoundManager setEffectSwitch:false];
    }
}

-(void)onCloseClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
