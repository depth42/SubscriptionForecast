//
//  Subscription.h
//  SubscriptionForecast
//
//  Created by Frank Illenberger on 07.09.17.
//  Copyright © 2017 Frank Illenberger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, SubscriptionType)
{
    SubscriptionTypeApple,
    SubscriptionTypeDirect,
};

@class Forecast;

@interface Subscription : NSObject

@property   (nonatomic, readwrite, weak)    Forecast*           forecast;
@property   (nonatomic, readwrite)          SubscriptionType    subscriptionType;
@property   (nonatomic, readwrite)          NSInteger           period;             // in months
@property   (nonatomic, readwrite)          double              price;
@property   (nonatomic, readwrite)          NSInteger           startMonth;
@property   (nonatomic, readwrite)          double              cancelProbability;

@property   (nonatomic, readonly)           BOOL                needsToRenew;
@property   (nonatomic, readonly)           BOOL                wantsToCancel;
@property   (nonatomic, readonly)           double              revenue;

@end
