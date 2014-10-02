//
//  Credit.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/06/08.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "CreditLayer.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation CreditLayer

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;

+(CreditLayer *)scene{
    
    return [[self alloc] init];
}

-(id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;
    
    /*/タイトル画像
    CCSprite* title=[CCSprite spriteWithImageNamed:@"title.png"];
    title.position=ccp(winSize.width/2,winSize.height/2);
    title.scale=0.5;
    [self addChild:title];*/

    //バックグラウンド
    [self setBackGround];
    
    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    //背景画像拡大
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,1000));
    [image drawInRect:CGRectMake(0, 0, winSize.width,1000)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    [self addChild:scrollView];
    
    //閉じるボタン
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    //CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
    //                         [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"close.png"]];
    CCButton* closeButton=[CCButton buttonWithTitle:@"[閉じる]"];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    //closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];

    //ロゴ
    CCSprite* logo=[CCSprite spriteWithImageNamed:@"virgintech.png"];
    logo.position=ccp(winSize.width/2,850);
    logo.scale=0.3;
    [bgSpLayer addChild:logo];
    
    //開発者
    CCLabelTTF* label;
    
    label=[CCLabelTTF labelWithString:@"Developer" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,720);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"OOTANI,Kenji" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,700);
    [bgSpLayer addChild:label];
    
    //イラストデザイン
    label=[CCLabelTTF labelWithString:@"Illust-Designer" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,620);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"FUKUDA,Makiko" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,600);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"y･omochi" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,580);
    [bgSpLayer addChild:label];
    
    [self setList];
    
    return self;
}

-(void)setList
{
    CCLabelTTF* label;

    label=[CCLabelTTF labelWithString:@"Material by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,530);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ドット絵世界 - yms.main.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,500);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PSD Graphics - www.psdgraphics.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,480);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"やじるし素材天国 - yajidesign.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,460);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"ストックマテリアル - stockmaterial.geo.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,440);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"PHOTO CHIPS - photo-chips.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,420);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"Frame Design - frames-design.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,400);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ジルとチッチの素材ボックス - ocplanning.biz" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,380);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"IconEden - www.iconeden.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,360);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ARCHIGRAPHS - archigraphs.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,340);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"DeviantART - www.deviantart.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,320);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PhotoshopVIP - photoshopvip.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,300);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"～ゲームのゆりかご～ - www.gamecradle.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,280);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"いらすとや - www.irasutoya.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,260);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PremiumPixels - www.premiumpixels.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,240);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"フリー素材 POMO - pomo.vis.ne.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,220);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"Sound by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,180);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"クリプトン・フューチャー・メディア - www.crypton.co.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,150);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ASOBEAT - www.asobeat.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,130);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"魔王魂 - maoudamashii.jokersounds.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,110);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"Special Thanks! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,50);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"ありがとう! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,20);
    [bgSpLayer addChild:label];

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

-(void)onCloseClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:
                                                    [CCTransition transitionCrossFadeWithDuration:1.0]];
    //[ImobileSdkAds showBySpotID:@"295894"];
}
    
@end
