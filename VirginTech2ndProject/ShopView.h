//
//  ShopView.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/12.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <StoreKit/StoreKit.h>
#import "PaymentManager.h"
#import "Reachability.h"

@class Reachability;

@interface ShopView : CCScene <SKProductsRequestDelegate>
{
    UIActivityIndicatorView* indicator;
}

+ (ShopView *)scene;
- (id)init;

@end
