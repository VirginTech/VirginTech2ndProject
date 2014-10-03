//
//  ShopView.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/12.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ShopView.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "InfoLayer.h"

@implementation ShopView

CGSize winSize;
SKProductsRequest *productsRequest;

PaymentManager* paymane;

SKProduct* product01;
SKProduct* product02;
SKProduct* product03;
SKProduct* product04;
SKProduct* product05;

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector] viewSize];
    paymane = [[PaymentManager alloc]init];

    /*/タイトル画像
    CCSprite* title=[CCSprite spriteWithImageNamed:@"title.png"];
    title.position=ccp(winSize.width/2,winSize.height/2);
    title.scale=0.5;
    [self addChild:title];*/
    
    //バックグラウンド
    [self setBackGround];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    //インフォレイヤー
    InfoLayer* infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer];
    
    //閉じるボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"closeBtn.png"]];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.95f, 0.90f); // Top Right of screen
    closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
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

//通知センターから呼ばれるメソッド
-(void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        //NSLog(@"ネットワーク接続がありません。");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"Notnetwork",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
        [alert show];

        return;
        
    }else{
        //NSLog(@"ネットワーク OK !");
    }
}

- (void)onEnter
{
    [super onEnter];
    
    //ネット接続できるか確認
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability: internetReach];
    
    //インジケータの準備
    if([indicator isAnimating]==false)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[[CCDirector sharedDirector] view] addSubview:indicator];
        if([GameManager getDevice]==3){
            indicator.center = ccp(winSize.width, winSize.height);
        }else{
            indicator.center = ccp(winSize.width/2, winSize.height/2);
        }
        [indicator startAnimating];
    }
    //アイテム情報の取得
    [self getItemInfo];
}

