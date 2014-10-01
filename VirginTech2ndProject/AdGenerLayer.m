//
//  AdGenerLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/31.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "AdGenerLayer.h"
#import "GameManager.h"

@implementation AdGenerLayer

//@synthesize adg = adg_;

CGSize winSize;

+ (AdGenerLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    NSDictionary *adgparam;
    
    if([GameManager getDevice]==2){//iPhone4
        adgparam = @{
                     @"locationid" : @"17095", //管理画面から払い出された広告枠ID(17095)
                     @"adtype" : @(kADG_AdType_Sp), //管理画面にて入力した枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free
                     @"originx" : @(80), //広告枠設置起点のx座標
                     @"originy" : @(winSize.height-50), //広告枠設置起点のy座標
                     @"w" : @(0), //広告枠横幅
                     @"h" : @(0)  //広告枠高さ
                     };
    }else if([GameManager getDevice]==3){//iPad
        adgparam = @{
                     @"locationid" : @"17094", //管理画面から払い出された広告枠ID(17094)
                     @"adtype" : @(kADG_AdType_Tablet), //管理画面にて入力した枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free
                     @"originx" : @(148), //広告枠設置起点のx座標
                     @"originy" : @(winSize.height*2-90), //広告枠設置起点のy座標
                     @"w" : @(0), //広告枠横幅
                     @"h" : @(0)  //広告枠高さ
                };
    }else{//iPhone5,6
        adgparam = @{
                     @"locationid" : @"17095", //管理画面から払い出された広告枠ID(17095)
                     @"adtype" : @(kADG_AdType_Sp), //管理画面にて入力した枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free
                     @"originx" : @(124), //広告枠設置起点のx座標
                     @"originy" : @(winSize.height-50), //広告枠設置起点のy座標
                     @"w" : @(0), //広告枠横幅
                     @"h" : @(0)  //広告枠高さ
                };
    }
    
    //ADGManagerViewController *adgvc =[[ADGManagerViewController alloc]initWithAdParams:adgparam adView:[[CCDirector sharedDirector]view]];
    
    //adView=[[UIViewController alloc]init];
    //[[[CCDirector sharedDirector]view]addSubview:adView.view];
    
    adg_ =[[ADGManagerViewController alloc]initWithAdParams:adgparam adView:[[CCDirector sharedDirector]view]];
    
    //self.adg = adgvc;
    //[adgvc release];
    
    adg_.delegate = self;
    [adg_ loadRequest];
    
    return self;
}

-(void)removeLayer
{
    adg_.delegate = nil;
    [adg_.view removeFromSuperview];
    adg_ = nil;
}

-(void)dealloc
{
    adg_.delegate = nil;
    //[adView.view removeFromSuperview];
    [adg_.view removeFromSuperview];
    adg_ = nil;

    //[adg_ release];
    //[super dealloc];
}

@end