-(void)getItemInfo{
    
    NSSet *set = [NSSet setWithObjects:@"VirginTech2ndProject_Ticket10",
                                        @"VirginTech2ndProject_Ticket20",
                                        @"VirginTech2ndProject_Ticket30",
                                        @"VirginTech2ndProject_Ticket50",
                                        @"VirginTech2ndProject_Ticket100",
                                        nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"ItemIdIsInvalid",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"OK",NULL)
                                                        otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    //アイテム情報の取得
    product01=[response.products objectAtIndex:0];// 10Pack
    product02=[response.products objectAtIndex:2];// 20Pack
    product03=[response.products objectAtIndex:3];// 30Pack
    product04=[response.products objectAtIndex:4];// 50Pack
    product05=[response.products objectAtIndex:1];// 100Pack

    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc_default.plist"];
    
    //ダイアパック
    CCSprite* ticket01=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket01.position=ccp(100, winSize.height -100);
    ticket01.scale=0.15;
    [self addChild:ticket01];

    CCSprite* ticket02=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket02.position=ccp(ticket01.position.x, ticket01.position.y -40);
    ticket02.scale=0.15;
    [self addChild:ticket02];

    CCSprite* ticket03=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket03.position=ccp(ticket01.position.x, ticket01.position.y -80);
    ticket03.scale=0.15;
    [self addChild:ticket03];

    CCSprite* ticket04=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket04.position=ccp(ticket01.position.x, ticket01.position.y -120);
    ticket04.scale=0.15;
    [self addChild:ticket04];

    CCSprite* ticket05=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket05.position=ccp(ticket01.position.x, ticket01.position.y -160);
    ticket05.scale=0.15;
    [self addChild:ticket05];

    //ラベル
    CCLabelTTF* label01=[CCLabelTTF labelWithString:product01.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label01.position = ccp(ticket01.position.x+110, ticket01.position.y);
    [self addChild:label01];
    
    CCLabelTTF* label02=[CCLabelTTF labelWithString:product02.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label02.position = ccp(ticket02.position.x+110, ticket02.position.y);
    [self addChild:label02];
    
    CCLabelTTF* label03=[CCLabelTTF labelWithString:product03.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label03.position = ccp(ticket03.position.x+110, ticket03.position.y);
    [self addChild:label03];

    CCLabelTTF* label04=[CCLabelTTF labelWithString:product04.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label04.position = ccp(ticket04.position.x+110, ticket04.position.y);
    [self addChild:label04];

    CCLabelTTF* label05=[CCLabelTTF labelWithString:product05.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label05.position = ccp(ticket05.position.x+110, ticket05.position.y);
    [self addChild:label05];
    
    //購入ボタン
    CCButton* button01=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button01.position = ccp(label01.position.x+130, ticket01.position.y);
    [button01 setTarget:self selector:@selector(button01_Clicked:)];
    button01.scale=0.6;
    [self addChild:button01];
    CCLabelTTF* labelBtn01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product01.priceLocale objectForKey:NSLocaleCurrencySymbol],product01.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn01.position=ccp(button01.contentSize.width/2,button01.contentSize.height/2);
    labelBtn01.color=[CCColor whiteColor];
    [button01 addChild:labelBtn01];

    CCButton* button02=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button02.position = ccp(label02.position.x+130, ticket02.position.y);
    [button02 setTarget:self selector:@selector(button02_Clicked:)];
    button02.scale=0.6;
    [self addChild:button02];
    CCLabelTTF* labelBtn02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product02.priceLocale objectForKey:NSLocaleCurrencySymbol],product02.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn02.position=ccp(button02.contentSize.width/2,button02.contentSize.height/2);
    labelBtn02.color=[CCColor whiteColor];
    [button02 addChild:labelBtn02];

    CCButton* button03=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button03.position = ccp(label03.position.x+130, ticket03.position.y);
    [button03 setTarget:self selector:@selector(button03_Clicked:)];
    button03.scale=0.6;
    [self addChild:button03];
    CCLabelTTF* labelBtn03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product03.priceLocale objectForKey:NSLocaleCurrencySymbol],product03.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn03.position=ccp(button03.contentSize.width/2,button03.contentSize.height/2);
    labelBtn03.color=[CCColor whiteColor];
    [button03 addChild:labelBtn03];

    CCButton* button04=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button04.position = ccp(label04.position.x+130, ticket04.position.y);
    [button04 setTarget:self selector:@selector(button04_Clicked:)];
    button04.scale=0.6;
    [self addChild:button04];
    CCLabelTTF* labelBtn04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product04.priceLocale objectForKey:NSLocaleCurrencySymbol],product04.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn04.position=ccp(button04.contentSize.width/2,button04.contentSize.height/2);
    labelBtn04.color=[CCColor whiteColor];
    [button04 addChild:labelBtn04];

    CCButton* button05=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button05.position = ccp(label05.position.x+130, ticket05.position.y);
    [button05 setTarget:self selector:@selector(button05_Clicked:)];
    button05.scale=0.6;
    [self addChild:button05];
    CCLabelTTF* labelBtn05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product05.priceLocale objectForKey:NSLocaleCurrencySymbol],product05.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn05.position=ccp(button05.contentSize.width/2,button05.contentSize.height/2);
    labelBtn05.color=[CCColor whiteColor];
    [button05 addChild:labelBtn05];
    
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }

}

- (void)onCloseClicked:(id)sender
{
    //プロダクトリクエストをキャンセル
    [productsRequest cancel];
    // インジケータを非表示にする
    if([indicator isAnimating]){
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)button01_Clicked:(id)sender
{
    [paymane buyProduct:product01];
}
- (void)button02_Clicked:(id)sender
{
    [paymane buyProduct:product02];
}
- (void)button03_Clicked:(id)sender
{
    [paymane buyProduct:product03];
}
- (void)button04_Clicked:(id)sender
{
    [paymane buyProduct:product04];
}
- (void)button05_Clicked:(id)sender
{
    [paymane buyProduct:product05];
}

@end
